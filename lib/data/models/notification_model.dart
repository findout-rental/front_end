// lib/data/models/notification_model.dart

class NotificationModel {
  final String id; // ✅ إضافة ID
  final String title;
  final String subtitle;
  final DateTime date;
  final bool isRead; // ✅ إضافة حالة القراءة

  const NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    this.isRead = false,
  });

  /// ✅ دالة Factory لتحويل JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // ⚠️ تأكد من أن هذه الحقول تتطابق مع استجابة لارافيل
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title:
          json['data']['title'] ??
          'No Title', // الإشعارات في لارافيل غالبًا ما تكون متداخلة
      subtitle: json['data']['body'] ?? '',
      date: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isRead: json['read_at'] != null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'date': date.toIso8601String(),
    'is_read': isRead,
  };
}
