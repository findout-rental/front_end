import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/network/api_exceptions.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/core/storage/auth_storage.dart';
import 'package:project/data/models/user_model.dart';
import 'package:project/features/auth/reset_password_page.dart';
import 'package:project/services/auth_service.dart';

class AuthController extends GetxController {
  // ===============================
  // DEPENDENCIES (Injected)
  // ===============================

  String? debugOtp;
  String? _verifiedOtpCode;

  final AuthService _authService;
  final AuthStorage _authStorage;

  AuthController(this._authService, this._authStorage);

  // ===============================
  // TEXT CONTROLLERS
  // ===============================
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dobController = TextEditingController();

  // ===============================
  // STATE
  // ===============================
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  bool get isLoggedIn => _authStorage.token != null;

  // ===============================
  // AUTH ACTIONS
  // ===============================
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
      final userJson = data['user'];

      _authStorage.saveToken(token);
      _authStorage.saveUser(userJson);
      currentUser.value = UserModel.fromJson(userJson);

      Get.offAllNamed(AppRouter.home);
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required bool isTenant,
    required File? personalImage,
    required File? idImage,
  }) async {
    if (personalImage == null || idImage == null) {
      errorMessage.value = 'Please upload all required images.';
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // فقط إرسال OTP
      await _authService.sendOtp(mobileNumber: phoneController.text.trim());

      // await _authService.register(
      //   firstName: firstNameController.text.trim(),
      //   lastName: lastNameController.text.trim(),
      //   mobileNumber: phoneController.text.trim(),
      //   password: passwordController.text,
      //   dateOfBirth: dobController.text,
      //   role: isTenant ? 'tenant' : 'owner',
      //   personalPhoto: personalImage,
      //   idPhoto: idImage,
      //   otpCode: '111111',
      // );
      Get.toNamed(
        AppRouter.otp,
        arguments: {
          'mobile_number': phoneController.text.trim(),
          'isTenant': isTenant,
          'personalImage': personalImage,
          'idImage': idImage,
        },
      );
    } on ApiException catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeRegistration({
    required bool isTenant,
    required File personalImage,
    required File idImage,
    required String otpCode,
  }) async {
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
        otpCode: otpCode,
      );

      Get.offAllNamed(
        AppRouter.pendingApproval,
        arguments: 'تم إنشاء الحساب بنجاح، بانتظار موافقة الإدارة',
      );
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar('خطأ', e.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword(String mobileNumber) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _authService.forgotPassword(mobileNumber: mobileNumber);
      Get.to(() => const ResetPasswordPage(), arguments: mobileNumber);
    } catch (e) {
      _handleAuthError(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword({
    required String mobileNumber,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _authService.resetPassword(
        mobileNumber: mobileNumber,
        otpCode: otpCode,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      Get.offAllNamed(AppRouter.signIn);
      Get.snackbar(
        'Success',
        'Password has been reset successfully. Please log in.',
      );
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ===============================
  // PROFILE
  // ===============================
  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    File? profileImage,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _authService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        profileImage: profileImage,
      );

      final userJson = response.data['data'];
      _authStorage.saveUser(userJson);
      currentUser.value = UserModel.fromJson(userJson);

      Get.back();
      Get.snackbar('Success', 'Profile updated successfully!');
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _authStorage.clearToken();
    _authStorage.clearUser();
    currentUser.value = null;
    Get.offAllNamed(AppRouter.signIn);
  }

  void checkAuthStatus() {
    final token = _authStorage.token;
    if (token != null) {
      final userJson = _authStorage.user;
      if (userJson != null) {
        currentUser.value = UserModel.fromJson(userJson);
      }
    }
  }

  // ===============================
  // HELPERS
  // ===============================
  void _handleAuthError(Object e) {
    debugPrint('AUTH ERROR TYPE => ${e.runtimeType}');
    debugPrint('AUTH ERROR => $e');

    if (e is DioException && e.error is ApiException) {
      errorMessage.value = (e.error as ApiException).message;
    } else if (e is ApiException) {
      errorMessage.value = e.message;
    } else {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
    }
  }

  // ===============================
  // LIFECYCLE
  // ===============================
  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
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
