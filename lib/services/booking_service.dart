//booking_service.dart
// lib/services/booking_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/dio_client.dart';

class BookingService {
  final DioClient _dioClient;
  BookingService(this._dioClient);

  /// يجلب قائمة حجوزات المستخدم الحالي (للمستأجر)
  Future<Response> getMyBookings() {
    return _dioClient.get(ApiEndpoints.bookings);
  }

  /// ✅ ينشئ حجزًا جديدًا (للمستأجر)
  Future<Response> createBooking({
    required String apartmentId,
    required DateTimeRange dateRange,
    String paymentMethod = 'cash', // ✅ افتراضي (عدّله إذا الباك بده قيمة مختلفة)
  }) {
    return _dioClient.post(
      ApiEndpoints.bookings,
      data: {
        'apartment_id': apartmentId,
        // ✅ أسماء مطابقة للباك
        'check_in_date': dateRange.start.toIso8601String().substring(0, 10),
        'check_out_date': dateRange.end.toIso8601String().substring(0, 10),
        // ✅ مطلوب من الباك
        'payment_method': paymentMethod,
      },
    );
  }

  /// يلغي حجزًا (للمستأجر)
  Future<Response> cancelBooking(String bookingId) {
    return _dioClient.post('${ApiEndpoints.bookings}/$bookingId/cancel');
  }

  /// ✅ تحديث حجز
  Future<Response> updateBooking({
    required String bookingId,
    required DateTimeRange newDateRange,
    String paymentMethod = 'cash',
  }) {
    return _dioClient.put(
      '${ApiEndpoints.bookings}/$bookingId',
      data: {
        'check_in_date': newDateRange.start.toIso8601String().substring(0, 10),
        'check_out_date': newDateRange.end.toIso8601String().substring(0, 10),
        'payment_method': paymentMethod,
      },
    );
  }
}
