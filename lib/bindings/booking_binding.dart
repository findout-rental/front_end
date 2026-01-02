import 'package:get/get.dart';
import 'package:project/controllers/booking_controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BookingController(), permanent: true);
  }
}
