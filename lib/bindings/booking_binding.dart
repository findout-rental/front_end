// lib/bindings/booking_binding.dart

import 'package:get/get.dart';
import 'package:project/controllers/booking_controller.dart';
import 'package:project/services/booking_service.dart'; // ✅ استيراد الخدمة

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ استخدم lazyPut لضمان عدم حدوث خطأ إذا تم استدعاؤه بعد InitialBinding
    // fenix: true تعيد إنشاء المراقب إذا تم حذفه لسبب ما
    Get.lazyPut<BookingController>(
      () => BookingController(Get.find<BookingService>()),
      fenix: true, 
    );
  }
}
