// lib/features/notification/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/notification_controller.dart';
import 'package:project/features/notification/empty_notifications_view.dart';
import 'package:project/features/notification/notifications_list_view.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ حقن المراقب. سيتم إنشاؤه مرة واحدة عند فتح الصفحة.
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          // ✅ زر لوضع علامة "مقروء" على الكل
          TextButton(
            onPressed: controller.markAllAsRead,
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: Obx(() {
        // ✅ استخدام Obx لمراقبة الحالة
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        // استخدام controller.notifications بدلاً من المتغير المحلي
        return controller.notifications.isEmpty
            ? const EmptyNotificationsView()
            : NotificationsListView(notifications: controller.notifications);
      }),
    );
  }
}
