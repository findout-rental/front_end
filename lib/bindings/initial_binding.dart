// lib/bindings/initial_binding.dart

import 'package:get/get.dart';
import 'package:project/controllers/apartment_controller.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/booking_controller.dart';
import 'package:project/controllers/chat_controller.dart';
import 'package:project/controllers/home_controller.dart';
import 'package:project/controllers/theme_controller.dart';
import 'package:project/core/network/dio_client.dart';
import 'package:project/core/storage/auth_storage.dart';
import 'package:project/services/apartment_service.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/services/booking_service.dart';
import 'package:project/services/chat_service.dart';
import 'package:project/services/favorite_service.dart';
import 'package:project/services/notification_service.dart';
import 'package:project/services/websocket_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // --- 1. CORE & SERVICES (Lazy Loaded) ---
    // يتم تسجيلها أولاً بحيث تكون متاحة للمراقبين.
    // `lazyPut` يعني أنها لن تُنشأ إلا عند أول استخدام.
    Get.lazyPut(() => DioClient(), fenix: true);
    Get.lazyPut(() => AuthStorage(), fenix: true);
    Get.lazyPut(() => AuthService(Get.find()), fenix: true);
    Get.lazyPut(() => ApartmentService(Get.find()), fenix: true);
    Get.lazyPut(() => FavoriteService(Get.find()), fenix: true);
    Get.lazyPut(() => BookingService(Get.find()), fenix: true);

    Get.lazyPut(() => ChatService(Get.find()), fenix: true);
    Get.lazyPut(() => WebsocketService(), fenix: true);
    Get.lazyPut(() => NotificationService(Get.find()), fenix: true);

    // --- 2. CONTROLLERS (Loaded Immediately & Permanently) ---
    // يتم تسجيلها باستخدام `put` لإنشائها فورًا وجعلها متاحة دائمًا.
    // نقوم بحقن الخدمات المسجلة أعلاه بشكل صريح في المنشئ.

    // المراقبين الذين لا يعتمدون على خدمات أخرى
    Get.put(ThemeController(), permanent: true);
    Get.put(HomeController(), permanent: true);

    // المراقبين الذين يعتمدون على خدمات
    Get.put(AuthController(Get.find(), Get.find()), permanent: true);
    Get.put(BookingController(Get.find()), permanent: true);
    Get.put(ApartmentController(Get.find(), Get.find()), permanent: true);
    Get.put(
      ChatController(Get.find(), Get.find(), Get.find()),
      permanent: true,
    );
  }
}
