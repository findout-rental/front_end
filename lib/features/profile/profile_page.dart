import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/language_controller.dart';
import 'package:project/controllers/theme_controller.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/shared_widgets/role_toggle.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final AuthController authController = Get.find<AuthController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final LanguageController langController = Get.find<LanguageController>();

    final bool isLightMode = !Get.isDarkMode;
    final bool isEnglish = (Get.locale?.languageCode ?? 'en') == 'en';

    return Scaffold(
      appBar: AppBar(title: Text('profile'.tr), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Obx(() {
            final user = authController.currentUser.value;

            final fullName = user?.fullName ?? '...';
            final phone = user?.phone ?? '';
            final imageUrl = user?.profileImageUrl;

            return Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                      ? NetworkImage(imageUrl)
                      : null,
                  child: (imageUrl == null || imageUrl.isEmpty)
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        phone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

          const Divider(height: 50),

          _buildProfileOption(
            context: context,
            icon: Icons.brightness_6_outlined,
            title: 'theme'.tr,
            trailing: SizedBox(
              width: 150,
              child: RoleToggle(
                optionOneText: 'Light'.tr,
                optionTwoText: 'Night'.tr,
                value: isLightMode,
                onChanged: themeController.toggleTheme,
              ),
            ),
          ),

          _buildProfileOption(
            context: context,
            icon: Icons.language_outlined,
            title: 'language'.tr,
            trailing: SizedBox(
              width: 150,
              child: RoleToggle(
                optionOneText: 'English',
                optionTwoText: 'العربية',
                value: isEnglish,
                onChanged: (_) => langController.toggleLanguage(),
              ),
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
              Get.defaultDialog(
                title: 'confirm'.tr,
                middleText: 'confirm_logout'.tr,
                textConfirm: 'logout'.tr,
                textCancel: 'cancel'.tr,
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back();
                  authController.logout();
                },
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
        : (theme.textTheme.bodyLarge?.color ?? theme.colorScheme.onSurface);

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
