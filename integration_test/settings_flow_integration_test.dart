import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:simple_app/data/mock_data.dart';
import 'package:simple_app/providers/skin_type_provider.dart';
import 'app_test_wrapper.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Settings Flow Integration Tests', () {
    testWidgets('Open settings modal and change skin type',
        (WidgetTester tester) async {
      // Arrange
      final skinTypeProvider = SkinTypeProvider();
      await tester.pumpWidget(
        createTestApp(skinTypeProvider: skinTypeProvider),
      );
      await tester.pumpAndSettle();

      // Verify initial skin type (default is Medium)
      expect(skinTypeProvider.selectedSkinType.name, 'Medium');

      // Act - Open settings modal
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Assert - Settings modal is open
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Skin Type'), findsOneWidget);

      // Verify all skin types are listed
      for (var skinType in skinTypes) {
        expect(find.text(skinType.name), findsOneWidget);
      }

      // Act - Select "Fair" skin type
      await tester.tap(find.text('Fair'));
      await tester.pumpAndSettle();

      // Assert - Skin type updated
      expect(skinTypeProvider.selectedSkinType.name, 'Fair');
      expect(skinTypeProvider.selectedSkinType.id, '2');

      // Close modal
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Verify still on UV Monitor and skin type persists
      expect(find.text('UV Monitor'), findsOneWidget);
      expect(skinTypeProvider.selectedSkinType.name, 'Fair');
    });

    testWidgets('Adjust UV alert threshold with slider',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Open settings modal
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Assert - Default threshold is 6.0
      expect(find.text('UV Alert Threshold'), findsOneWidget);
      expect(find.textContaining('Alert when UV index exceeds 6.0'),
          findsOneWidget);

      // Act - Scroll to slider to ensure it's visible
      final sliderFinder = find.byType(Slider);
      expect(sliderFinder, findsOneWidget);
      
      await tester.ensureVisible(sliderFinder);
      await tester.pumpAndSettle();

      // Get the slider widget
      final Slider sliderWidget = tester.widget(sliderFinder);
      expect(sliderWidget.value, 6.0);

      // Drag slider to change value
      await tester.drag(sliderFinder, const Offset(100, 0), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Assert - Threshold changed (exact value depends on drag, but should be > 6.0)
      final Slider updatedSlider = tester.widget(sliderFinder);
      expect(updatedSlider.value, greaterThan(6.0));
    });

    testWidgets('Recommendations update based on selected skin type',
        (WidgetTester tester) async {
      // Arrange
      final skinTypeProvider = SkinTypeProvider();
      final mockBleService = MockBleService(testUvReadings: [8.5]);
      
      await tester.pumpWidget(
        createTestApp(
          skinTypeProvider: skinTypeProvider,
          mockBleService: mockBleService,
        ),
      );
      await tester.pumpAndSettle();

      // Connect to device and take a reading
      await tester.tap(find.byKey(const Key('uv_connect_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('uv_scan_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('uv_take_reading_button')));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Scroll to recommendations
      await tester.scrollUntilVisible(
        find.text('Protection Recommendations'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      // Get initial safe exposure time (Medium skin = 15 burn time)
      expect(find.textContaining('Safe exposure:'), findsOneWidget);
      expect(find.textContaining('Medium skin'), findsOneWidget);

      // Act - Change skin type to Very Fair
      await tester.scrollUntilVisible(
        find.byIcon(Icons.settings),
        -100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Very Fair'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Scroll to recommendations again
      await tester.scrollUntilVisible(
        find.text('Protection Recommendations'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      // Assert - Recommendations updated to reflect Very Fair skin
      expect(find.textContaining('Very Fair skin'), findsOneWidget);
      // Very Fair has burn time of 5, which is 1/4 of Medium's 15
      // So safe exposure should be lower
    });

    testWidgets('Skin type selection is visually highlighted',
        (WidgetTester tester) async {
      // Arrange
      final skinTypeProvider = SkinTypeProvider();
      await tester.pumpWidget(
        createTestApp(skinTypeProvider: skinTypeProvider),
      );
      await tester.pumpAndSettle();

      // Open settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Default is Medium skin type - find its ListTile
      final mediumTile = find.ancestor(
        of: find.text('Medium'),
        matching: find.byType(Card),
      );
      expect(mediumTile, findsOneWidget);

      // Check if Medium tile has highlight color
      final Card mediumCard = tester.widget(mediumTile.first);
      expect(mediumCard.color, isNotNull);

      // Act - Select a different skin type
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      // Assert - Dark skin type should now be highlighted
      final darkTile = find.ancestor(
        of: find.text('Dark'),
        matching: find.byType(Card),
      );
      expect(darkTile, findsOneWidget);

      final Card darkCard = tester.widget(darkTile.first);
      expect(darkCard.color, isNotNull);
    });

    testWidgets('Multiple skin type changes persist correctly',
        (WidgetTester tester) async {
      // Arrange
      final skinTypeProvider = SkinTypeProvider();
      await tester.pumpWidget(
        createTestApp(skinTypeProvider: skinTypeProvider),
      );
      await tester.pumpAndSettle();

      // Initial state
      expect(skinTypeProvider.selectedSkinType.name, 'Medium');

      // Act - Change skin type multiple times
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Change to Very Fair
      await tester.tap(find.text('Very Fair'));
      await tester.pumpAndSettle();
      expect(skinTypeProvider.selectedSkinType.name, 'Very Fair');

      // Change to Brown
      await tester.tap(find.text('Brown'));
      await tester.pumpAndSettle();
      expect(skinTypeProvider.selectedSkinType.name, 'Brown');

      // Change to Olive
      await tester.tap(find.text('Olive'));
      await tester.pumpAndSettle();
      expect(skinTypeProvider.selectedSkinType.name, 'Olive');

      // Close and verify final state
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(skinTypeProvider.selectedSkinType.name, 'Olive');
    });

    testWidgets('Settings modal can be closed without making changes',
        (WidgetTester tester) async {
      // Arrange
      final skinTypeProvider = SkinTypeProvider();
      await tester.pumpWidget(
        createTestApp(skinTypeProvider: skinTypeProvider),
      );
      await tester.pumpAndSettle();

      final initialSkinType = skinTypeProvider.selectedSkinType.name;

      // Act - Open and close settings without changes
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Assert - No changes were made
      expect(skinTypeProvider.selectedSkinType.name, initialSkinType);
      expect(find.text('UV Monitor'), findsOneWidget);
    });

    testWidgets('UV alert threshold range is correct (0-11)',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Open settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Scroll to threshold section
      await tester.scrollUntilVisible(
        find.text('UV Alert Threshold'),
        100,
        scrollable: find.byType(Scrollable).last,
      );

      // Assert - Min and max labels are visible
      expect(find.text('0.0 (Low)'), findsOneWidget);
      expect(find.text('11.0 (Extreme)'), findsOneWidget);

      // Verify slider properties
      final Slider slider = tester.widget(find.byType(Slider));
      expect(slider.min, 0.0);
      expect(slider.max, 11.0);
      expect(slider.divisions, 22);
    });

    testWidgets('Skin type changes reflect in recommendations immediately',
        (WidgetTester tester) async {
      // Arrange
      final skinTypeProvider = SkinTypeProvider();
      final mockBleService = MockBleService(testUvReadings: [6.5]);
      
      await tester.pumpWidget(
        createTestApp(
          skinTypeProvider: skinTypeProvider,
          mockBleService: mockBleService,
        ),
      );
      await tester.pumpAndSettle();

      // Set up a UV reading first
      await tester.tap(find.byKey(const Key('uv_connect_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('uv_scan_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('uv_take_reading_button')));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Store initial safe exposure time
      await tester.scrollUntilVisible(
        find.textContaining('Safe exposure:'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      // Get text with Medium skin
      final mediumText = find.textContaining('Medium skin');
      expect(mediumText, findsOneWidget);

      // Change skin type
      await tester.scrollUntilVisible(
        find.byIcon(Icons.settings),
        -100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Verify recommendations updated
      await tester.scrollUntilVisible(
        find.textContaining('Safe exposure:'),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.textContaining('Dark skin'), findsOneWidget);
      expect(find.textContaining('Medium skin'), findsNothing);
    });
  });
}

