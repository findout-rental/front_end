// lib/bindings/booking_binding.dart

import 'package:get/get.dart';
import 'package:project/controllers/booking_controller.dart';
import 'package:project/core/network/dio_client.dart';
import 'package:project/services/booking_service.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    // ======================
    // Service
    // ======================
    Get.lazyPut<BookingService>(
          () => BookingService(
        Get.find<DioClient>(), // ✅ التصحيح هنا
      ),
      fenix: true,
    );

    // ❌ لا تعيد تسجيل BookingController هنا
    // لأنه already permanent في AuthBinding
  }
}
