import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final List<User> _users = [
    User(id: '1', name: 'Alice Johnson'),
    User(id: '2', name: 'Bob Smith'),
    User(id: '3', name: 'Carol Williams'),
    User(id: '4', name: 'David Brown'),
    User(id: '5', name: 'Emma Davis'),
    User(id: '6', name: 'Frank Miller'),
    User(id: '7', name: 'Grace Wilson'),
    User(id: '8', name: 'Henry Moore'),
  ];

  List<User> get users => List.unmodifiable(_users);

  void addUser(String name) {
    if (name.trim().isEmpty) return;

    final newUser = User(
      id: const Uuid().v4(),
      name: name.trim(),
    );

    _users.add(newUser);
    notifyListeners();
  }

  User? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }
}
