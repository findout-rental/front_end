// lib/features/chat/screens/chats_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controllers/chat_controller.dart';
import 'package:project/shared_widgets/chat_list_item_widget.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ حقن المراقب
final ChatController controller = Get.put(
  ChatController(
    Get.find(), // dependency 1
    Get.find(), // dependency 2
    Get.find(), // dependency 3
  ),
);

    return Scaffold(
      appBar: AppBar(title: const Text("My Chats")),
      body: Obx(() {
        // ✅ استخدام Obx
        if (controller.isLoadingConversations.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.conversations.isEmpty) {
          return const Center(child: Text("No conversations yet."));
        }
        return ListView.builder(
          itemCount: controller.conversations.length,
          itemBuilder: (context, index) {
            final chat = controller.conversations[index];
            return ChatListItem(chat: chat);
          },
        );
      }),
    );
  }
}
