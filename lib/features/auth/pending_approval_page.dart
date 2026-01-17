import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/core/theme/app_colors.dart';

class PendingApprovalPage extends StatelessWidget {
  const PendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String message =
        (Get.arguments is String && (Get.arguments as String).isNotEmpty)
        ? Get.arguments as String
        : 'Your account is pending approval. Please wait for admin approval.';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.hourglass_top,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                'Pending Approval',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed(AppRouter.signIn),
                  child: const Text('Back to Sign In'),
                ),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'Tip',
                    'Try again later after admin approval.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text('I\'ll try later'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
