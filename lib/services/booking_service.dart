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
    // يتصل بـ GET /api/bookings (مسار المستأجر)
    return _dioClient.get(ApiEndpoints.bookings);
  }

  /// ينشئ حجزًا جديدًا (للمستأجر)
  Future<Response> createBooking({
    required String apartmentId,
    required DateTimeRange dateRange,
  }) {
    // يتصل بـ POST /api/bookings (مسار المستأجر)
    return _dioClient.post(
      ApiEndpoints.bookings,
      data: {
        'apartment_id': apartmentId,
        'start_date': dateRange.start.toIso8601String().substring(
          0,
          10,
        ), // YYYY-MM-DD
        'end_date': dateRange.end.toIso8601String().substring(
          0,
          10,
        ), // YYYY-MM-DD
      },
    );
  }

  /// يلغي حجزًا (للمستأجر)
  Future<Response> cancelBooking(String bookingId) {
    // يتصل بـ POST /api/bookings/{id}/cancel
    return _dioClient.post('${ApiEndpoints.bookings}/$bookingId/cancel');
  }
}
