/*
import 'dart:convert';
import 'package:get/get.dart';
import 'package:project/data/models/chat_model.dart';
import 'package:project/data/models/message_model.dart';
import 'package:project/services/chat_service.dart';
import 'package:project/services/websocket_service.dart';
import 'package:project/controllers/auth_controller.dart';

class ChatController extends GetxController {

  final ChatService _chatService;
  final WebsocketService _websocketService;
  final AuthController _authController;
  ChatController(
    this._chatService,
    this._websocketService,
    this._authController,
  );
  final conversations = <Chat>[].obs;
  final messages = <Message>[].obs;
  final isLoadingConversations = false.obs;
  final isLoadingMessages = false.obs;
  final isTyping = false.obs;

  String? _currentChannelName;

  @override
  void onInit() {
    super.onInit();
    if (_authController.isLoggedIn) {
      fetchConversations();
      _websocketService.connect();
    }
  }

  @override
  void onClose() {
    _websocketService.disconnect();
    super.onClose();
  }

  Future<void> fetchConversations() async {
  }

  Future<void> fetchMessages(String otherUserId) async {
    final myUserId = _authController.currentUser.value?.uid;
    if (myUserId == null) {
      print("Chat Error: Current user is null, cannot fetch messages.");
      return;
    }

    try {
      isLoadingMessages.value = true;
      messages.clear();
      final response = await _chatService.getMessages(otherUserId: otherUserId);
      final List<dynamic> data = response.data['data'] ?? [];

      final fetchedMessages = data.map((json) {
        return Message.fromJson(
          json,
          currentUserId: myUserId,
        );
      }).toList();

      messages.assignAll(fetchedMessages.reversed);
      _listenToChannel(otherUserId);
    } catch (e) {
      print("Fetch Messages Error: $e");
    } finally {
      isLoadingMessages.value = false;
    }
  }

  Future<void> sendMessage(String text, String otherUserId) async {
    if (text.trim().isEmpty) return;
    final myUserId = _authController.currentUser.value?.uid;
    if (myUserId == null) {
      Get.snackbar('Error', 'You must be logged in to send messages.');
      return;
    }

    final tempMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      time: DateTime.now().toIso8601String(),
      senderId: myUserId,
      isMe: true,
    );
    messages.insert(0, tempMessage);

    try {
      await _chatService.sendMessage(otherUserId: otherUserId, text: text);
    } catch (e) {
      messages.removeWhere((m) => m.id == tempMessage.id);
      Get.snackbar('Error', 'Failed to send message.');
      print("Send Message Error: $e");
    }
  }

  void _listenToChannel(String otherUserId) {
    final myUserId = _authController.currentUser.value?.uid;
    if (myUserId == null) return;

    final ids = [int.parse(myUserId), int.parse(otherUserId)]..sort();
    final channelName = 'private-chat.${ids[0]}.${ids[1]}';

    if (_currentChannelName == channelName) return;
    _currentChannelName = channelName;

    _websocketService.listen(
      channelName,
      'new-message',
          (String rawData) {
        try {
          final decodedData = jsonDecode(rawData);
          final Map<String, dynamic> messageData = decodedData['message'];

          final message = Message.fromJson(
            messageData,
            currentUserId: myUserId,
          );

          if (!messages.any((m) => m.id == message.id)) {
            messages.insert(0, message);
          }
        } catch (e) {
          print("❌ WebSocket parse error: $e");
        }
      },
    );
  }
}
*/