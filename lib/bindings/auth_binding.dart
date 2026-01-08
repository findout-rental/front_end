// lib/bindings/auth_binding.dart

import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/core/storage/auth_storage.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // هذا الكود سيضمن أن AuthController متاح،
    // ولكنه لن يفعل شيئًا إذا كان InitialBinding قد قام بتسجيله بالفعل.
    // إنه بمثابة "تأكيد" على وجود الاعتمادية.

    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.find<AuthService>(), 
        Get.find<AuthStorage>(),
      ),
      fenix: true, // لإعادة إنشائه إذا تم حذفه
    );
  }
}
