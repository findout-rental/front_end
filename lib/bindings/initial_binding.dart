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
    // ===============================
    // CORE
    // ===============================
    Get.put<DioClient>(DioClient(), permanent: true);
    Get.put<AuthStorage>(AuthStorage(), permanent: true);

    // ===============================
    // SERVICES
    // ===============================
    Get.put<AuthService>(
      AuthService(Get.find()),
      permanent: true,
    );

    Get.put<ApartmentService>(
      ApartmentService(Get.find()),
      permanent: true,
    );

    Get.put<FavoriteService>(
      FavoriteService(Get.find()),
      permanent: true,
    );

    Get.put<BookingService>(
      BookingService(Get.find()),
      permanent: true,
    );

    Get.put<ChatService>(
      ChatService(Get.find()),
      permanent: true,
    );

    Get.put<WebsocketService>(
      WebsocketService(),
      permanent: true,
    );

    Get.put<NotificationService>(
      NotificationService(Get.find()),
      permanent: true,
    );

    // ===============================
    // CONTROLLERS (GLOBAL)
    // ===============================
    Get.put<AuthController>(
      AuthController(
        Get.find<AuthService>(),
        Get.find<AuthStorage>(),
      ),
      permanent: true,
    );

    Get.put<ApartmentController>(
      ApartmentController(
        Get.find<ApartmentService>(),
        Get.find<FavoriteService>(),
        Get.find<AuthService>(),
      ),
      permanent: true,
    );

    Get.put<BookingController>(
      BookingController(Get.find<BookingService>()),
      permanent: true,
    );

    Get.put<ChatController>(
      ChatController(
        Get.find<ChatService>(),
        Get.find<WebsocketService>(),
        Get.find<AuthController>(),
      ),
      permanent: true,
    );

    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}
