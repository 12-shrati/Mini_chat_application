import 'package:flutter/foundation.dart';
import '../models/chat_session.dart';

class ChatHistoryProvider extends ChangeNotifier {
  final Map<String, ChatSession> _chatSessions = {};

  List<ChatSession> get chatSessions {
    final sessions = _chatSessions.values.toList();
    sessions.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return List.unmodifiable(sessions);
  }

  void updateChatSession({
    required String userId,
    required String userName,
    required String lastMessage,
  }) {
    _chatSessions[userId] = ChatSession(
      userId: userId,
      userName: userName,
      lastMessage: lastMessage,
      lastMessageTime: DateTime.now(),
    );
    notifyListeners();
  }

  ChatSession? getChatSession(String userId) {
    return _chatSessions[userId];
  }
}
