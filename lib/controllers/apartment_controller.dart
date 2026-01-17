import 'package:get/get.dart' hide FormData;
import 'package:dio/dio.dart' as dio;
import 'dart:async';
import 'package:project/core/storage/auth_storage.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/services/apartment_service.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/services/favorite_service.dart';

class ApartmentController extends GetxController {
  final ApartmentService _apartmentService;
  final FavoriteService _favoriteService;
  final AuthService _authService;
  final AuthStorage _authStorage;
  final activeFilters = <String, dynamic>{}.obs;
  Timer? _searchDebounce;

  ApartmentController(
    this._apartmentService,
    this._favoriteService,
    this._authService,
    this._authStorage,
  );

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final allApartments = <Apartment>[].obs;
  final filteredApartments = <Apartment>[].obs;

  List<Apartment> get favoriteApartments =>
      allApartments.where((apt) => apt.isFavorited).toList();

  String? get _roleFromAuthController {
    try {
      final auth = Get.find<AuthController>();
      final user = auth.currentUser.value;
      if (user == null) return null;
      if (user.isOwner) return 'owner';
      if (user.isTenant) return 'tenant';
      return user.role.name;
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

  Map<String, dynamic> _normalizeFilters(Map<String, dynamic> input) {
    final out = <String, dynamic>{};

    input.forEach((k, v) {
      if (v == null) return;
      if (v is String && v.trim().isEmpty) return;
      if (v is List && v.isEmpty) return;
      out[k] = v;
    });

    if (out['amenities'] is List) {
      out['amenities[]'] = out.remove('amenities');
    }

    return out;
  }

  void applyFilters(Map<String, dynamic> filters) {
    final normalized = _normalizeFilters(filters);
    activeFilters.assignAll(normalized);
    fetchApartments(filters: normalized);
  }

  void clearFilters() {
    activeFilters.clear();
    fetchApartments(filters: const {});
  }

  Future<void> fetchApartments({Map<String, dynamic>? filters}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      if (role == null) return;
      final normalized = _normalizeFilters(
        filters ?? Map<String, dynamic>.from(activeFilters),
      );
      if (filters != null) activeFilters.assignAll(normalized);

      final apartmentsFuture = isOwner
          ? _apartmentService.getOwnerApartments(filters: normalized)
          : _apartmentService.getApartments(filters: normalized);

      dio.Response apartmentsResponse;
      dio.Response? favoritesResponse;

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

      final apartmentData = _extractApartmentsList(apartmentsResponse.data);

      final fetchedList = apartmentData
          .whereType<Map>()
          .map((e) => Apartment.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      final favoriteIds = <String>{};
      if (isTenant && favoritesResponse != null) {
        final favList = _extractFavoritesList(favoritesResponse.data);
        favoriteIds.addAll(favList.map((e) => e.toString()));
      }

      for (final apartment in fetchedList) {
        final idStr = apartment.id.toString();
        apartment.isFavorited = favoriteIds.contains(idStr);
      }

      allApartments.assignAll(fetchedList);
      filteredApartments.assignAll(fetchedList);
    } catch (e) {
      errorMessage.value = 'Failed to load apartments';
    } finally {
      isLoading.value = false;
    }
  }

  void searchApartments(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      final q = query.trim();
      final next = Map<String, dynamic>.from(activeFilters);

      if (q.isEmpty) {
        next.remove('search');
      } else {
        next['search'] = q;
      }

      applyFilters(next);
    });
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }

  List<dynamic> _extractApartmentsList(dynamic raw) {
    if (raw is! Map<String, dynamic>) return [];

    final data = raw['data'];

    if (data is Map<String, dynamic> && data['apartments'] is List) {
      return List<dynamic>.from(data['apartments']);
    }

    if (data is List) {
      return List<dynamic>.from(data);
    }

    if (raw['apartments'] is List) {
      return List<dynamic>.from(raw['apartments']);
    }

    if (data is Map<String, dynamic> && data['items'] is List) {
      return List<dynamic>.from(data['items']);
    }

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

    if (data is List) return data;

    if (data is Map<String, dynamic> && data['ids'] is List) {
      return List<dynamic>.from(data['ids']);
    }

    return [];
  }

  Future<bool> addApartment(dio.FormData formData) async {
    final auth = Get.find<AuthController>();
    if (auth.currentUser.value?.isOwner != true) {
      Get.snackbar('خطأ', 'هذه العملية خاصة بالمالك فقط');
      return false;
    }

    try {
      isLoading.value = true;

      await _apartmentService.addApartment(formData);

      await fetchApartments();

      Get.snackbar('نجاح', 'تمت إضافة الشقة بنجاح');
      return true;
    } on dio.DioException catch (e) {
      final data = e.response?.data;
      String msg = 'فشل إضافة الشقة';

      if (data is Map) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstKey = errors.keys.first;
          final firstVal = errors[firstKey];
          if (firstVal is List && firstVal.isNotEmpty) {
            msg = firstVal.first.toString();
          }
        } else if (data['message'] != null) {
          msg = data['message'].toString();
        }
      }

      Get.snackbar('خطأ', msg);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavoriteStatus(String apartmentId) async {
    if (!isTenant) return;

    final index = allApartments.indexWhere(
      (apt) => apt.id.toString() == apartmentId,
    );
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
