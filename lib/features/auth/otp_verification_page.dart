/*

// lib/features/auth/presentation/screens/otp_verification_page.dart

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/shared_widgets/custom_text_field.dart';
import 'package:project/shared_widgets/primary_button.dart';
// ... (add other imports)

class OtpVerificationPage extends StatelessWidget {
  final String phoneNumber; // استقبل رقم الهاتف من الصفحة السابقة
  final Map<String, dynamic> registrationData; // استقبل بيانات التسجيل

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.registrationData,
  });

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final otpController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone Number')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the 6-digit code sent to $phoneNumber'),
            const SizedBox(height: 20),
            CustomTextField(
              controller: otpController,
              hint: 'OTP Code',
              icon: Icons.pin,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // ✅ عند الضغط، تحقق من الرمز ثم قم بالتسجيل
            PrimaryButton(
              text: 'Verify & Register',
              onPressed: () async {
                try {
                  // 1. تحقق من الرمز
                  await controller.verifyOtp(phoneNumber, otpController.text);
                  
                  // 2. إذا نجح، قم بالتسجيل
                  await controller.register(
                    isTenant: registrationData['isTenant'],
                    personalImage: registrationData['personalImage'],
                    idImage: registrationData['idImage'],
                  );

                } catch (e) {
                  // AuthController سيقوم بتحديث رسالة الخطأ
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/