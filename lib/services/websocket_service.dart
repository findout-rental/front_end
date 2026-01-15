// lib/services/websocket_service.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:project/core/storage/auth_storage.dart';

class WebsocketService {
  final AuthStorage _authStorage = Get.find<AuthStorage>();
  IO.Socket? _socket;

  /// الاتصال بالسيرفر
  void connect() {
    final token = _authStorage.token;
    if (token == null) {
      print('❌ WebSocket: No auth token');
      return;
    }

    if (_socket != null && _socket!.connected) {
      print('ℹ️ WebSocket already connected');
      return;
    }

    _socket = IO.io(
      'http://192.168.1.105:8000', // عدلها حسب السيرفر
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('✅ WebSocket connected');
    });

    _socket!.onDisconnect((_) {
      print('🔌 WebSocket disconnected');
    });

    _socket!.onError((e) {
      print('❌ WebSocket error: $e');
    });
  }

  /// الاستماع لحدث
  void listen(
    String eventName, // تم تعديل التوقيع ليكون أبسط
    void Function(String data) onData,
  ) {
    if (_socket == null) {
      print('❌ WebSocket not connected');
      return;
    }

    _socket!.on(eventName, (data) {
      if (data == null) return;
      if (data is String) {
        onData(data);
      } else {
        onData(jsonEncode(data));
      }
    });

    print('👂 Listening to event: $eventName');
  }

  /// إرسال حدث (اختياري)
  void emit(String eventName, dynamic data) {
    _socket?.emit(eventName, data);
  }

  /// قطع الاتصال
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    print('🔴 WebSocket closed');
  }
}
