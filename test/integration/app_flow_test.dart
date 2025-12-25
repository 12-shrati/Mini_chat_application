import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_chat/main.dart';
import 'package:mini_chat/screens/home_screen.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('App initializes with MaterialApp',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('Bottom navigation bar is present with correct items',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Can navigate between bottom navigation tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Tap on second tab (Offers)
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
      expect(find.text('Offers Screen'), findsOneWidget);

      // Tap on third tab (Settings)
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.text('Settings Screen'), findsOneWidget);

      // Tap on first tab (Home)
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('App theme is applied correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final materialApp =
          find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
      expect(materialApp.theme, isNotNull);
      expect(materialApp.theme!.useMaterial3, true);
    });
  });
}
