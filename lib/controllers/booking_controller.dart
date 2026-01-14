import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/models/booking_model.dart';
import 'package:project/services/booking_service.dart';
import 'package:project/data/providers/mock_data_provider.dart';

class BookingController extends GetxController {
  // ===============================
  // DEPENDENCY
  // ===============================
  final BookingService _bookingService;

  BookingController(this._bookingService);

  // ===============================
  // CONFIG
  // ===============================
  /// فعّل هذا المتغير أثناء التطوير فقط
  final bool useMockData = false;

  // ===============================
  // STATE
  // ===============================
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final RxList<BookingModel> bookings = <BookingModel>[].obs;

  // ===============================
  // GETTERS
  // ===============================
  List<BookingModel> get activeBookings =>
      bookings.where((b) => b.status == BookingStatus.active).toList();

  List<BookingModel> get completedBookings =>
      bookings.where((b) => b.status == BookingStatus.completed).toList();

  List<BookingModel> get cancelledBookings =>
      bookings.where((b) => b.status == BookingStatus.cancelled).toList();

  // ===============================
  // LIFECYCLE
  // ===============================
  @override
  void onInit() {
    super.onInit();
    useMockData ? _loadMockBookings() : fetchMyBookings();
  }

  // ===============================
  // DATA SOURCES
  // ===============================
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
        status: BookingStatus.active,
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

  // ===============================
  // API ACTIONS
  // ===============================
  Future<void> fetchMyBookings() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _bookingService.getMyBookings();
      final List<dynamic> data =
    response.data['data']?['bookings'] ?? [];


      bookings.assignAll(
        data.map((json) => BookingModel.fromJson(json)).toList(),
      );
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
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _bookingService.createBooking(
        apartmentId: apartment.id,
        dateRange: dateRange,
      );

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
        bookings[index].status = BookingStatus.cancelled;
        bookings.refresh();
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
      debugPrint('Cancel Booking Error: $e');
    }
  }
}
