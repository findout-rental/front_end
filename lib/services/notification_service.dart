import 'package:dio/dio.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/dio_client.dart';

class NotificationService {
  final DioClient _dioClient;
  NotificationService(this._dioClient);

  Future<Response> getNotifications() {
    return _dioClient.get(ApiEndpoints.notifications);
  }

  Future<Response> markAllAsRead() {
    return _dioClient.post('${ApiEndpoints.notifications}/mark-as-read');
  }
}
