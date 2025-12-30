// lib/screens/chats_screen.dart


import 'package:flutter/material.dart';
import 'package:project/data/models/chat_model.dart' show mockChats;
import 'package:project/shared_widgets/chat_list_item_widget.dart' show ChatListItemWidget; 

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Chats"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mockChats.length, 
        itemBuilder: (context, index) {
          final chat = mockChats[index];
          return ChatListItemWidget(chat: chat);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
