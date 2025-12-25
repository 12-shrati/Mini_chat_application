import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat/services/api_service.dart';

void main() {
  group('ApiService', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    test('ApiService is instantiable', () {
      expect(apiService, isNotNull);
    });

    test('getWordDefinition returns Future<String>', () async {
      expect(
        apiService.getWordDefinition('test'),
        isA<Future<String>>(),
      );
    });

    test('fetchRandomMessage returns Future<String>', () async {
      expect(
        apiService.fetchRandomMessage(),
        isA<Future<String>>(),
      );
    });
  });
}
