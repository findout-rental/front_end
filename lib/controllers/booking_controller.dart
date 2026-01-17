import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/models/booking_model.dart';
import 'package:project/services/booking_service.dart';
import 'package:project/data/providers/mock_data_provider.dart';

class BookingController extends GetxController {
  final BookingService _bookingService;
  BookingController(this._bookingService);

  final bool useMockData = false;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final RxList<BookingModel> bookings = <BookingModel>[].obs;

  Timer? _statusTick;

  List<BookingModel> get activeBookings => bookings.where((b) {
    final s = b.effectiveStatus;
    return s == BookingStatus.active || s == BookingStatus.pending;
  }).toList();

  List<BookingModel> get completedBookings => bookings
      .where((b) => b.effectiveStatus == BookingStatus.completed)
      .toList();

  List<BookingModel> get cancelledBookings => bookings
      .where((b) => b.effectiveStatus == BookingStatus.cancelled)
      .toList();

  @override
  void onInit() {
    super.onInit();
    _statusTick = Timer.periodic(const Duration(minutes: 1), (_) {
      if (bookings.isNotEmpty) bookings.refresh();
    });

    useMockData ? _loadMockBookings() : fetchMyBookings();
  }

  @override
  void onClose() {
    _statusTick?.cancel();
    super.onClose();
  }

  void _loadMockBookings() {
    bookings.assignAll([
      BookingModel(
        bookingId: 'booking-1',
        apartment: MockDataProvider.apartments[0],
        dateRange: DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 2)),
          end: DateTime.now().add(const Duration(days: 5)),
        ),
        totalPrice: 2850,
        status: BookingStatus.active,
      ),
      BookingModel(
        bookingId: 'booking-2',
        apartment: MockDataProvider.apartments[3],
        dateRange: DateTimeRange(
          start: DateTime.now().add(const Duration(days: 10)),
          end: DateTime.now().add(const Duration(days: 15)),
        ),
        totalPrice: 2150,
        status: BookingStatus.pending,
      ),
      BookingModel(
        bookingId: 'booking-3',
        apartment: MockDataProvider.apartments[2],
        dateRange: DateTimeRange(
          start: DateTime(2023, 10, 1),
          end: DateTime(2023, 10, 15),
        ),
        totalPrice: 11250,
        status: BookingStatus.completed,
      ),
      BookingModel(
        bookingId: 'booking-4',
        apartment: MockDataProvider.apartments[1],
        dateRange: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 3)),
        ),
        totalPrice: 1250,
        status: BookingStatus.cancelled,
      ),
    ]);
  }

  bool canRateApartment(String apartmentId) {
    final id = apartmentId.toString();

    return bookings.any((b) {
      final bId = b.apartment.id.toString();
      return bId == id && b.isCheckoutPassed;
    });
  }

  Future<void> fetchMyBookings() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _bookingService.getMyBookings();
      final List<dynamic> data = (response.data is Map)
          ? (response.data['data']?['bookings'] as List? ?? [])
          : [];

      bookings.assignAll(
        data
            .whereType<Map>()
            .map((e) => BookingModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );

      // ✅ تحديث سريع للحالات بعد الجلب
      bookings.refresh();
    } catch (e) {
      errorMessage.value = 'Failed to load your bookings.';
      debugPrint('Fetch Bookings Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createBooking({
    required Apartment apartment,
    required DateTimeRange dateRange,
    String paymentMethod = 'cash',
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _bookingService.createBooking(
        apartmentId: apartment.id,
        dateRange: dateRange,
        paymentMethod: paymentMethod,
      );

      await fetchMyBookings();

      Get.snackbar(
        'Success',
        'Your booking has been confirmed!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on dio.DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to create booking.';

      if (data is Map) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstVal = errors.values.first;
          if (firstVal is List && firstVal.isNotEmpty) {
            msg = firstVal.first.toString();
          } else if (data['message'] != null) {
            msg = data['message'].toString();
          }
        } else if (data['message'] != null) {
          msg = data['message'].toString();
        }
      }

      Get.snackbar(
        'Error',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      debugPrint('Create Booking Error: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _bookingService.cancelBooking(bookingId);

      final index = bookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) {
        bookings[index] = bookings[index].copyWith(rawStatus: 'cancelled');
      }

      bookings.refresh();

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
      debugPrint('Cancel Booking Error: $e');
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

      await fetchMyBookings();

      Get.back();
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
      debugPrint('Update Booking Error: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
