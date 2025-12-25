import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mini_chat/main.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('App initializes with providers and bottom navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(MultiProvider), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
