import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/booking_controller.dart';
import 'package:project/features/my_apartments/presentation/widgets/booking_list_tab.dart';

class MyApartmentsPage extends StatelessWidget {
  MyApartmentsPage({super.key});

  final BookingController bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('my_apartments'.tr),
          bottom: TabBar(
            tabs: [
              Tab(text: 'active_booking'.tr),
              Tab(text: 'completed_booking'.tr),
              Tab(text: 'cancelled_booking'.tr),
            ],
          ),
        ),
        body: Obx(() {
          return TabBarView(
            children: [
              BookingListTab(bookings: bookingController.activeBookings),
              BookingListTab(bookings: bookingController.completedBookings),
              BookingListTab(bookings: bookingController.cancelledBookings),
            ],
          );
        }),
      ),
    );
  }
}
