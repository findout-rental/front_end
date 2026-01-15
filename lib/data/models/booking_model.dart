import 'package:flutter/material.dart';
import 'package:project/data/models/apartment_model.dart';

/// يمثل الحالات المختلفة للحجز
enum BookingStatus {
  active,
  completed,
  cancelled,
  unknown,
}

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

  // ===============================
  // FACTORIES
  // ===============================

  /// تحويل JSON القادم من الخادم إلى BookingModel
  factory BookingModel.fromJson(Map<String, dynamic> json) {
  BookingStatus parseStatus(String? status) {
    switch (status) {
      case 'pending':
      case 'approved':
        return BookingStatus.active;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
      case 'rejected':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.unknown;
    }
  }

  return BookingModel(
    bookingId: json['id']?.toString() ?? '',
    apartment: Apartment.fromJson(json['apartment'] ?? {}),
    dateRange: DateTimeRange(
      start: DateTime.tryParse(json['check_in_date'] ?? '') ?? DateTime.now(),
      end: DateTime.tryParse(json['check_out_date'] ?? '') ?? DateTime.now(),
    ),
    totalPrice: json['total_rent'] ?? 0,
    status: parseStatus(json['status']),
  );
}


  // ===============================
  // HELPERS (اختياري لكن مفيد)
  // ===============================
  bool get isActive => status == BookingStatus.active;
  bool get isCompleted => status == BookingStatus.completed;
  bool get isCancelled => status == BookingStatus.cancelled;
}
