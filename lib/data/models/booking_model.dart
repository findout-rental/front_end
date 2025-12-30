// lib/data/models/booking_model.dart

import 'package:flutter/material.dart';
import 'package:project/data/models/apartment_model.dart' show Apartment;

enum BookingStatus { active, completed, cancelled }

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
}
