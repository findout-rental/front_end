import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/otp_controller.dart';
import 'package:project/shared_widgets/primary_button.dart';

class OtpPage extends GetView<OtpController> {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد رقم الهاتف')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'أدخل رمز التحقق المرسل إلى رقمك',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return _OtpBox(index);
              }),
            ),

            const SizedBox(height: 24),

            Obx(() {
              return TextButton(
                onPressed: controller.resendSeconds.value == 0
                    ? controller.resendOtp
                    : null,
                child: Text(
                  controller.resendSeconds.value == 0
                      ? 'إعادة إرسال الرمز'
                      : 'إعادة الإرسال بعد ${controller.resendSeconds.value} ث',
                ),
              );
            }),

            const Spacer(),

            Obx(() {
              return PrimaryButton(
                text: controller.isLoading.value ? 'جارٍ التحقق...' : 'تأكيد',
                onPressed: controller.isLoading.value
                    ? null
                    : controller.verifyOtp,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _OtpBox extends GetView<OtpController> {
  final int index;
  const _OtpBox(this.index);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      child: TextField(
        controller: controller.controllers[index],
        focusNode: controller.focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: const InputDecoration(counterText: ''),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            controller.focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            controller.focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
