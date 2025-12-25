// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_chat/main.dart';

void main() {
  testWidgets('Mini Chat app loads Home Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app has MaterialApp with proper title
    expect(find.byType(MaterialApp), findsOneWidget);

    // Give the app time to navigate to home screen
    await tester.pumpAndSettle();

    // The home screen should be loaded
    expect(find.byType(Scaffold), findsWidgets);
  });
}
