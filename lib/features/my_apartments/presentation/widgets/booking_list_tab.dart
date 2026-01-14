import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/booking_controller.dart';
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
          'لا توجد حجوزات في هذا القسم.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // ✅ جلب المراقب بدون إنشاء جديد
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
                // معلومات الشقة
                ApartmentListItemWidget(
                  apartment: booking.apartment,
                ),

                // حالة الحجز / زر الإلغاء
                _BookingStatusSection(
                  booking: booking,
                  controller: controller,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 🔹 Widget منفصل (أفضل للأداء والتنظيم)
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
              'حجز نشط',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "تأكيد الإلغاء",
                  middleText: "هل أنت متأكد أنك تريد إلغاء هذا الحجز؟",
                  textConfirm: "نعم، قم بالإلغاء",
                  textCancel: "لا",
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
              child: const Text('إلغاء الحجز'),
            ),
          ],
        );
        break;

      case BookingStatus.completed:
        content = Text(
          'حجز مكتمل',
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        );
        break;

      case BookingStatus.cancelled:
        content = Text(
          'حجز ملغي',
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
