import 'package:intl/intl.dart';

class Message {
  final String id;
  final String text;
  final bool isSender;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.isSender,
    required this.timestamp,
  });

  String get formattedTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }
}
