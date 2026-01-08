// lib/services/chat_service.dart

import 'package:dio/dio.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/dio_client.dart';

class ChatService {
  final DioClient _dioClient;
  ChatService(this._dioClient);

  /// يجلب قائمة المحادثات (Conversations) للمستخدم الحالي
  Future<Response> getConversations() {
    // يتصل بـ GET /api/messages
    return _dioClient.get(ApiEndpoints.messages);
  }

  /// يجلب قائمة الرسائل لمحادثة معينة مع مستخدم آخر
  Future<Response> getMessages({required String otherUserId}) {
    // يتصل بـ GET /api/messages/{user_id}
    return _dioClient.get('${ApiEndpoints.messages}/$otherUserId');
  }

  /// يرسل رسالة جديدة عبر HTTP (لارافيل ستقوم ببثها)
  Future<Response> sendMessage({
    required String otherUserId,
    required String text,
  }) {
    // يتصل بـ POST /api/messages
    // ⚠️ تأكد من أن لارافيل تتوقع receiver_id وليس otherUserId
    return _dioClient.post(
      ApiEndpoints.messages,
      data: {'receiver_id': otherUserId, 'text': text},
    );
  }
}
