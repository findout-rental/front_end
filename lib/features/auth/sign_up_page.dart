// lib/features/auth/sign_up_page.dart

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/core/routing/app_router.dart' show AppRouter;
import 'package:project/shared_widgets/custom_text_field.dart'
    show CustomTextField;
import 'package:project/shared_widgets/image_picker_box.dart'
    show ImagePickerBox;
import 'package:project/shared_widgets/password_field.dart' show PasswordField;
import 'package:project/shared_widgets/primary_button.dart' show PrimaryButton;
import 'package:project/shared_widgets/role_toggle.dart' show RoleToggle;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isTenant = true;
  File? _personalImage;
  File? _idImage;
  final _picker = ImagePicker();
  final _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ValueChanged<File> onImagePicked) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => onImagePicked(File(picked.path)));
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
      _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
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

              RoleToggle(
                optionOneText: 'Tenant',
                optionTwoText: 'Owner',
                value: _isTenant,
                onChanged: (value) => setState(() => _isTenant = value),
              ),

              const SizedBox(height: 20),
              const CustomTextField(
                hint: 'First Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              const CustomTextField(
                hint: 'Last Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              const CustomTextField(
                hint: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
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
              const PasswordField(hint: 'Password'),
              const SizedBox(height: 12),
              const PasswordField(hint: 'Confirm Password'),
              const SizedBox(height: 20),

              Row(
                children: [
                  ImagePickerBox(
                    title: 'Personal Photo',
                    icon: Icons.person_add_alt_1_outlined,
                    image: _personalImage,
                    onTap: () => _pickImage((file) => _personalImage = file),
                  ),
                  const SizedBox(width: 12),
                  ImagePickerBox(
                    title: 'ID Photo',
                    icon: Icons.badge_outlined,
                    image: _idImage,
                    onTap: () => _pickImage((file) => _idImage = file),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              PrimaryButton(
                text: 'Sign up',
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, AppRouter.home),
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
                        ..onTap = () => Navigator.pushReplacementNamed(
                          context,
                          AppRouter.signIn,
                        ),
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
    );
  }
}
