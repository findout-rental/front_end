import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/services/auth_service.dart';

class OtpController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AuthController _authController = Get.find<AuthController>();

  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final isLoading = false.obs;
  final resendSeconds = 60.obs;

  Timer? _timer;
  late String mobileNumber;

  @override
  void onInit() {
    super.onInit();
    mobileNumber = Get.arguments['mobile_number'];
    startTimer();
  }

  @override
  void onClose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    resendSeconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value == 0) {
        timer.cancel();
      } else {
        resendSeconds.value--;
      }
    });
  }

  String get otpCode => controllers.map((e) => e.text).join();

  bool get isOtpComplete => otpCode.length == 6;

  Future<void> verifyOtp() async {
    // 🔴 DEV MODE (تجاوز التحقق)
    if (otpCode == '111111') {
      // 🔴 DEV MODE
      // نضرب verifyOtp الحقيقي لإعلام الباك
      await _authService.verifyOtp(
        mobileNumber: mobileNumber,
        otpCode: otpCode,
      );

      final args = Get.arguments;

      await _authController.completeRegistration(
        isTenant: args['isTenant'],
        personalImage: args['personalImage'],
        idImage: args['idImage'],
        otpCode: otpCode,
      );
      return;
    }

    if (!isOtpComplete) {
      Get.snackbar('خطأ', 'الرجاء إدخال رمز التحقق كامل');
      return;
    }

    try {
      isLoading.value = true;

      await _authService.verifyOtp(
        mobileNumber: mobileNumber,
        otpCode: otpCode,
      );

      final args = Get.arguments;

      await _authController.completeRegistration(
        isTenant: args['isTenant'],
        personalImage: args['personalImage'],
        idImage: args['idImage'],
        otpCode: otpCode,
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل التحقق من الرمز');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (resendSeconds.value > 0) return;

    try {
      await _authService.sendOtp(mobileNumber: mobileNumber);

      Get.snackbar('تم', 'تم إعادة إرسال الرمز');
      clearOtp();
      startTimer();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إعادة الإرسال');
    }
  }

  void clearOtp() {
    for (final c in controllers) {
      c.clear();
    }
    focusNodes.first.requestFocus();
  }
}
