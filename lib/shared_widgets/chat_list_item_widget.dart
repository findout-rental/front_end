import 'package:flutter/material.dart';
import 'package:project/core/routing/app_router.dart';
import 'package:project/data/models/chat_model.dart';

class ChatListItem extends StatelessWidget {
  final Chat chat;

  const ChatListItem({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.chatDetail,
          arguments: chat,
        );
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),

      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(chat.imageUrl),
      ),

      title: Text(
        chat.name,
        style: theme.textTheme.titleMedium,
      ),

      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall,
      ),

      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat.time,
            style: theme.textTheme.bodySmall?.copyWith(
              color: chat.unreadCount > 0
                  ? theme.primaryColor
                  : theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 4),

          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: chat.unreadCount > 0 ? 1.0 : 0.0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
