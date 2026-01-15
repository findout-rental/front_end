// lib/controllers/booking_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/models/booking_model.dart';
import 'package:project/services/booking_service.dart';

class BookingController extends GetxController {
  // --- DEPENDENCY ---
  final BookingService _bookingService;

  // ✅ المنشئ الذي يستقبل الاعتمادية
  BookingController(this._bookingService);

  // --- REACTIVE STATE ---
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// القائمة الرئيسية التفاعلية التي تحتوي على جميع حجوزات المستخدم
  final RxList<BookingModel> bookings = <BookingModel>[].obs;

  // --- GETTERS ---
  /// خاصية محسوبة لفلترة الحجوزات النشطة
  List<BookingModel> get activeBookings =>
      bookings.where((b) => b.status == BookingStatus.active).toList();

  /// خاصية محسوبة لفلترة الحجوزات المكتملة
  List<BookingModel> get completedBookings =>
      bookings.where((b) => b.status == BookingStatus.completed).toList();

  /// خاصية محسوبة لفلترة الحجوزات الملغاة
  List<BookingModel> get cancelledBookings =>
      bookings.where((b) => b.status == BookingStatus.cancelled).toList();

  // --- LIFECYCLE ---
  @override
  void onInit() {
    super.onInit();
    fetchMyBookings();
  }

  // --- PUBLIC METHODS (ACTIONS) ---

  /// يجلب قائمة حجوزات المستخدم الحالي من الخادم.
  Future<void> fetchMyBookings() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _bookingService.getMyBookings();
      final List<dynamic> data = response.data['data'] ?? [];

      // ⚠️ تأكد من أن BookingModel يحتوي على دالة .fromJson
      final fetchedList = data
          .map((json) => BookingModel.fromJson(json))
          .toList();
      bookings.assignAll(fetchedList);
    } catch (e) {
      errorMessage.value = 'Failed to load your bookings.';
      print("Fetch Bookings Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ينشئ حجزًا جديدًا عبر الخادم.
  Future<void> createBooking({
    required Apartment apartment,
    required DateTimeRange dateRange,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _bookingService.createBooking(
        apartmentId: apartment.id,
        dateRange: dateRange,
      );

      // بعد النجاح، قم بتحديث قائمة الحجوزات من الخادم
      await fetchMyBookings();

      Get.snackbar(
        'Success',
        'Your booking has been confirmed!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create booking. The dates might be unavailable.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Create Booking Error: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ يلغي حجزًا باستخدام الـ ID الخاص به.
  Future<void> cancelBooking(String bookingId) async {
    // يمكنك إضافة متغير تحميل خاص هنا إذا أردت
    // final isCancelling = true.obs;

    try {
      // استدعاء الخدمة لإلغاء الحجز في الخادم
      await _bookingService.cancelBooking(bookingId);

      // تحديث الحالة محليًا لتجربة مستخدم فورية
      final index = bookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) {
        bookings[index].status = BookingStatus.cancelled;
        bookings.refresh(); // أخبر GetX أن عنصرًا داخل القائمة قد تغير
      }

      Get.snackbar(
        'Success',
        'Booking has been cancelled successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to cancel booking.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      print("Cancel Booking Error: $e");
    } finally {
      // isCancelling.value = false;
    }
  }

  Future<void> updateBooking({
    required String bookingId,
    required DateTimeRange newDateRange,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _bookingService.updateBooking(
        bookingId: bookingId,
        newDateRange: newDateRange,
      );

      // بعد النجاح، قم بتحديث قائمة الحجوزات
      await fetchMyBookings();

      Get.back(); // العودة من صفحة التعديل
      Get.snackbar(
        'Success',
        'Your booking has been updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value =
          'Failed to update booking. The new dates might be unavailable.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      print("Update Booking Error: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
