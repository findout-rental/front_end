import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/network/api_exceptions.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/core/storage/auth_storage.dart';
import 'package:project/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService;

  AuthController(this._authService);

  // Controllers للـ TextFields
  // final phoneController = TextEditingController();
  // final passwordController = TextEditingController();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dobController = TextEditingController();


  // State
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> login() async {
  isLoading.value = true;
  errorMessage.value = '';

  try {
    final response = await _authService.login(
      mobileNumber: phoneController.text.trim(),
      password: passwordController.text,
    );

    final data = response.data['data'];
    final token = data['token'];
    final user = data['user'];

    AuthStorage().saveToken(token);
    AuthStorage().saveUser(user);

    Get.offAllNamed(AppRouter.home);

  } catch (e) {
  print('LOGIN ERROR TYPE => ${e.runtimeType}');
  print('LOGIN ERROR => $e');

  if (e is DioException && e.error is ApiException) {
    final apiError = e.error as ApiException;
    errorMessage.value = apiError.message;
  } else if (e is ApiException) {
    errorMessage.value = e.message;
  } else {
    errorMessage.value = 'Unexpected error occurred';
  }
}
 finally {
    isLoading.value = false;
  }
}



  Future<void> register({
  required bool isTenant,
  required File? personalImage,
  required File? idImage,
}) async {
  if (personalImage == null || idImage == null) {
    errorMessage.value = 'Please upload required images';
    return;
  }

  isLoading.value = true;
  errorMessage.value = '';

  try {
    await _authService.register(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      mobileNumber: phoneController.text.trim(),
      password: passwordController.text,
      dateOfBirth: dobController.text,
      role: isTenant ? 'tenant' : 'owner',
      personalPhoto: personalImage,
      idPhoto: idImage,
    );

    // ✅ التوجيه الصحيح بعد التسجيل
    Get.offAllNamed(
      AppRouter.pendingApproval,
      arguments: 'Your account has been created successfully.\nPlease wait for admin approval.',
      );
      
      
      } 
      on ApiException catch (e) {
        
        errorMessage.value = e.message;
        } finally {
          isLoading.value = false;
          }
          }



  @override
void onClose() {
  firstNameController.dispose();
  lastNameController.dispose();
  phoneController.dispose();
  passwordController.dispose();
  confirmPasswordController.dispose();
  dobController.dispose();
  super.onClose();
}

}
