import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat/models/user.dart';

void main() {
  group('User Model', () {
    test('User creation with valid data', () {
      final user = User(id: '1', name: 'John Doe');
      expect(user.id, '1');
      expect(user.name, 'John Doe');
    });

    test('User initials returns first letter of each word', () {
      final user = User(id: '1', name: 'John Doe');
      expect(user.initials, 'JD');
    });

    test('User initials with single name', () {
      final user = User(id: '1', name: 'Alice');
      expect(user.initials, 'A');
    });

    test('User initials with multiple words', () {
      final user = User(id: '1', name: 'Mary Jane Watson');
      expect(user.initials, 'MJW');
    });

    test('User initials with empty name', () {
      final user = User(id: '1', name: '');
      expect(user.initials, '');
    });
  });
}
