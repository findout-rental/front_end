// apartment_controller.dart
import 'package:get/get.dart' hide FormData;
import 'package:dio/dio.dart' as dio;
import 'package:project/core/storage/auth_storage.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/services/apartment_service.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/controllers/auth_controller.dart';

class ApartmentController extends GetxController {
  final ApartmentService _apartmentService;
  final FavoriteService _favoriteService;
  final AuthService _authService;
  final AuthStorage _authStorage;

  ApartmentController(
    this._apartmentService,
    this._favoriteService,
    this._authService,
    this._authStorage,
  );

  // ✅ تحميل افتراضي = false (أفضل من true)
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final allApartments = <Apartment>[].obs;
  final filteredApartments = <Apartment>[].obs;

  List<Apartment> get favoriteApartments =>
      allApartments.where((apt) => apt.isFavorited).toList();

  // ---------------------------------------------------------------------------
  // Role resolution (الأهم)
  // نعتمد أولاً على AuthController.currentUser لأنه أكيد موجود بعد login
  // وبعدين fallback على AuthStorage.user إن وُجد
  // ---------------------------------------------------------------------------
  String? get _roleFromAuthController {
    try {
      final auth = Get.find<AuthController>();
      final user = auth.currentUser.value;
      if (user == null) return null;
      if (user.isOwner) return 'owner';
      if (user.isTenant) return 'tenant';
      return user.role.name; // fallback
    } catch (_) {
      return null;
    }
  }

  String? get _roleFromStorage => _authStorage.user?['role']?.toString();

  String? get role => _roleFromAuthController ?? _roleFromStorage;

  bool get isOwner => role == 'owner';
  bool get isTenant => role == 'tenant';

  @override
  void onInit() {
    super.onInit();

    // ✅ إذا المستخدم جاهز -> fetch فوراً
    // ✅ إذا ليس جاهز -> نراقب currentUser وأول ما يصير غير null نعمل fetch مرة واحدة
    _setupAutoFetchOnLogin();
  }

  void _setupAutoFetchOnLogin() {
    AuthController? auth;
    try {
      auth = Get.find<AuthController>();
    } catch (_) {
      auth = null;
    }

    if (auth?.currentUser.value != null) {
      fetchApartments();
      return;
    }

    if (auth != null) {
      ever(auth.currentUser, (u) {
        if (u != null && allApartments.isEmpty && !isLoading.value) {
          fetchApartments();
        }
      });
    }
  }

  // =========================
  // FETCH
  // =========================
  Future<void> fetchApartments({Map<String, dynamic>? filters}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // ✅ إذا ما عنا role لسه (قبل login) لا تعمل request
      if (role == null) {
        // نخليها بدون خطأ، بس نوقف التحميل
        return;
      }

      // ✅ 1) اختار endpoint حسب role
      final apartmentsFuture = isOwner
          ? _apartmentService.getOwnerApartments(filters: filters)
          : _apartmentService.getApartments(filters: filters);

      dio.Response apartmentsResponse;
      dio.Response? favoritesResponse;

      // ✅ 2) favorites فقط للـ tenant
      if (isTenant) {
        final responses = await Future.wait([
          apartmentsFuture,
          _favoriteService.getFavoriteApartmentIds(),
        ]);
        apartmentsResponse = responses[0] as dio.Response;
        favoritesResponse = responses[1] as dio.Response;
      } else {
        apartmentsResponse = await apartmentsFuture;
      }

      // ✅ 3) استخراج الشقق
      final apartmentData = _extractApartmentsList(apartmentsResponse.data);

      final fetchedList = apartmentData
          .whereType<Map>()
          .map((e) => Apartment.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // ✅ 4) استخراج المفضلة (Tenant فقط)
      final favoriteIds = <String>{};

      if (isTenant && favoritesResponse != null) {
        final favRaw = favoritesResponse.data;
        final favList = _extractFavoritesList(favRaw);
        favoriteIds.addAll(favList.map((e) => e.toString()));
      }

      for (final apartment in fetchedList) {
        apartment.isFavorited = favoriteIds.contains(apartment.id.toString());
      }

      allApartments.assignAll(fetchedList);
      filteredApartments.assignAll(fetchedList);
    } catch (e) {
      errorMessage.value = 'Failed to load apartments';
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  List<dynamic> _extractApartmentsList(dynamic raw) {
    if (raw is! Map<String, dynamic>) return [];

    final data = raw['data'];

    // { data: { apartments: [...] } }
    if (data is Map<String, dynamic> && data['apartments'] is List) {
      return List<dynamic>.from(data['apartments']);
    }

    // { data: [...] }
    if (data is List) {
      return List<dynamic>.from(data);
    }

    // { apartments: [...] }
    if (raw['apartments'] is List) {
      return List<dynamic>.from(raw['apartments']);
    }

    // { data: { items: [...] } }
    if (data is Map<String, dynamic> && data['items'] is List) {
      return List<dynamic>.from(data['items']);
    }

    // { data: { data: { apartments: [...] } } }
    if (data is Map<String, dynamic> &&
        data['data'] is Map<String, dynamic> &&
        (data['data'] as Map<String, dynamic>)['apartments'] is List) {
      return List<dynamic>.from(
        (data['data'] as Map<String, dynamic>)['apartments'],
      );
    }

    return [];
  }

  List<dynamic> _extractFavoritesList(dynamic raw) {
    if (raw is! Map<String, dynamic>) return [];
    final data = raw['data'];

    // { data: [ ... ] }
    if (data is List) return data;

    // { data: { ids: [ ... ] } }
    if (data is Map<String, dynamic> && data['ids'] is List) {
      return List<dynamic>.from(data['ids']);
    }

    return [];
  }

  // =========================
  // ADD APARTMENT
  // =========================
  Future<bool> addApartment(dio.FormData formData) async {
    final auth = Get.find<AuthController>();
    if (auth.currentUser.value?.isOwner != true) {
      Get.snackbar('خطأ', 'هذه العملية خاصة بالمالك فقط');
      return false;
    }

    try {
      isLoading.value = true;
      await _apartmentService.addApartment(formData);

      // ✅ بعد الإضافة: جيب بيانات owner مباشرة
      await fetchApartments();

      Get.snackbar('نجاح', 'تمت إضافة الشقة بنجاح');
      return true;
    } on dio.DioException catch (e) {
  final data = e.response?.data;

  final String msg = (data is Map && data['message'] != null)
      ? data['message'].toString()
      : 'فشل إضافة الشقة';

  Get.snackbar('خطأ', msg);
  return false;
}
 finally {
      isLoading.value = false;
    }
  }

  // =========================
  // FAVORITES
  // =========================
  Future<void> toggleFavoriteStatus(String apartmentId) async {
    // ✅ ممنوع للـ owner (لأنه endpoint Tenant)
    if (!isTenant) return;

    final index = allApartments.indexWhere((apt) => apt.id == apartmentId);
    if (index == -1) return;

    final apartment = allApartments[index];
    final originalStatus = apartment.isFavorited;

    apartment.isFavorited = !originalStatus;
    allApartments.refresh();
    filteredApartments.refresh();

    try {
      originalStatus
          ? await _favoriteService.removeFromFavorites(apartmentId)
          : await _favoriteService.addToFavorites(apartmentId);
    } catch (e) {
      apartment.isFavorited = originalStatus;
      allApartments.refresh();
      filteredApartments.refresh();
    }
  }
}
