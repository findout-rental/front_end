// lib/controllers/auth_controller.dart

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
  // --- DEPENDENCIES ---
  // ✅ سيتم حقنها عبر المنشئ من InitialBinding
  final AuthService _authService;
  final AuthStorage _authStorage;
  // ✅ المنشئ الذي يستقبل الاعتماديات
  AuthController(this._authService, this._authStorage);

  // --- TEXT EDITING CONTROLLERS ---
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dobController = TextEditingController();

  // --- REACTIVE STATE ---
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // --- GETTERS ---
  bool get isLoggedIn => _authStorage.token != null;

  // --- PUBLIC METHODS (ACTIONS) ---

  /// Handles the login process.
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

  /// Sends an OTP to the user's phone number.
  Future<void> sendOtp(String phoneNumber) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _authService.sendOtp(mobileNumber: phoneNumber);
    } catch (e) {
      _handleAuthError(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Verifies the OTP code.
  Future<void> verifyOtp(String phoneNumber, String otpCode) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _authService.verifyOtp(mobileNumber: phoneNumber, otpCode: otpCode);
    } catch (e) {
      _handleAuthError(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles the user registration process after OTP verification.
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

      Get.offAllNamed(
        AppRouter.pendingApproval,
        arguments:
            'Your account has been created successfully.\nPlease wait for admin approval.',
      );
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Logs out the current user.
  void logout() {
    _authStorage.clearToken();
    _authStorage.clearUser();
    currentUser.value = null;
    Get.offAllNamed(AppRouter.signIn);
  }

  /// ✅ دالة جديدة لتدفق نسيت كلمة المرور
  Future<void> forgotPassword(String mobileNumber) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _authService.forgotPassword(mobileNumber: mobileNumber);
      // بعد النجاح، انتقل إلى شاشة إدخال الرمز
      Get.to(() => const ResetPasswordPage(), arguments: mobileNumber);
    } catch (e) {
      _handleAuthError(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ دالة جديدة لإعادة تعيين كلمة المرور
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
      // بعد النجاح، انتقل إلى صفحة تسجيل الدخول مع رسالة نجاح
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

  // ✅ دالة جديدة لتحديث ملف المستخدم
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

      // بعد النجاح، قم بتحديث بيانات المستخدم في الحالة والتخزين
      final userJson =
          response.data['data']; // ⚠️ افترض أن لارافيل تعيد المستخدم المحدث
      _authStorage.saveUser(userJson);
      currentUser.value = UserModel.fromJson(userJson);

      Get.back(); // العودة من صفحة التعديل
      Get.snackbar('Success', 'Profile updated successfully!');
    } catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Checks authentication status on app startup.
  void checkAuthStatus() {
    final token = _authStorage.token;
    if (token != null) {
      final userJson = _authStorage.user;
      if (userJson != null) {
        currentUser.value = UserModel.fromJson(userJson);
      }
    }
  }

  // --- PRIVATE METHODS ---
  void _handleAuthError(Object e) {
    print('AUTH ERROR TYPE => ${e.runtimeType}');
    print('AUTH ERROR => $e');

    if (e is DioException && e.error is ApiException) {
      final apiError = e.error as ApiException;
      errorMessage.value = apiError.message;
    } else if (e is ApiException) {
      errorMessage.value = e.message;
    } else {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
    }
  }

  // --- LIFECYCLE ---
  @override
  void onInit() {
    super.onInit();
    // ✅ استدعاء checkAuthStatus لملء بيانات المستخدم فورًا عند بدء التطبيق
    checkAuthStatus();
  }

  @override
  void onClose() {
    // تنظيف وحدات التحكم عند إغلاق المراقب
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dobController.dispose();
    super.onClose();
  }
}
