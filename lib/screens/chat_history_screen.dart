import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_history_provider.dart';
import '../providers/user_provider.dart';
import '../config/theme.dart';

class ChatHistoryScreen extends StatelessWidget {
  final ScrollController scrollController;
  final Function(String) onChatTap;

  const ChatHistoryScreen({
    super.key,
    required this.scrollController,
    required this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatHistoryProvider>(
      builder: (context, chatHistoryProvider, _) {
        final sessions = chatHistoryProvider.chatSessions;

        if (sessions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No chats yet',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start a conversation with a user',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            final userProvider = context.read<UserProvider>();
            final user = userProvider.getUserById(session.userId);

            if (user == null) return const SizedBox.shrink();

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.accentColor,
                child: Text(
                  user.initials,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(session.userName),
              subtitle: Text(
                session.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                session.lastMessageTimeFormatted,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () => onChatTap(session.userId),
            );
          },
        );
      },
    );
  }
}
