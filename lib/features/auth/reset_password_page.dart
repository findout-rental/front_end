import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/shared_widgets/password_field.dart';
import 'package:project/shared_widgets/custom_text_field.dart';
import 'package:project/shared_widgets/primary_button.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    final String mobileNumber = Get.arguments;
    final otpController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomTextField(
              controller: otpController,
              hint: 'OTP Code',
              icon: Icons.pin,
            ),
            const SizedBox(height: 16),
            PasswordField(controller: passwordController, hint: 'New Password'),
            const SizedBox(height: 16),
            PasswordField(
              controller: confirmPasswordController,
              hint: 'Confirm New Password',
            ),
            const SizedBox(height: 20),
            Obx(
              () => PrimaryButton(
                text: controller.isLoading.value
                    ? 'Resetting...'
                    : 'Reset Password',
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.resetPassword(
                        mobileNumber: mobileNumber,
                        otpCode: otpController.text,
                        newPassword: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
