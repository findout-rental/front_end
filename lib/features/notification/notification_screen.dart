import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/notification_controller.dart';
import 'package:project/features/notification/empty_notifications_view.dart';
import 'package:project/features/notification/notifications_list_view.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          Obx(
            () => controller.notifications.isEmpty
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: controller.markAllAsRead,
                    child: const Text('Mark all as read'),
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const EmptyNotificationsView();
        }

        return NotificationsListView(notifications: controller.notifications);
      }),
    );
  }
}
