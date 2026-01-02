import 'package:get/get.dart';
import 'package:project/bindings/auth_binding.dart';
import 'package:project/bindings/booking_binding.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies();
    BookingBinding().dependencies();
  }
}
