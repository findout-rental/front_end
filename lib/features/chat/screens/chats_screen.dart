// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:project/controllers/chat_controller.dart';
// import 'package:project/shared_widgets/chat_list_item_widget.dart';

// class ChatsScreen extends StatelessWidget {
//   const ChatsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // ✅ جلب المراقب الصحيح (بدون إنشاء جديد)
//     final ChatController controller = Get.find<ChatController>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Chats"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               // TODO: search chats
//             },
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoadingConversations.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (controller.conversations.isEmpty) {
//           return const Center(
//             child: Text("No conversations yet."),
//           );
//         }
//         return ListView.builder(
//           itemCount: controller.conversations.length,
//           itemBuilder: (context, index) {
//             final chat = controller.conversations[index];
//             return ChatListItem(chat: chat);
//           },
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // TODO: start new chat
//         },
//         child: const Icon(Icons.chat_bubble_outline),
//       ),
//     );
//   }
// }
