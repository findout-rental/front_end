import 'package:flutter/material.dart';
import 'package:project/data/models/notification_model.dart';
import 'package:project/shared_widgets/date_formatter.dart';

class NotificationsListView extends StatelessWidget {
  final List<NotificationModel> notifications;

  const NotificationsListView({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    final today = notifications.where((n) => isToday(n.date)).toList();
    final yesterday = notifications.where((n) => isYesterday(n.date)).toList();
    final earlier = notifications
        .where((n) => !isToday(n.date) && !isYesterday(n.date))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (today.isNotEmpty) ...[
          _sectionTitle('Today'),
          ...today.map(_notificationTile),
        ],
        if (yesterday.isNotEmpty) ...[
          const SizedBox(height: 20),
          _sectionTitle('Yesterday'),
          ...yesterday.map(_notificationTile),
        ],
        if (earlier.isNotEmpty) ...[
          const SizedBox(height: 20),
          _sectionTitle('Earlier'),
          ...earlier.map(_notificationTile),
        ],
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _notificationTile(NotificationModel notification) {
    return ListTile(
      // ✅ تمييز الإشعارات غير المقروءة
      tileColor: notification.isRead ? null : Colors.blue.withOpacity(0.05),
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: notification.isRead
            ? Colors.grey.shade300
            : Color(0xFFEDE7F6),
        child: Icon(
          Icons.notifications_outlined,
          color: notification.isRead ? Colors.grey.shade600 : Colors.deepPurple,
        ),
      ),
      title: Text(notification.title, style: const TextStyle(fontSize: 14)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.subtitle, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 2),
          Text(
            formatDate(notification.date), // 👈 هون بالضبط
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),

      onTap: () {
        // handle click later
      },
    );
  }
}
