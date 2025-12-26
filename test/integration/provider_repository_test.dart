import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat/providers/user_provider.dart';
import 'package:mini_chat/providers/message_provider.dart';
import 'package:mini_chat/providers/chat_history_provider.dart';

void main() {
  group('Provider Integration Tests', () {
    late UserProvider userProvider;
    late MessageProvider messageProvider;
    late ChatHistoryProvider chatHistoryProvider;

    setUp(() {
      userProvider = UserProvider();
      messageProvider = MessageProvider();
      chatHistoryProvider = ChatHistoryProvider();
    });

    test('UserProvider: should add and retrieve a user correctly', () {
      expect(userProvider.users.isNotEmpty, true);
      userProvider.addUser('John Doe');
      expect(userProvider.users.isNotEmpty, true);
      final user = userProvider.getUserById(userProvider.users.first.id);
      expect(user, isNotNull);
    });

    test('MessageProvider: should add and retrieve messages for a user', () {
      final userId = 'user1';
      expect(messageProvider.getMessagesByUserId(userId).isEmpty, true);
      messageProvider.addSenderMessage(userId, 'Hello');
      expect(messageProvider.getMessagesByUserId(userId).length, 1);
      expect(messageProvider.getMessagesByUserId(userId)[0].text, 'Hello');
    });

    test('ChatHistoryProvider: should create and update chat sessions', () {
      expect(chatHistoryProvider.chatSessions.isEmpty, true);
      chatHistoryProvider.updateChatSession(
        userId: 'user1',
        userName: 'Alice',
        lastMessage: 'Hi there!',
      );
      expect(chatHistoryProvider.chatSessions.length, 1);
      expect(chatHistoryProvider.chatSessions[0].lastMessage, 'Hi there!');
    });

    test('ChatHistoryProvider: should handle multiple users in chat history',
        () {
      chatHistoryProvider.updateChatSession(
        userId: 'user1',
        userName: 'Alice',
        lastMessage: 'Message 1',
      );
      chatHistoryProvider.updateChatSession(
        userId: 'user2',
        userName: 'Bob',
        lastMessage: 'Message 2',
      );
      chatHistoryProvider.updateChatSession(
        userId: 'user3',
        userName: 'Charlie',
        lastMessage: 'Message 3',
      );
      expect(chatHistoryProvider.chatSessions.length, 3);
    });

    test(
        'Integration: should support complete data flow from user to message to chat history',
        () {
      final users = userProvider.users;
      final userId = users.first.id;
      final userName = users.first.name;

      messageProvider.addSenderMessage(userId, 'Hello!');
      chatHistoryProvider.updateChatSession(
        userId: userId,
        userName: userName,
        lastMessage: 'Hello!',
      );

      expect(userProvider.getUserById(userId), isNotNull);
      expect(messageProvider.getMessagesByUserId(userId).length, 1);
      expect(chatHistoryProvider.chatSessions.length, 1);
      final session = chatHistoryProvider.chatSessions[0];
      expect(session.userId, userId);
      expect(session.lastMessage, 'Hello!');
    });

    test('Integration: should handle concurrent user and message operations',
        () {
      final users = userProvider.users.take(3).toList();

      for (final user in users) {
        for (int j = 0; j < 2; j++) {
          messageProvider.addSenderMessage(
              user.id, 'User ${user.name} Message $j');
        }
        chatHistoryProvider.updateChatSession(
          userId: user.id,
          userName: user.name,
          lastMessage: 'User ${user.name} Message 1',
        );
      }

      expect(chatHistoryProvider.chatSessions.length, 3);
      for (final user in users) {
        expect(messageProvider.getMessagesByUserId(user.id).length, 2);
      }
    });

   
  });
}
