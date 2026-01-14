// lib/services/notification_service.dart

import 'package:dio/dio.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/dio_client.dart';

class NotificationService {
  final DioClient _dioClient;
  NotificationService(this._dioClient);

  /// يجلب قائمة إشعارات المستخدم الحالي
  Future<Response> getNotifications() {
    return _dioClient.get(ApiEndpoints.notifications);
  }

  /// (مستقبلي) يضع علامة "مقروء" على جميع الإشعارات
  Future<Response> markAllAsRead() {
    return _dioClient.post('${ApiEndpoints.notifications}/mark-as-read');
  }
}
