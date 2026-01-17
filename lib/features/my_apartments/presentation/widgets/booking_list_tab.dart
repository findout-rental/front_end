import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/booking_controller.dart';
import 'package:project/controllers/rating_controller.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/data/models/booking_model.dart';
import 'package:project/shared_widgets/apartment_list_item_widget.dart';

class BookingListTab extends StatelessWidget {
  final List<BookingModel> bookings;
  const BookingListTab({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find<BookingController>();

    if (bookings.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.fetchMyBookings,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            Center(
              child: Text(
                'no_bookings_found'.tr,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchMyBookings,
      child: ListView.builder(
        itemCount: bookings.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ApartmentListItemWidget(apartment: booking.apartment),
                  _BookingStatusSection(
                    booking: booking,
                    controller: controller,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BookingStatusSection extends StatelessWidget {
  final BookingModel booking;
  final BookingController controller;

  const _BookingStatusSection({
    required this.booking,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = booking.effectiveStatus;

    switch (status) {
      case BookingStatus.active:
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: _statusWithActions(
            label: 'booking_active'.tr,
            labelColor: Colors.green.shade700,
            actions: [
              TextButton(
                onPressed: () {
                  Get.toNamed(
                    AppRouter.booking,
                    arguments: {
                      'apartment': booking.apartment,
                      'booking': booking,
                    },
                  );
                },
                child: Text('edit_booking'.tr),
              ),
              _cancelButton(context),
            ],
          ),
        );

      case BookingStatus.pending:
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: _statusWithActions(
            label: 'بانتظار موافقة الأدمن',
            labelColor: Colors.orange.shade700,
            actions: [_cancelButton(context)],
          ),
        );

      case BookingStatus.completed:
        final auth = Get.find<AuthController>();
        final ratingCtrl = Get.find<RatingController>();
        final isTenant = auth.currentUser.value?.isTenant == true;
        final alreadyRated = ratingCtrl.ratedBookingIds.contains(
          booking.bookingId,
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: _statusWithActions(
            label: 'booking_completed'.tr,
            labelColor: theme.primaryColor,
            actions: [
              if (isTenant)
                TextButton(
                  onPressed: alreadyRated
                      ? null
                      : () => _openRatingSheet(context, booking.bookingId),
                  child: Text(alreadyRated ? 'تم التقييم' : 'قيّم'),
                ),
            ],
          ),
        );

      case BookingStatus.cancelled:
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(
            'booking_cancelled'.tr,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      case BookingStatus.unknown:
      default:
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(
            'غير معروف',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  Widget _statusWithActions({
    required String label,
    required Color labelColor,
    required List<Widget> actions,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(color: labelColor, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: actions,
            ),
          ),
        ),
      ],
    );
  }

  Widget _cancelButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.defaultDialog(
          title: "confirm_cancellation".tr,
          middleText: "are_you_sure_cancel_booking".tr,
          textConfirm: "yes".tr,
          textCancel: "no".tr,
          buttonColor: Colors.red,
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
            controller.cancelBooking(booking.bookingId);
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text('cancel_booking'.tr),
    );
  }

  void _openRatingSheet(BuildContext context, String bookingId) {
    final ratingCtrl = Get.find<RatingController>();
    int selected = 5;
    final reviewCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'قيّم الشقة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              StatefulBuilder(
                builder: (ctx, setState) {
                  return Row(
                    children: List.generate(5, (i) {
                      final star = i + 1;
                      final filled = star <= selected;
                      return IconButton(
                        onPressed: () => setState(() => selected = star),
                        icon: Icon(
                          filled ? Icons.star : Icons.star_border,
                          color: filled ? Colors.amber : null,
                        ),
                      );
                    }),
                  );
                },
              ),

              TextField(
                controller: reviewCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'اكتب ملاحظتك (اختياري)',
                ),
              ),
              const SizedBox(height: 12),

              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ratingCtrl.isSubmitting.value
                        ? null
                        : () async {
                            final ok = await ratingCtrl.submitRating(
                              bookingId: bookingId,
                              rating: selected,
                              reviewText: reviewCtrl.text,
                            );
                            if (ok && context.mounted) Navigator.pop(context);
                          },
                    child: Text(
                      ratingCtrl.isSubmitting.value ? '...' : 'إرسال التقييم',
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
