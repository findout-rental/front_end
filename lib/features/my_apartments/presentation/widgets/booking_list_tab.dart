import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/booking_controller.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/data/models/booking_model.dart';
import 'package:project/shared_widgets/apartment_list_item_widget.dart';

class BookingListTab extends StatelessWidget {
  final List<BookingModel> bookings;
  const BookingListTab({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(
          'no_bookings_found'.tr, // Use translation key
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
    // ✅ Get controller without creating a new one
    final BookingController controller = Get.find<BookingController>();

    return ListView.builder(
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
                // Apartment info
                ApartmentListItemWidget(apartment: booking.apartment),
                // Booking status / action buttons
                _BookingStatusSection(booking: booking, controller: controller),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 🔹 Separate widget for better performance and organization
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
    Widget content;

    switch (booking.status) {
      case BookingStatus.active:
        content = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'booking_active'.tr, // Use translation key
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(), // Flexible space
            // Merged: Added the new "Edit" button from HEAD branch
            TextButton(
              onPressed: () {
                Get.toNamed(
                  AppRouter.booking,
                  arguments: {
                    'apartment': booking.apartment,
                    'booking': booking, // Pass the current booking for editing
                  },
                );
              },
              child: Text('edit_booking'.tr),
            ),
            const SizedBox(width: 8),

            // Cancel button with confirmation dialog
            ElevatedButton(
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
            ),
          ],
        );
        break;
      case BookingStatus.completed:
        // Merged: Using the translatable key from HEAD branch
        content = Text(
          'booking_completed'.tr,
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      case BookingStatus.cancelled:
        // Merged: Using the translatable key from HEAD branch
        content = Text(
          'booking_cancelled'.tr,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      default:
        content = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: content,
    );
  }
}
