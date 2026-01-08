// lib/features/chat/screens/chat_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/chat_controller.dart';
import 'package:project/data/models/chat_model.dart';
import 'package:project/data/models/message_model.dart';


class ChatDetailScreen extends StatefulWidget {
  final Chat chat; // استقبل كائن المحادثة
  const ChatDetailScreen({Key? key, required this.chat}) : super(key: key);
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  // ✅ الوصول إلى المراقب
  final ChatController controller = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    // ✅ جلب الرسائل عند بدء الشاشة
    controller.fetchMessages(widget.chat.userId); // افترض وجود userId في Chat model
  }

  void _sendMessage() {
    // ✅ استدعاء دالة الإرسال في المراقب
    controller.sendMessage(_textController.text, widget.chat.userId);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chat.name)),
      body: Column(
        children: [
          Expanded(
            child: Obx(() { // ✅ استخدام Obx
              if (controller.isLoadingMessages.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return _MessageBubble(message: message);
                },
              );
            }),
          ),
          _TextInputArea(
            textController: _textController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isMe = message.isMe;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isMe ? theme.colorScheme.primary : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(16),
            ),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: isMe ? Colors.white : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }
}

class _TextInputArea extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSend;

  const _TextInputArea({required this.textController, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "اكتب رسالة...",
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: theme.primaryColor),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
