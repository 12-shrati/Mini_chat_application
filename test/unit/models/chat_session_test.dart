import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat/models/chat_session.dart';

void main() {
  group('ChatSession Model', () {
    test('ChatSession creation with valid data', () {
      final now = DateTime.now();
      final session = ChatSession(
        userId: '1',
        userName: 'John Doe',
        lastMessage: 'Hello',
        lastMessageTime: now,
      );

      expect(session.userId, '1');
      expect(session.userName, 'John Doe');
      expect(session.lastMessage, 'Hello');
      expect(session.lastMessageTime, now);
    });

    test('ChatSession lastMessageTimeFormatted returns non-empty string', () {
      final session = ChatSession(
        userId: '1',
        userName: 'John Doe',
        lastMessage: 'Hello',
        lastMessageTime: DateTime.now(),
      );

      expect(session.lastMessageTimeFormatted.isNotEmpty, true);
    });
  });
}
