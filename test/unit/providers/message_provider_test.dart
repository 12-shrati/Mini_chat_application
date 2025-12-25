import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat/providers/message_provider.dart';

void main() {
  group('MessageProvider', () {
    late MessageProvider messageProvider;

    setUp(() {
      messageProvider = MessageProvider();
    });

    test('Initial state has no messages', () {
      final messages = messageProvider.getMessagesByUserId('user1');
      expect(messages.isEmpty, true);
    });

    test('addSenderMessage adds message to correct user', () {
      messageProvider.addSenderMessage('user1', 'Hello');
      final messages = messageProvider.getMessagesByUserId('user1');
      expect(messages.length, 1);
      expect(messages[0].text, 'Hello');
      expect(messages[0].isSender, true);
    });

    test('addSenderMessage notifies listeners', () {
      var listenerCalled = false;
      messageProvider.addListener(() {
        listenerCalled = true;
      });

      messageProvider.addSenderMessage('user1', 'Test');
      expect(listenerCalled, true);
    });

    test('Messages for different users are separate', () {
      messageProvider.addSenderMessage('user1', 'Message for user1');
      messageProvider.addSenderMessage('user2', 'Message for user2');

      final user1Messages = messageProvider.getMessagesByUserId('user1');
      final user2Messages = messageProvider.getMessagesByUserId('user2');

      expect(user1Messages.length, 1);
      expect(user2Messages.length, 1);
    });

    test('clearMessages removes all messages for user', () {
      messageProvider.addSenderMessage('user1', 'Message 1');
      messageProvider.addSenderMessage('user1', 'Message 2');
      expect(messageProvider.getMessagesByUserId('user1').length, 2);

      messageProvider.clearMessages('user1');
      expect(messageProvider.getMessagesByUserId('user1').length, 0);
    });

    test('clearMessages does not affect other users', () {
      messageProvider.addSenderMessage('user1', 'Message 1');
      messageProvider.addSenderMessage('user2', 'Message 2');

      messageProvider.clearMessages('user1');

      expect(messageProvider.getMessagesByUserId('user1').length, 0);
      expect(messageProvider.getMessagesByUserId('user2').length, 1);
    });
  });
}
