import 'package:flutter/material.dart';

class EmptyNotificationsView extends StatelessWidget {
  const EmptyNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {

    
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 30),
            const Text(
              'Oops!!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('لا توجد إشعارات بعد', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'أي إشعار سيتم إرساله سيظهر هنا\nويمكنك متابعته في أي وقت',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
