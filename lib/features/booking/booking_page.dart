// lib/features/booking/booking_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/controllers/booking_controller.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/models/booking_model.dart';
import 'package:project/shared_widgets/primary_button.dart';

class BookingPage extends StatefulWidget {
  final Apartment apartment;
  final BookingModel? existingBooking; // ✅ معامل اختياري لوضع التعديل

  const BookingPage({
    super.key,
    required this.apartment,
    this.existingBooking, // ✅
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // --- LOCAL STATE ---
  DateTimeRange? _selectedDateRange;
  // (يمكن إضافة منطق التحقق من التوافر هنا لاحقًا)

  // --- DEPENDENCIES ---
  final BookingController controller = Get.find<BookingController>();

  @override
  void initState() {
    super.initState();
    // ✅ إذا كنا في وضع التعديل، املأ التواريخ الحالية
    if (widget.existingBooking != null) {
      _selectedDateRange = widget.existingBooking!.dateRange;
    }
  }

  /// يفتح منتقي التاريخ ويحدث الحالة
  Future<void> _pickDateRange() async {
    final newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;
      });
    }
  }

  /// ✅ دالة جديدة لمعالجة عملية الإرسال (إنشاء أو تعديل)
  void _submit() {
    if (_selectedDateRange == null) return;

    final bool isEditing = widget.existingBooking != null;

    if (isEditing) {
      // --- وضع التعديل ---
      controller.updateBooking(
        bookingId: widget.existingBooking!.bookingId,
        newDateRange: _selectedDateRange!,
      );
    } else {
      // --- وضع الإنشاء ---
      controller
          .createBooking(
            apartment: widget.apartment,
            dateRange: _selectedDateRange!,
          )
          .then((_) {
            // بعد النجاح، أغلق الصفحة وأعد 'true' لإعلام الصفحة السابقة
            if (mounted) Navigator.pop(context, true);
          })
          .catchError((_) {
            // لا تفعل شيئًا في حالة الخطأ، المراقب سيعرض Snackbar
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ تحديد هل نحن في وضع التعديل
    final bool isEditing = widget.existingBooking != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'edit_booking'.tr : 'confirm_booking'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildApartmentSummary(),
            _buildSectionDivider(),
            _buildTripDetails(),
            _buildSectionDivider(),
            _buildPriceDetails(),
            const SizedBox(height: 32),

            // ✅ استخدام Obx لمراقبة حالة التحميل
            Obx(
              () => PrimaryButton(
                text: controller.isLoading.value
                    ? '...'
                    : (isEditing ? 'save_changes'.tr : 'complete_booking_and_payment'.tr),
                onPressed:
                    (_selectedDateRange != null && !controller.isLoading.value)
                    ? _submit
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets to build UI ---

  Widget _buildApartmentSummary() {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            widget.apartment.images.first,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.apartment.title,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(widget.apartment.location, style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber.shade700, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.apartment.rating} (${widget.apartment.reviewCount} تقييم)',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTripDetails() {
    final theme = Theme.of(context);
    final formatter = DateFormat('d MMM, yyyy');
    final checkIn = _selectedDateRange != null
        ? formatter.format(_selectedDateRange!.start)
        : 'choose'; // 'اختر'
    final checkOut = _selectedDateRange != null
        ? formatter.format(_selectedDateRange!.end)
        : 'choose';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('رحلتك', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildDetailRow(
          title: 'التواريخ',
          content: '$checkIn - $checkOut',
          actionText: 'تعديل',
          onActionPressed: _pickDateRange,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPriceDetails() {
    final theme = Theme.of(context);
    final nights = _selectedDateRange?.duration.inDays ?? 0;
    final pricePerNight = widget.apartment.pricePerNight;
    final serviceFee = 50; // يمكن أن تأتي من الخادم
    final total = (pricePerNight * nights) + serviceFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تفاصيل السعر', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildPriceRow(
          '$pricePerNight ريال × $nights ليالي',
          '${pricePerNight * nights} ريال',
        ),
        const SizedBox(height: 8),
        _buildPriceRow('رسوم الخدمة', '$serviceFee ريال'),
        const Divider(height: 24),
        _buildPriceRow('الإجمالي', '$total ريال', isTotal: true),
      ],
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String content,
    required String actionText,
    required VoidCallback onActionPressed,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(content, style: theme.textTheme.bodySmall),
          ],
        ),
        TextButton(onPressed: onActionPressed, child: Text(actionText)),
      ],
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isTotal = false}) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(value, style: style),
      ],
    );
  }

  Widget _buildSectionDivider() => const Divider(height: 40, thickness: 0.8);
}
