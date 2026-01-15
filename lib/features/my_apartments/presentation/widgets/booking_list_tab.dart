// lib/features/my_apartments/presentation/widgets/booking_list_tab.dart

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
      return const Center(
        child: Text(
          'no_bookings_found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // ✅ الوصول إلى المراقب لاستخدامه في زر الإلغاء
    final BookingController controller = Get.find<BookingController>();

    return ListView.builder(
      itemCount: bookings.length,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          // ✅ استخدام Card لتحسين التصميم
          child: Card(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. عرض معلومات الشقة باستخدام الويدجت المشترك
                // لا نمرر onFavoriteToggle لأنه غير ذي صلة هنا
                ApartmentListItemWidget(apartment: booking.apartment),

                // 2. إضافة قسم يعرض حالة الحجز أو زر الإلغاء
                _buildBookingStatusSection(context, booking, controller),
              ],
            ),
          ),
        );
      },
    );
  }

  /// دالة مساعدة لبناء قسم الحالة أو زر الإلغاء
  Widget _buildBookingStatusSection(
    BuildContext context,
    BookingModel booking,
    BookingController controller,
  ) {
    final theme = Theme.of(context);
    Widget statusWidget;

    switch (booking.status) {
      case BookingStatus.active:
        statusWidget = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'booking_active',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(), // لإضافة مساحة مرنة
            // ✅ زر التعديل الجديد
            TextButton(
              onPressed: () {
                Get.toNamed(
                  AppRouter.booking,
                  arguments: {
                    'apartment': booking.apartment,
                    'booking': booking, // مرر الحجز الحالي
                  },
                );
              },
              child: const Text('edit_booking'),
            ),

            const SizedBox(width: 8),

            // ✅ زر الإلغاء مع نافذة تأكيد
            ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "confirm_cancellation",
                  middleText: "are_you_sure_cancel_booking",
                  textConfirm: "yes",
                  textCancel: "no",
                  buttonColor: Colors.red,
                  confirmTextColor: Colors.white,
                  cancelTextColor: Colors.black,
                  onConfirm: () {
                    Get.back(); // إغلاق الحوار
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
              child: const Text('cancel_booking'),
            ),
          ],
        );
        break;
      case BookingStatus.completed:
        statusWidget = Text(
          'booking_completed',
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      case BookingStatus.cancelled:
        statusWidget = Text(
          'booking_cancelled',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      default:
        statusWidget = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: statusWidget,
    );
  }
}
