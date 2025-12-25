import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat/providers/user_provider.dart';

void main() {
  group('UserProvider', () {
    late UserProvider userProvider;

    setUp(() {
      userProvider = UserProvider();
    });

    test('Initial users list contains default users', () {
      expect(userProvider.users.isNotEmpty, true);
      expect(userProvider.users.length, 8);
    });

    test('getUserById returns correct user', () {
      final user = userProvider.getUserById('1');
      expect(user, isNotNull);
      expect(user?.name, 'Alice Johnson');
    });

    test('getUserById returns null for invalid id', () {
      final user = userProvider.getUserById('invalid-id');
      expect(user, isNull);
    });

    test('addUser adds new user to list', () {
      final initialLength = userProvider.users.length;
      userProvider.addUser('New User');
      expect(userProvider.users.length, initialLength + 1);
    });

    test('addUser with valid name creates user', () {
      userProvider.addUser('Test User');
      final lastUser = userProvider.users.last;
      expect(lastUser.name, 'Test User');
    });

    test('addUser does not add empty names', () {
      final initialLength = userProvider.users.length;
      userProvider.addUser('');
      userProvider.addUser('   ');
      expect(userProvider.users.length, initialLength);
    });

    test('addUser notifies listeners', () {
      var listenerCalled = false;
      userProvider.addListener(() {
        listenerCalled = true;
      });

      userProvider.addUser('Test User');
      expect(listenerCalled, true);
    });
  });
}
