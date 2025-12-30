// lib/notification/notifications_list_view.dart
import 'package:flutter/material.dart';
import 'package:project/core/utils/date_formatter.dart';
import 'package:project/data/models/notification_model.dart';

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
          _sectionTitle(context, 'Today'),
          ...today.map((n) => _notificationTile(context, n)),
        ],
        if (yesterday.isNotEmpty) ...[
          const SizedBox(height: 20),
          _sectionTitle(context, 'Yesterday'),
          ...yesterday.map((n) => _notificationTile(context, n)),
        ],
        if (earlier.isNotEmpty) ...[
          const SizedBox(height: 20),
          _sectionTitle(context, 'Earlier'),
          ...earlier.map((n) => _notificationTile(context, n)),
        ],
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 16),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _notificationTile(
    BuildContext context,
    NotificationModel notification,
  ) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor.withOpacity(0.1),
          child: Icon(Icons.notifications_outlined, color: theme.primaryColor),
        ),
        title: Text(
          notification.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.subtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              formatDate(notification.date),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
