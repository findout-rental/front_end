import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/language_controller.dart';
import 'package:project/controllers/theme_controller.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/data/models/user_model.dart';
import 'package:project/shared_widgets/role_toggle.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ThemeController themeController = Get.find<ThemeController>();
    final LanguageController langController = Get.find<LanguageController>();
    final user = UserModel.dummy();

    return Scaffold(
      appBar: AppBar(title: Text('profile'.tr), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          /// 🧑 User Info
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
                child: user.profileImageUrl == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phone,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Divider(height: 50),

          /// 🌙 Theme Toggle (Obx فقط هنا)
          _buildProfileOption(
            context: context,
            icon: Icons.brightness_6_outlined,
            title: 'theme'.tr,
            trailing: SizedBox(
              width: 150,
              child: Obx(() {
                return RoleToggle(
                  optionOneText: 'Light'.tr,
                  optionTwoText: 'Night'.tr,
                  value: themeController.isLightMode.value,
                  onChanged: themeController.toggleTheme,
                );
              }),
            ),
          ),
          _buildProfileOption(
            context: context,
            icon: Icons.language_outlined,
            title: 'language'.tr,
            trailing: SizedBox(
              width: 150,
              child: Obx(() {
                return RoleToggle(
                  optionOneText: 'English',
                  optionTwoText: 'العربية',
                  // ✅ التعديل: value: true  -> 'English' is selected
                  value: langController.isEnglish,
                  onChanged: (_) => langController.toggleLanguage(),
                );
              }),
            ),
          ),
          _buildProfileOption(
            context: context,
            icon: Icons.edit_outlined,
            title: 'edit_profile'.tr,
            onTap: () => Get.toNamed(AppRouter.editProfile),
          ),

          _buildProfileOption(
            context: context,
            icon: Icons.settings_outlined,
            title: 'settings'.tr,
            onTap: () {},
          ),

          const Divider(height: 40),

          _buildProfileOption(
            context: context,
            icon: Icons.logout,
            title: 'logout'.tr,
            isLogout: true,
            onTap: () {
              Get.snackbar(
                'Logout'.tr,
                'You have been logged out successfully.'.tr,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    bool isLogout = false,
  }) {
    final theme = Theme.of(context);
    final Color color = isLogout
        ? theme.colorScheme.error
        : theme.textTheme.bodyLarge!.color!;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: color,
          fontWeight: isLogout ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      trailing:
          trailing ??
          (isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
    );
  }
}
