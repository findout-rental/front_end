import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/core/network/dio_client.dart';
import 'package:project/controllers/booking_controller.dart';
import 'package:project/services/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DioClient());
    Get.lazyPut(() => AuthService(Get.find()));
    Get.lazyPut(() => AuthController(Get.find()));

    Get.put(BookingController(), permanent: true);
  }
}
