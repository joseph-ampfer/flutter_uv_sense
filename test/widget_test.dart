// Basic widget smoke test for the UV Monitor App

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_app/main.dart';

void main() {
  testWidgets('App smoke test - should build without errors', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Verify the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App should have providers configured', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify the app initializes
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App should use Material3 theme', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Get the MaterialApp widget
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    // Verify Material3 is enabled
    expect(materialApp.theme?.useMaterial3, true);
  });

  testWidgets('App should have correct title', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Get the MaterialApp widget
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    // Verify the title
    expect(materialApp.title, 'Simple App');
  });

  testWidgets('App should have routes configured', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Get the MaterialApp widget
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    // Verify routes are configured
    expect(materialApp.routes, isNotNull);
    expect(materialApp.routes!.containsKey('/quiz'), true);
    expect(materialApp.routes!.containsKey('/results'), true);
  });

  testWidgets('App should navigate to main screen', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify we're on the main navigation page
    expect(find.byType(MainNavigationPage), findsOneWidget);
  });
}
