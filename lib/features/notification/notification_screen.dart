import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/notification_controller.dart';
import 'package:project/features/notification/empty_notifications_view.dart';
import 'package:project/features/notification/notifications_list_view.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ إنشاء المراقب مرة واحدة عند فتح الصفحة
    final NotificationController controller =
    Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          // زر تعليم الكل كمقروء
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
        // حالة التحميل الأولى
        if (controller.isLoading.value &&
            controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // لا يوجد إشعارات
        if (controller.notifications.isEmpty) {
          return const EmptyNotificationsView();
        }

        // عرض الإشعارات
        return NotificationsListView(
          notifications: controller.notifications,
        );
      }),
    );
  }
}
