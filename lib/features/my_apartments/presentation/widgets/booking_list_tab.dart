import 'package:flutter/material.dart';
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

    return ListView.separated(
      itemCount: bookings.length,
      padding: const EdgeInsets.all(16.0),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return ApartmentListItemWidget(apartment: booking.apartment);
      },
    );
  }
}
