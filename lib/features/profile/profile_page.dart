// lib/features/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:project/data/models/user_model.dart';
import 'package:project/providers/theme_provider.dart';
import 'package:project/shared_widgets/role_toggle.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final themeProvider = Provider.of<ThemeProvider>(context);

    final user = UserModel.dummy();

    return Scaffold(
      appBar: AppBar(title: const Text('حسابي (تجريبي)'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
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
          const Divider(height: 50, thickness: 0.8),

          _buildProfileOption(
            context: context,
            icon: Icons.brightness_6_outlined,
            title: 'الوضع',
            trailing: SizedBox(
              width: 150,
              child: RoleToggle(
                optionOneText: 'نهاري',
                optionTwoText: 'ليلي',
                value: themeProvider.isLightMode,
                onChanged: (isLight) {
                  themeProvider.toggleTheme(isLight);
                },
              ),
            ),
          ),

          _buildProfileOption(
            context: context,
            icon: Icons.edit_outlined,
            title: 'تعديل الملف الشخصي',
            onTap: () {},
          ),
          _buildProfileOption(
            context: context,
            icon: Icons.settings_outlined,
            title: 'الإعدادات',
            onTap: () {},
          ),
          _buildProfileOption(
            context: context,
            icon: Icons.brightness_6_outlined,
            title: 'اللغة',
            trailing: SizedBox(
              width: 150,
              child: RoleToggle(
                optionOneText: 'عربي',
                optionTwoText: 'انكليزي',
                value: themeProvider.isLightMode,
                onChanged: (isLight) {
                  themeProvider.toggleTheme(isLight);
                },
              ),
            ),
          ),
          const Divider(height: 40),

          _buildProfileOption(
            context: context,
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تعطيل تسجيل الخروج في الوضع التجريبي.'),
                ),
              );
            },
            isLogout: true,
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
