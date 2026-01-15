import 'package:get/get.dart' hide FormData;
import 'package:dio/dio.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/services/apartment_service.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/auth_service.dart';

class ApartmentController extends GetxController {
  // --- DEPENDENCIES ---
  final ApartmentService _apartmentService;
  final FavoriteService _favoriteService;
  final AuthService _authService;

  // Constructor for explicit dependency injection
  ApartmentController(
    this._apartmentService,
    this._favoriteService,
    this._authService,
  );

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final allApartments = <Apartment>[].obs;
  final filteredApartments = <Apartment>[].obs;

  List<Apartment> get favoriteApartments =>
      allApartments.where((apt) => apt.isFavorited).toList();

  @override
  void onInit() {
    super.onInit();
    fetchApartments();
  }

  // =========================
  // FETCH
  // =========================
  Future<void> fetchApartments({Map<String, dynamic>? filters}) async {
    try {
      isLoading.value = true;
      final responses = await Future.wait([
        _apartmentService.getApartments(filters: filters),
        _favoriteService.getFavoriteApartmentIds(),
      ]);

      final List<dynamic> apartmentData = responses[0].data['data'] ?? [];
      final fetchedList = apartmentData
          .map((e) => Apartment.fromJson(e))
          .toList();

      final List<dynamic> favoriteIdData = responses[1].data['data'] ?? [];
      final favoriteIds = favoriteIdData.map((e) => e.toString()).toSet();

      for (final apartment in fetchedList) {
        apartment.isFavorited = favoriteIds.contains(apartment.id);
      }

      allApartments.assignAll(fetchedList);
      filteredApartments.assignAll(fetchedList);
    } catch (e) {
      errorMessage.value = 'Failed to load apartments';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // SEARCH (from your branch)
  // =========================
  void searchApartments(String query) {
    // لا تقم بالبحث إذا كان النص فارغًا، فقط أعد جلب القائمة الكاملة
    if (query.isEmpty) {
      fetchApartments(); // إعادة جلب بدون فلاتر
    } else {
      // أرسل استعلام البحث كفلتر إلى الخادم
      fetchApartments(filters: {'search': query});
    }
  }

  // =========================
  // ADD APARTMENT (from OTP branch)
  // =========================
  Future<bool> addApartment(FormData formData) async {
    try {
      isLoading.value = true;
      await _apartmentService.addApartment(formData);
      await fetchApartments();
      Get.snackbar('نجاح', 'تمت إضافة الشقة بنجاح');
      return true;
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'فشل إضافة الشقة';
      if (data is Map) {
        // لو في errors (Laravel validation)
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
    }
  }

  // =========================
  // FAVORITES
  // =========================
  Future<void> toggleFavoriteStatus(String apartmentId) async {
    final index = allApartments.indexWhere((apt) => apt.id == apartmentId);
    if (index == -1) return;

    final apartment = allApartments[index];
    final originalStatus = apartment.isFavorited;

    apartment.isFavorited = !originalStatus;
    allApartments.refresh();

    try {
      originalStatus
          ? await _favoriteService.removeFromFavorites(apartmentId)
          : await _favoriteService.addToFavorites(apartmentId);
    } catch (e) {
      apartment.isFavorited = originalStatus;
      allApartments.refresh();
    }
  }
}
