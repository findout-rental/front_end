import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/core/routing/app_router.dart';
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
  bool _isTenant = true;

  File? _personalImage;
  File? _idImage;

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
  Future<void> _pickImage(ValueChanged<File> onPicked) async {
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
      _dobController.text = formatted;
      controller.dobController.text = formatted;
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
                  'Create Your Account',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),

                const SizedBox(height: 20),

                // Role
                RoleToggle(
                  optionOneText: 'Tenant',
                  optionTwoText: 'Owner',
                  value: _isTenant,
                  onChanged: (v) => setState(() => _isTenant = v),
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  hint: 'First Name',
                  icon: Icons.person_outline,
                  controller: controller.firstNameController,
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  hint: 'Last Name',
                  icon: Icons.person_outline,
                  controller: controller.lastNameController,
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  hint: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  controller: controller.phoneController,
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  hint: 'Date Of Birth',
                  icon: Icons.calendar_today_outlined,
                  controller: _dobController,
                  readOnly: true,
                  onTap: () => _pickDateOfBirth(context),
                ),
                const SizedBox(height: 12),

                PasswordField(
                  hint: 'Password',
                  controller: controller.passwordController,
                ),
                const SizedBox(height: 12),

                PasswordField(
                  hint: 'Confirm Password',
                  controller: controller.confirmPasswordController,
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    ImagePickerBox(
                      title: 'Personal Photo',
                      icon: Icons.person_add_alt_1_outlined,
                      image: _personalImage,
                      onTap: () =>
                          _pickImage((f) => _personalImage = f),
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

                // Error
                if (controller.errorMessage.value.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 24),

                // Register
                PrimaryButton(
                  text: controller.isLoading.value
                      ? 'Signing up...'
                      : 'Sign up',
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.register(
                            isTenant: _isTenant,
                            personalImage: _personalImage,
                            idImage: _idImage,
                          ),
                ),

                const SizedBox(height: 16),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              Get.offAllNamed(AppRouter.signIn),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Terms of service & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
