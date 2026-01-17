import 'package:dio/dio.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/dio_client.dart';

class ChatService {
  final DioClient _dioClient;
  ChatService(this._dioClient);

  Future<Response> getConversations() {
    return _dioClient.get(ApiEndpoints.messages);
  }

  Future<Response> getMessages({required String otherUserId}) {
    return _dioClient.get('${ApiEndpoints.messages}/$otherUserId');
  }

  Future<Response> sendMessage({
    required String otherUserId,
    required String text,
  }) {
    return _dioClient.post(
      ApiEndpoints.messages,
      data: {'receiver_id': otherUserId, 'text': text},
    );
  }
}
