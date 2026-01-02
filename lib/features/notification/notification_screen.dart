import 'package:flutter/material.dart';
import 'package:project/notification/empty_notifications_view.dart';
import 'package:project/data/models/notification_model.dart';
import 'package:project/notification/notifications_list_view.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  /// فقط للتجربة
  final bool hasNotifications = false; // غيّرها true / false

  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> notifications = hasNotifications
        ? [
      NotificationModel(
        title: 'تهانينا',
        subtitle: 'تم تفعيل إعلانك بنجاح',
        date: DateTime.now(), // Today
      ),
      NotificationModel(
        title: 'رسالة جديدة',
        subtitle: 'لديك رسالة جديدة',
        date: DateTime.now().subtract(const Duration(days: 1)), // Yesterday
      ),
      NotificationModel(
        title: 'تنبيه',
        subtitle: 'تم تحديث سياسة الاستخدام',
        date: DateTime.now().subtract(const Duration(days: 5)), // Earlier
      ),
    ]
        : <NotificationModel>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: notifications.isEmpty
          ? const EmptyNotificationsView()
          : NotificationsListView(notifications: notifications),
    );
  }
}

