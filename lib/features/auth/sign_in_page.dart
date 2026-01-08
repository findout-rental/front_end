import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/shared_widgets/custom_text_field.dart';
import 'package:project/shared_widgets/password_field.dart';
import 'package:project/shared_widgets/primary_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Auth controller (GetX)
    final AuthController controller = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.home_work_outlined,
                    size: 80,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),

                  const SizedBox(height: 30),

                  // Phone
                  CustomTextField(
                    controller: controller.phoneController,
                    hint: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  // Password
                  PasswordField(
                    controller: controller.passwordController,
                    hint: 'Password',
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.toNamed(AppRouter.forgotPassword),
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(color: theme.primaryColor),
                      ),
                    ),
                  ),

                  // Error message
                  if (controller.errorMessage.value.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Login button
                  PrimaryButton(
                    text: controller.isLoading.value
                        ? 'Signing in...'
                        : 'Sign in',
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.login,
                  ),

                  const SizedBox(height: 24),

                  // Sign up
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(AppRouter.signUp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
