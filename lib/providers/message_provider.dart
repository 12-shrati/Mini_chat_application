import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../services/api_service.dart';

class MessageProvider extends ChangeNotifier {
  final Map<String, List<Message>> _messagesByUserId = {};
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Message> getMessagesByUserId(String userId) {
    return List.unmodifiable(_messagesByUserId[userId] ?? []);
  }

  void addSenderMessage(String userId, String text) {
    if (!_messagesByUserId.containsKey(userId)) {
      _messagesByUserId[userId] = [];
    }

    final message = Message(
      id: const Uuid().v4(),
      text: text,
      isSender: true,
      timestamp: DateTime.now(),
    );

    _messagesByUserId[userId]!.add(message);
    notifyListeners();
  }

  Future<void> addReceiverMessage(String userId) async {
    if (!_messagesByUserId.containsKey(userId)) {
      _messagesByUserId[userId] = [];
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final text = await _apiService.fetchRandomMessage();

      final message = Message(
        id: const Uuid().v4(),
        text: text,
        isSender: false,
        timestamp: DateTime.now(),
      );

      _messagesByUserId[userId]!.add(message);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch message: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
