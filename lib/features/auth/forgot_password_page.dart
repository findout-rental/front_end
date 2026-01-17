import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/shared_widgets/custom_text_field.dart';
import 'package:project/shared_widgets/primary_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    final phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter your phone number to receive a reset code.'),
            const SizedBox(height: 20),
            CustomTextField(
              controller: phoneController,
              hint: 'phone_number'.tr,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            Obx(
              () => PrimaryButton(
                text: controller.isLoading.value ? 'Sending...' : 'Send Code',
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.forgotPassword(phoneController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
