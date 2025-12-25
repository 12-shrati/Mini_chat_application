import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat/providers/chat_history_provider.dart';

void main() {
  group('ChatHistoryProvider', () {
    late ChatHistoryProvider chatHistoryProvider;

    setUp(() {
      chatHistoryProvider = ChatHistoryProvider();
    });

    test('Initial chat sessions list is empty', () {
      expect(chatHistoryProvider.chatSessions.isEmpty, true);
    });

    test('updateChatSession creates new session', () {
      chatHistoryProvider.updateChatSession(
        userId: '1',
        userName: 'John Doe',
        lastMessage: 'Hello',
      );

      expect(chatHistoryProvider.chatSessions.length, 1);
      expect(chatHistoryProvider.chatSessions[0].userId, '1');
      expect(chatHistoryProvider.chatSessions[0].userName, 'John Doe');
      expect(chatHistoryProvider.chatSessions[0].lastMessage, 'Hello');
    });

    test('updateChatSession updates existing session', () {
      chatHistoryProvider.updateChatSession(
        userId: '1',
        userName: 'John Doe',
        lastMessage: 'First message',
      );

      chatHistoryProvider.updateChatSession(
        userId: '1',
        userName: 'John Doe',
        lastMessage: 'Updated message',
      );

      expect(chatHistoryProvider.chatSessions.length, 1);
      expect(
          chatHistoryProvider.chatSessions[0].lastMessage, 'Updated message');
    });

    test('updateChatSession notifies listeners', () {
      var listenerCalled = false;
      chatHistoryProvider.addListener(() {
        listenerCalled = true;
      });

      chatHistoryProvider.updateChatSession(
        userId: '1',
        userName: 'John Doe',
        lastMessage: 'Test',
      );

      expect(listenerCalled, true);
    });

    test('Multiple sessions for different users', () {
      chatHistoryProvider.updateChatSession(
        userId: '1',
        userName: 'User One',
        lastMessage: 'Message 1',
      );

      chatHistoryProvider.updateChatSession(
        userId: '2',
        userName: 'User Two',
        lastMessage: 'Message 2',
      );

      expect(chatHistoryProvider.chatSessions.length, 2);
    });
  });
}
