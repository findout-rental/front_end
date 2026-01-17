import 'package:flutter/material.dart';
import 'package:project/data/models/apartment_model.dart';

/// ✅ حالات الواجهة (ثابتة)
enum BookingStatus { pending, active, completed, cancelled, unknown }

class BookingModel {
  final String bookingId;
  final Apartment apartment;
  final DateTimeRange dateRange;
  final double totalPrice;

  /// النص الأصلي القادم من الباك (pending / approved / rejected / cancelled / completed ...)
  final String rawStatus;

  BookingModel({
    required this.bookingId,
    required this.apartment,
    required this.dateRange,
    required this.totalPrice,
    String? rawStatus,
    BookingStatus? status, // ✅ دعم للموك القديم (status:)
  }) : rawStatus = (rawStatus ?? _rawFromStatus(status) ?? 'pending');

  /// ✅ حتى ما نكسر أي كود قديم يستخدم booking.status
  BookingStatus get status => effectiveStatus;

  // ===============================
  // ✅ مفيد للتقييم/الحالات
  // ===============================
  bool get isCheckoutPassed {
    final today = _dateOnly(DateTime.now());
    final checkout = _dateOnly(dateRange.end);
    return today.isAfter(checkout); // لازم اليوم يكون بعد يوم الخروج
  }

  /// ✅ الحالة “الفعلية” المعتمدة بالواجهة:
  /// - rejected/cancelled => cancelled
  /// - completed فقط بعد ما يمرّ check_out_date
  /// - approved/active => active
  /// - pending => pending
  BookingStatus get effectiveStatus {
  final s = rawStatus.trim().toLowerCase();

  // 1) cancelled / rejected
  if (_isCancelledRaw(s)) return BookingStatus.cancelled;

  // 2) ✅ إذا الداشبورد حطّها completed => Completed مباشرة
  if (_isCompletedRaw(s)) return BookingStatus.completed;

  // 3) ✅ إذا مرّ يوم الخروج => Completed
  if (isCheckoutPassed) return BookingStatus.completed;

  // 4) active / approved
  if (_isActiveRaw(s)) return BookingStatus.active;

  // 5) pending
  if (_isPendingRaw(s)) return BookingStatus.pending;

  return BookingStatus.unknown;
}


  BookingModel copyWith({
    String? bookingId,
    Apartment? apartment,
    DateTimeRange? dateRange,
    double? totalPrice,
    String? rawStatus,
    BookingStatus? status, // إذا بدك تبعث enum بدل raw
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      apartment: apartment ?? this.apartment,
      dateRange: dateRange ?? this.dateRange,
      totalPrice: totalPrice ?? this.totalPrice,
      rawStatus: rawStatus ??
          (status != null ? _rawFromStatus(status) : null) ??
          this.rawStatus,
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['booking_id'] ?? json['bookingId'];
    final bookingId = id.toString();

    final aptRaw = (json['apartment'] is Map)
        ? Map<String, dynamic>.from(json['apartment'] as Map)
        : <String, dynamic>{};

    final apartment = Apartment.fromJson(aptRaw);

    final checkInStr =
        (json['check_in_date'] ?? json['start_date'] ?? '').toString();
    final checkOutStr =
        (json['check_out_date'] ?? json['end_date'] ?? '').toString();

    final start = _parseDate(checkInStr) ?? DateTime.now();
    final end = _parseDate(checkOutStr) ?? start.add(const Duration(days: 1));

    final fixedEnd = end.isBefore(start) ? start.add(const Duration(days: 1)) : end;
    final range = DateTimeRange(start: start, end: fixedEnd);

    final total =
        _asDouble(json['total_price'] ?? json['total_rent'] ?? json['total'] ?? 0);

    final rawStatus = (json['status'] ?? 'pending').toString();

    return BookingModel(
      bookingId: bookingId,
      apartment: apartment,
      dateRange: range,
      totalPrice: total,
      rawStatus: rawStatus,
    );
  }

  // ---------------- helpers ----------------

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime? _parseDate(String s) {
    final v = s.trim();
    if (v.isEmpty) return null;
    try {
      return DateTime.parse(v);
    } catch (_) {
      return null;
    }
  }

  static double _asDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  static String? _rawFromStatus(BookingStatus? s) {
    switch (s) {
      case BookingStatus.active:
        return 'approved';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.unknown:
        return 'unknown';
      case null:
        return null;
    }
  }

  static bool _isCompletedRaw(String s) {
  const set = {'completed', 'finished', 'done'};
  return set.contains(s);
}


  static bool _isCancelledRaw(String s) {
    const set = {
      'cancelled', 'canceled',
      'rejected', 'declined', 'denied', 'refused',
    };
    return set.contains(s);
  }

  static bool _isActiveRaw(String s) {
    const set = {
      'active', 'approved', 'confirmed', 'accepted', 'in_progress',
    };
    return set.contains(s);
  }

  static bool _isPendingRaw(String s) {
    const set = {
      'pending', 'requested', 'waiting', 'under_review',
    };
    return set.contains(s);
  }
}
