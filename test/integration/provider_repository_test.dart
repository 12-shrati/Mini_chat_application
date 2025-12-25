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

    test('UserProvider works correctly', () {
      expect(userProvider.users.isNotEmpty, true);
      userProvider.addUser('John Doe');
      expect(userProvider.users.isNotEmpty, true);
      final user = userProvider.getUserById(userProvider.users.first.id);
      expect(user, isNotNull);
    });

    test('MessageProvider manages messages correctly', () {
      final userId = 'user1';
      expect(messageProvider.getMessagesByUserId(userId).isEmpty, true);
      messageProvider.addSenderMessage(userId, 'Hello');
      expect(messageProvider.getMessagesByUserId(userId).length, 1);
      expect(messageProvider.getMessagesByUserId(userId)[0].text, 'Hello');
    });

    test('ChatHistoryProvider tracks chat sessions', () {
      expect(chatHistoryProvider.chatSessions.isEmpty, true);
      chatHistoryProvider.updateChatSession(
        userId: 'user1',
        userName: 'Alice',
        lastMessage: 'Hi there!',
      );
      expect(chatHistoryProvider.chatSessions.length, 1);
      expect(chatHistoryProvider.chatSessions[0].lastMessage, 'Hi there!');
    });

    test('Multiple users in chat history', () {
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

    test('Complete data flow: User -> Message -> ChatHistory', () {
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

    test('Chat history update with multiple messages', () {
      final userId = 'user456';
      final userName = 'Multi-Message User';

      for (int i = 0; i < 5; i++) {
        messageProvider.addSenderMessage(userId, 'Message $i');
        chatHistoryProvider.updateChatSession(
          userId: userId,
          userName: userName,
          lastMessage: 'Message $i',
        );
      }

      expect(messageProvider.getMessagesByUserId(userId).length, 5);
      expect(chatHistoryProvider.chatSessions.length, 1);
      expect(chatHistoryProvider.chatSessions[0].lastMessage, 'Message 4');
    });

    test('Concurrent user and message operations', () {
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

    test('Provider state updates are consistent', () {
      final users = userProvider.users;
      final userId = users.first.id;
      final userName = users.first.name;

      messageProvider.addSenderMessage(userId, 'Test message');
      chatHistoryProvider.updateChatSession(
        userId: userId,
        userName: userName,
        lastMessage: 'Test message',
      );

      expect(userProvider.getUserById(userId)!.name, userName);
      expect(messageProvider.getMessagesByUserId(userId).length, 1);
      expect(chatHistoryProvider.chatSessions.length, 1);
      expect(chatHistoryProvider.chatSessions[0].userId, userId);
    });
  });

  group('Data Validation Integration Tests', () {
    late MessageProvider messageProvider;

    setUp(() {
      messageProvider = MessageProvider();
    });

    test('Long message handling', () {
      const userId = 'user1';
      final longMessage = 'a' * 1000;
      messageProvider.addSenderMessage(userId, longMessage);
      expect(messageProvider.getMessagesByUserId(userId)[0].text.length, 1000);
    });

    test('Special characters in messages', () {
      const userId = 'user1';
      const specialText = '😀 @#\$%^&*() <html>';
      messageProvider.addSenderMessage(userId, specialText);
      expect(messageProvider.getMessagesByUserId(userId)[0].text, specialText);
    });
  });
}
