import 'package:flutter/material.dart';
import 'package:project/data/models/notification_model.dart';
import 'package:project/notification/empty_notifications_view.dart';
import 'package:project/notification/notifications_list_view.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final bool hasNotifications = true;

  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> notifications = hasNotifications
        ? [
            NotificationModel(
              title: 'تهانينا',
              subtitle: 'تم تفعيل إعلانك بنجاح',
              date: DateTime.now(),
            ),
            NotificationModel(
              title: 'رسالة جديدة',
              subtitle: 'لديك رسالة جديدة',
              date: DateTime.now().subtract(const Duration(days: 1)),
            ),
            NotificationModel(
              title: 'تنبيه',
              subtitle: 'تم تحديث سياسة الاستخدام',
              date: DateTime.now().subtract(const Duration(days: 5)),
            ),
          ]
        : <NotificationModel>[];

    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات')),
      body: notifications.isEmpty
          ? const EmptyNotificationsView()
          : NotificationsListView(notifications: notifications),
    );
  }
}
