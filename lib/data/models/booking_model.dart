// lib/data/models/booking_model.dart

import 'package:flutter/material.dart';
import 'package:project/data/models/apartment_model.dart';

/// يمثل الحالات المختلفة للحجز
enum BookingStatus { active, completed, cancelled, unknown }

class BookingModel {
  final String bookingId;
  final Apartment apartment;
  final DateTimeRange dateRange;
  final int totalPrice;
  BookingStatus status;

  BookingModel({
    required this.bookingId,
    required this.apartment,
    required this.dateRange,
    required this.totalPrice,
    this.status = BookingStatus.active,
  });

  /// ✅ دالة Factory لتحويل JSON القادم من الخادم إلى كائن BookingModel
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // دالة مساعدة لتحويل نص الحالة إلى enum
    BookingStatus parseStatus(String? statusString) {
      switch (statusString) {
        case 'active':
          return BookingStatus.active;
        case 'completed':
          return BookingStatus.completed;
        case 'cancelled':
          return BookingStatus.cancelled;
        default:
          return BookingStatus.unknown;
      }
    }

    // ⚠️ تأكد من أن أسماء الحقول ('id', 'status', 'apartment', etc.)
    // تتطابق تمامًا مع ما يرسله خادم لارافيل.
    return BookingModel(
      // استخدام .toString() للتعامل مع id سواء كان int أو String
      bookingId: json['id']?.toString() ?? '',

      // استخدام Apartment.fromJson لتحويل كائن الشقة المتداخل
      apartment: Apartment.fromJson(json['apartment'] ?? {}),

      // بناء DateTimeRange من start_date و end_date
      dateRange: DateTimeRange(
        start: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
        end: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      ),

      totalPrice: json['total_price'] ?? 0,

      status: parseStatus(json['status']),
    );
  }
}
