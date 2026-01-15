// lib/features/auth/sign_up_page.dart
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/features/auth/otp_verification_page.dart'; // ✅ استيراد الصفحة الجديدة
import 'package:project/shared_widgets/custom_text_field.dart';
import 'package:project/shared_widgets/image_picker_box.dart';
import 'package:project/shared_widgets/password_field.dart';
import 'package:project/shared_widgets/primary_button.dart';
import 'package:project/shared_widgets/role_toggle.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // --- LOCAL STATE for UI ---
  // هذه الحالة تخص الواجهة فقط
  bool _isTenant = true;
  File? _personalImage;
  File? _idImage;

  // --- DEPENDENCIES ---
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _dobController = TextEditingController();
  final AuthController controller = Get.find<AuthController>();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _pickImage(ValueChanged<File?> onPicked) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => onPicked(File(picked.path)));
    }
  }

  Future<void> _pickDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formatted =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      // تحديث كلا المراقبين
      _dobController.text = formatted;
      controller.dobController.text = formatted;
    }
  }

  /// ✅ دالة جديدة لمعالجة عملية التسجيل
  Future<void> _handleSignUp() async {
    // التحقق من وجود الصور
    if (_personalImage == null || _idImage == null) {
      Get.snackbar(
        'Incomplete Form',
        'Please upload both a personal photo and an ID photo.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 1. أرسل الـ OTP أولاً
    try {
      await controller.sendOtp(controller.phoneController.text.trim());

      // 2. إذا نجح، اجمع البيانات وانتقل لشاشة الـ OTP
      final registrationData = {
        'isTenant': _isTenant,
        'personalImage': _personalImage,
        'idImage': _idImage,
      };

      // استخدم Get.to بدلاً من Get.toNamed لتمرير البيانات المعقدة
      Get.to(
        () => OtpVerificationPage(
          phoneNumber: controller.phoneController.text.trim(),
          registrationData: registrationData,
        ),
        // يمكنك إضافة تأثيرات انتقال هنا
        transition: Transition.rightToLeft,
      );
    } catch (e) {
      // AuthController سيعرض رسالة الخطأ تلقائيًا عبر Obx
      // لا تحتاج لفعل أي شيء إضافي هنا
    }
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          // استخدام Obx لمراقبة isLoading و errorMessage
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.home_work_outlined,
                  size: 80,
                  color: theme.primaryColor,
                ),
                const SizedBox(height: 10),
                Text(
                  'create_your_account'.tr,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 20),

                // Role Toggle
                RoleToggle(
                  optionOneText: 'Tenant',
                  optionTwoText: 'Owner',
                  value: _isTenant,
                  onChanged: (v) => setState(() => _isTenant = v),
                ),
                const SizedBox(height: 20),

                // --- Text Fields ---
                CustomTextField(
                  hint: 'first_name'.tr,
                  icon: Icons.person_outline,
                  controller: controller.firstNameController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hint: 'last_name'.tr,
                  icon: Icons.person_outline,
                  controller: controller.lastNameController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hint: 'phone_number'.tr,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  controller: controller.phoneController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hint: 'date_of_birth'.tr,
                  icon: Icons.calendar_today_outlined,
                  controller: _dobController, // استخدم المراقب المحلي للعرض
                  readOnly: true,
                  onTap: () => _pickDateOfBirth(context),
                ),
                const SizedBox(height: 12),
                PasswordField(
                  hint: 'password'.tr,
                  controller: controller.passwordController,
                ),
                const SizedBox(height: 12),
                PasswordField(
                  hint: 'confirm_password'.tr,
                  controller: controller.confirmPasswordController,
                ),
                const SizedBox(height: 20),

                // --- Image Pickers ---
                Row(
                  children: [
                    ImagePickerBox(
                      title: 'Personal Photo',
                      icon: Icons.person_add_alt_1_outlined,
                      image: _personalImage,
                      onTap: () => _pickImage((f) => _personalImage = f),
                    ),
                    const SizedBox(width: 12),
                    ImagePickerBox(
                      title: 'ID Photo',
                      icon: Icons.badge_outlined,
                      image: _idImage,
                      onTap: () => _pickImage((f) => _idImage = f),
                    ),
                  ],
                ),

                // --- Error Display ---
                if (controller.errorMessage.value.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),

                // --- Action Button ---
                PrimaryButton(
                  text: controller.isLoading.value
                      ? '...'
                      : 'sign_up'.tr,
                  onPressed: controller.isLoading.value ? null : _handleSignUp,
                ),
                const SizedBox(height: 16),

                // --- Navigation to Sign In ---
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: 'sign_in'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.offAllNamed(AppRouter.signIn),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
