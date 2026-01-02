import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/models/booking_model.dart';
import '../data/providers/mock_data_provider.dart';

class BookingController extends GetxController {
  // القائمة الأساسية (Reactive)
  final RxList<BookingModel> _bookings = <BookingModel>[
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
  ].obs;

  // 👇 Getters (بدون notifyListeners)
  List<BookingModel> get activeBookings =>
      _bookings.where((b) => b.status == BookingStatus.active).toList();

  List<BookingModel> get completedBookings =>
      _bookings.where((b) => b.status == BookingStatus.completed).toList();

  List<BookingModel> get cancelledBookings =>
      _bookings.where((b) => b.status == BookingStatus.cancelled).toList();

  // ➕ إضافة حجز
  void addBooking(
    Apartment apartment,
    DateTimeRange dateRange,
    int totalPrice,
  ) {
    final newBooking = BookingModel(
      bookingId: DateTime.now().millisecondsSinceEpoch.toString(),
      apartment: apartment,
      dateRange: dateRange,
      totalPrice: totalPrice,
      status: BookingStatus.active,
    );

    _bookings.insert(0, newBooking);
  }

  // ❌ إلغاء حجز
  void cancelBookingByApartmentId(String apartmentId) {
    final booking = _bookings.firstWhereOrNull(
      (b) => b.apartment.id == apartmentId &&
          b.status == BookingStatus.active,
    );

    if (booking != null) {
      booking.status = BookingStatus.cancelled;
      _bookings.refresh(); // 👈 مهم
    }
  }
}
