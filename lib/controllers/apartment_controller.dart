// lib/controllers/apartment_controller.dart

import 'package:get/get.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/services/apartment_service.dart';
import 'package:project/services/favorite_service.dart'; // ✅ استيراد الخدمة الجديدة

class ApartmentController extends GetxController {
  // --- DEPENDENCIES ---
  // يتم حقن الخدمات تلقائيًا عند استدعاء Get.find()
  // final ApartmentService _apartmentService = Get.find<ApartmentService>();
  // final FavoriteService _favoriteService = Get.find<FavoriteService>();
final ApartmentService _apartmentService;
  final FavoriteService _favoriteService;
  ApartmentController(this._apartmentService, this._favoriteService);
  // --- REACTIVE STATE ---
  /// حالة التحميل العامة للشاشة
  final isLoading = true.obs;

  /// رسالة الخطأ لعرضها في الواجهة
  final errorMessage = ''.obs;

  /// القائمة الرئيسية التي تحتوي على جميع الشقق التي تم جلبها من الخادم.
  /// هذه هي "مصدر الحقيقة" (Source of Truth).
  final allApartments = <Apartment>[].obs;

  /// قائمة الشقق التي يتم عرضها حاليًا في الواجهة.
  /// يتم تعديلها بناءً على البحث أو الفلترة.
  final filteredApartments = <Apartment>[].obs;

  // --- GETTERS ---
  /// خاصية محسوبة (computed property) تقوم بفلترة الشقق المفضلة فقط.
  /// Obx الذي يستخدمها سيتم تحديثه تلقائيًا عند تغير `allApartments`.
  List<Apartment> get favoriteApartments =>
      allApartments.where((apt) => apt.isFavorited).toList();

  // --- LIFECYCLE ---
  @override
  void onInit() {
    super.onInit();
    // جلب الشقق عند بدء تشغيل المراقب لأول مرة
    fetchApartments();
  }

  // --- PUBLIC METHODS (ACTIONS) ---

  /// يجلب قائمة الشقق من الخادم، مع دمج حالة المفضلة.
  Future<void> fetchApartments({Map<String, dynamic>? filters}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1. جلب قائمة الشقق وقائمة IDs المفضلة في نفس الوقت لتحسين الأداء
      final responses = await Future.wait([
        _apartmentService.getApartments(filters: filters),
        _favoriteService.getFavoriteApartmentIds(),
      ]);

      // 2. معالجة استجابة الشقق
      // ⚠️ افترض أن لارافيل تعيد قائمة الشقق داخل مفتاح 'data'
      final List<dynamic> apartmentData = responses[0].data['data'] ?? [];
      final List<Apartment> fetchedList = apartmentData
          .map((json) => Apartment.fromJson(json))
          .toList();
      await _apartmentService.getApartments(filters: filters);

      // 3. معالجة استجابة المفضلة
      // ⚠️ افترض أن لارافيل تعيد قائمة من IDs
      final List<dynamic> favoriteIdData = responses[1].data['data'] ?? [];
      // تحويل IDs إلى Set للبحث السريع (أسرع من List.contains)
      final Set<String> favoriteIds = favoriteIdData
          .map((id) => id.toString())
          .toSet();

      // 4. دمج القائمتين: تحديث حالة isFavorited لكل شقة
      for (var apartment in fetchedList) {
        // تحقق مما إذا كان ID الشقة موجودًا في مجموعة IDs المفضلة
        if (favoriteIds.contains(apartment.id.toString())) {
          apartment.isFavorited = true;
        }
      }

      // 5. تحديث الحالة التفاعلية
      allApartments.assignAll(fetchedList);
      filteredApartments.assignAll(
        fetchedList,
      ); // في البداية، القائمة المفلترة هي نفسها
    } catch (e) {
      errorMessage.value = 'Failed to load apartments. Please try again.';
      print("Error fetching apartments: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// يبحث في قائمة الشقق محليًا عن طريق العنوان أو الموقع.
  void searchApartments(String query) {
    if (query.isEmpty) {
      // إذا كان البحث فارغًا، اعرض جميع الشقق
      filteredApartments.assignAll(allApartments);
    } else {
      final lowerCaseQuery = query.toLowerCase();
      final result = allApartments.where((apartment) {
        final titleMatch = apartment.title.toLowerCase().contains(
          lowerCaseQuery,
        );
        final locationMatch = apartment.location.toLowerCase().contains(
          lowerCaseQuery,
        );
        return titleMatch || locationMatch;
      }).toList();
      filteredApartments.assignAll(result);
    }
  }

  /// يضيف أو يزيل شقة من المفضلة باستخدام نمط "التحديث المتفائل".
  Future<void> toggleFavoriteStatus(String apartmentId) async {
    final index = allApartments.indexWhere((apt) => apt.id == apartmentId);
    if (index == -1) return;

    final apartment = allApartments[index];
    final originalStatus = apartment.isFavorited;

    // 1. التحديث المتفائل: تحديث الواجهة فورًا لتحسين تجربة المستخدم
    apartment.isFavorited = !originalStatus;
    allApartments.refresh(); // أخبر GetX أن الكائن داخل القائمة قد تغير

    // 2. إرسال الطلب إلى الخادم في الخلفية
    try {
      if (originalStatus) {
        // إذا كانت في المفضلة، قم بحذفها
        await _favoriteService.removeFromFavorites(apartmentId);
      } else {
        // إذا لم تكن، قم بإضافتها
        await _favoriteService.addToFavorites(apartmentId);
      }
    } catch (e) {
      // 3. في حالة فشل الطلب، قم بإرجاع الحالة إلى ما كانت عليه
      Get.snackbar(
        'Error',
        'Failed to update favorites. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
      );
      // إرجاع الحالة في allApartments
      allApartments[index].isFavorited = originalStatus;
      allApartments.refresh();
      print("Toggle Favorite Error: $e");
    }
  }
}
