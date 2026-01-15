// lib/features/profile/presentation/screens/edit_profile_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/shared_widgets/custom_text_field.dart';
import 'package:project/shared_widgets/primary_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthController authController = Get.find<AuthController>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // ملء الحقول بالبيانات الحالية للمستخدم
    final user = authController.currentUser.value;
    final nameParts = user?.fullName.split(' ') ?? ['first'.tr, 'last'.tr];
    _firstNameController = TextEditingController(text: nameParts.first);
    _lastNameController = TextEditingController(
      text: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  void _submit() {
    authController.updateUserProfile(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      profileImage: _profileImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('edit_profile')),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!) as ImageProvider
                      : (authController.currentUser.value?.profileImageUrl !=
                                null
                            ? NetworkImage(
                                authController
                                    .currentUser
                                    .value!
                                    .profileImageUrl!,
                              )
                            : null),
                  child:
                      _profileImage == null &&
                          authController.currentUser.value?.profileImageUrl ==
                              null
                      ? const Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: _firstNameController,
                hint: 'first_name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _lastNameController,
                hint: 'last_name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                text: authController.isLoading.value
                    ? 'saving...'
                    : 'save_changes',
                onPressed: authController.isLoading.value ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
