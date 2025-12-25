import 'package:intl/intl.dart';

class ChatSession {
  final String userId;
  final String userName;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatSession({
    required this.userId,
    required this.userName,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  String get lastMessageTimeFormatted {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(
        lastMessageTime.year, lastMessageTime.month, lastMessageTime.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(lastMessageTime);
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM').format(lastMessageTime);
    }
  }
}
