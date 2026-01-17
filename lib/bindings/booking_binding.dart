import 'package:get/get.dart';
import 'package:project/core/network/dio_client.dart';
import 'package:project/services/booking_service.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingService>(
      () => BookingService(Get.find<DioClient>()),
      fenix: true,
    );
  }
}
