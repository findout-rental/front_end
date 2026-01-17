import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/controllers/booking_controller.dart';
import 'package:project/data/models/apartment_model.dart';
import 'package:project/data/models/booking_model.dart';
import 'package:project/shared_widgets/primary_button.dart';
import 'dart:typed_data';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/utils/photo_helper.dart';

class BookingPage extends StatefulWidget {
  final Apartment apartment;
  final BookingModel? existingBooking;
  const BookingPage({
    super.key,
    required this.apartment,
    this.existingBooking, // ✅
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTimeRange? _selectedDateRange;
  final BookingController controller = Get.find<BookingController>();

  @override
  void initState() {
    super.initState();
    if (widget.existingBooking != null) {
      _selectedDateRange = widget.existingBooking!.dateRange;
    }
  }

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

  void _submit() {
    if (_selectedDateRange == null) return;

    final bool isEditing = widget.existingBooking != null;

    if (isEditing) {
      controller.updateBooking(
        bookingId: widget.existingBooking!.bookingId,
        newDateRange: _selectedDateRange!,
      );
    } else {
      controller
          .createBooking(
            apartment: widget.apartment,
            dateRange: _selectedDateRange!,
          )
          .then((_) {
            if (mounted) Navigator.pop(context, true);
          })
          .catchError((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.existingBooking != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'edit_booking'.tr : 'confirm_booking'.tr),
      ),
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

            Obx(
              () => PrimaryButton(
                text: controller.isLoading.value
                    ? '...'
                    : (isEditing
                          ? 'save_changes'.tr
                          : 'complete_booking_and_payment'.tr),
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

  Widget _buildSmartThumb(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return _thumbPlaceholder();

    final Uint8List? bytes = PhotoHelper.decodeFromAnything(s);
    if (bytes != null) {
      return Image.memory(
        bytes,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => _thumbPlaceholder(),
      );
    }

    if (s.startsWith('http://') || s.startsWith('https://')) {
      return Image.network(
        s,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _thumbPlaceholder(),
      );
    }

    final url = _toAbsoluteUrl(s);
    if (url == null) return _thumbPlaceholder();

    return Image.network(
      url,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _thumbPlaceholder(),
    );
  }

  String? _toAbsoluteUrl(String raw) {
    final host = ApiEndpoints.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    var s = raw.trim();

    s = s.replaceFirst('/storage//', '/storage/');

    if (s.contains('/9j/') || s.startsWith('/9j/')) return null;

    if (s.startsWith('http://') || s.startsWith('https://')) return s;
    if (s.startsWith('/')) return '$host$s';
    return '$host/$s';
  }

  Widget _thumbPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey.shade800,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildApartmentSummary() {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildSmartThumb(
            widget.apartment.images.isNotEmpty
                ? widget.apartment.images.first
                : '',
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
    final serviceFee = 50;
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
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                content,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
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
      children: [
        Expanded(
          child: Text(
            title,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Text(value, style: style),
      ],
    );
  }

  Widget _buildSectionDivider() => const Divider(height: 40, thickness: 0.8);
}
