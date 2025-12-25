import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat/models/message.dart';

void main() {
  group('Message Model', () {
    test('Message creation with valid data', () {
      final now = DateTime.now();
      final message = Message(
        id: '1',
        text: 'Hello',
        isSender: true,
        timestamp: now,
      );

      expect(message.id, '1');
      expect(message.text, 'Hello');
      expect(message.isSender, true);
      expect(message.timestamp, now);
    });

    test('Message isSender property correctly identifies sender vs receiver',
        () {
      final senderMsg = Message(
        id: '1',
        text: 'Hello',
        isSender: true,
        timestamp: DateTime.now(),
      );

      final receiverMsg = Message(
        id: '2',
        text: 'Hi',
        isSender: false,
        timestamp: DateTime.now(),
      );

      expect(senderMsg.isSender, true);
      expect(receiverMsg.isSender, false);
    });

    test('Message formattedTime returns non-empty string', () {
      final message = Message(
        id: '1',
        text: 'Hello',
        isSender: true,
        timestamp: DateTime.now(),
      );

      expect(message.formattedTime.isNotEmpty, true);
    });
  });
}
