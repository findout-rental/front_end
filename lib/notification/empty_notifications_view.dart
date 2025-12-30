// lib/notification/empty_notifications_view.dart

import 'package:flutter/material.dart';

class EmptyNotificationsView extends StatelessWidget {
  const EmptyNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 100,
              color: theme.dividerColor,
            ),
            const SizedBox(height: 30),
            Text('Oops!!', style: theme.textTheme.titleLarge),
            const SizedBox(height: 10),
            Text('لا توجد إشعارات بعد', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'أي إشعار سيتم إرساله سيظهر هنا\nويمكنك متابعته في أي وقت',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
