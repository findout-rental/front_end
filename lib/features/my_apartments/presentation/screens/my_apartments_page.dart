// lib/features/my_apartments/presentation/screens/my_apartments_page.dart
import 'package:flutter/material.dart';
import 'package:project/data/providers/booking_provider.dart';
import 'package:project/features/my_apartments/presentation/widgets/booking_list_tab.dart';
import 'package:provider/provider.dart';

class MyApartmentsPage extends StatelessWidget {
  const MyApartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('شققي'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'نشطة'),
              Tab(text: 'مكتملة'),
              Tab(text: 'ملغاة'),
            ],
          ),
        ),
        body: Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            return TabBarView(
              children: [
                BookingListTab(bookings: bookingProvider.activeBookings),
                BookingListTab(bookings: bookingProvider.completedBookings),
                BookingListTab(bookings: bookingProvider.cancelledBookings),
              ],
            );
          },
        ),
      ),
    );
  }
}
