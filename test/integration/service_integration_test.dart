import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat/services/api_service.dart';
import 'package:mini_chat/providers/user_provider.dart';
import 'package:mini_chat/providers/message_provider.dart';
import 'package:mini_chat/providers/chat_history_provider.dart';

void main() {
  group('Service-Provider Integration Tests', () {
    late ApiService apiService;
    late UserProvider userProvider;
    late MessageProvider messageProvider;
    late ChatHistoryProvider chatHistoryProvider;

    setUp(() {
      apiService = ApiService();
      userProvider = UserProvider();
      messageProvider = MessageProvider();
      chatHistoryProvider = ChatHistoryProvider();
    });

    test('API Service can be instantiated', () {
      expect(apiService, isNotNull);
      expect(userProvider.users.isNotEmpty, true);
    });

    test('Complete workflow: Provider integration', () {
      final users = userProvider.users;
      expect(users.isNotEmpty, true);

      final firstUser = users.first;
      userProvider.addUser(firstUser.name);

      expect(userProvider.users.isNotEmpty, true);
      expect(userProvider.getUserById(firstUser.id), isNotNull);
    });

    test('Message flow through providers', () {
      final users = userProvider.users;
      final userId = users.first.id;

      messageProvider.addSenderMessage(userId, 'Test message');

      expect(messageProvider.getMessagesByUserId(userId).length, 1);
      expect(
          messageProvider.getMessagesByUserId(userId)[0].text, 'Test message');
    });

    test('Chat session lifecycle across providers', () {
      final users = userProvider.users;
      final firstUser = users.first;

      messageProvider.addSenderMessage(firstUser.id, 'Starting conversation');

      chatHistoryProvider.updateChatSession(
        userId: firstUser.id,
        userName: firstUser.name,
        lastMessage: 'Starting conversation',
      );

      expect(userProvider.getUserById(firstUser.id), isNotNull);
      expect(messageProvider.getMessagesByUserId(firstUser.id).length, 1);
      expect(chatHistoryProvider.chatSessions.length, 1);
    });

    test('Multiple users concurrent operations', () {
      final users = userProvider.users.take(3).toList();

      for (final user in users) {
        for (int j = 0; j < 3; j++) {
          messageProvider.addSenderMessage(
            user.id,
            'Message $j from ${user.name}',
          );

          chatHistoryProvider.updateChatSession(
            userId: user.id,
            userName: user.name,
            lastMessage: 'Message $j from ${user.name}',
          );
        }
      }

      expect(chatHistoryProvider.chatSessions.length, 3);

      for (final user in users) {
        expect(messageProvider.getMessagesByUserId(user.id).length, 3);
      }
    });

    test('Error recovery in integrated flow', () {
      const invalidUserId = '';

      // Try with invalid ID (should handle gracefully)
      final invalidUser = userProvider.getUserById(invalidUserId);
      expect(invalidUser, isNull);
    });

    test('State consistency across multiple operations', () {
      final users = userProvider.users;
      final firstUser = users.first;

      // Perform series of operations
      for (int i = 0; i < 5; i++) {
        messageProvider.addSenderMessage(firstUser.id, 'Test message $i');
        chatHistoryProvider.updateChatSession(
          userId: firstUser.id,
          userName: firstUser.name,
          lastMessage: 'Test message $i',
        );
      }

      // Verify final state consistency
      expect(userProvider.getUserById(firstUser.id)!.name, firstUser.name);
      expect(messageProvider.getMessagesByUserId(firstUser.id).length, 5);
      expect(chatHistoryProvider.chatSessions.length, 1);
      expect(
        chatHistoryProvider.chatSessions[0].lastMessage,
        'Test message 4',
      );
    });

    test('Chat message ordering in integrated flow', () {
      final users = userProvider.users;
      final userId = users.first.id;

      // Add messages
      messageProvider.addSenderMessage(userId, 'First');
      messageProvider.addSenderMessage(userId, 'Second');
      messageProvider.addSenderMessage(userId, 'Third');

      for (int i = 0; i < 3; i++) {
        final msgs = messageProvider.getMessagesByUserId(userId);
        chatHistoryProvider.updateChatSession(
          userId: userId,
          userName: users.first.name,
          lastMessage: msgs[i].text,
        );
      }

      // Verify ordering
      final storedMessages = messageProvider.getMessagesByUserId(userId);
      expect(storedMessages.length, 3);
      expect(storedMessages[0].text, 'First');
      expect(storedMessages[1].text, 'Second');
      expect(storedMessages[2].text, 'Third');

      // Verify chat history has latest message
      expect(chatHistoryProvider.chatSessions[0].lastMessage, 'Third');
    });
  });

  group('Performance Integration Tests', () {
    test('Handle large number of users', () {
      final userProvider = UserProvider();
      const userCount = 100;

      for (int i = 0; i < userCount; i++) {
        userProvider.addUser('User $i');
      }

      expect(userProvider.users.length >= userCount, true);
    });

    test('Handle large number of messages per user', () {
      final messageProvider = MessageProvider();
      const userId = 'user1';
      const messageCount = 100;

      for (int i = 0; i < messageCount; i++) {
        messageProvider.addSenderMessage(userId, 'Message $i');
      }

      expect(messageProvider.getMessagesByUserId(userId).length, messageCount);
    });

    test('Handle concurrent chat sessions', () {
      final chatHistoryProvider = ChatHistoryProvider();
      const sessionCount = 50;

      for (int i = 0; i < sessionCount; i++) {
        chatHistoryProvider.updateChatSession(
          userId: 'user$i',
          userName: 'User $i',
          lastMessage: 'Message from user $i',
        );
      }

      expect(chatHistoryProvider.chatSessions.length, sessionCount);
    });
  });
}
