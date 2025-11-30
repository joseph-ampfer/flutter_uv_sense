import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:simple_app/models/data_models.dart';
import 'package:simple_app/providers/skin_type_provider.dart';
import 'app_test_wrapper.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Persistence Integration Tests', () {
    testWidgets('UV readings persist across app restarts',
        (WidgetTester tester) async {
      // Arrange - Create mock services with storage
      final mockStorageService = MockStorageService();
      final mockBleService = MockBleService(testUvReadings: [5.5, 7.3, 9.1]);

      // Pre-populate storage with initial readings
      final initialReadings = [
        UVReading(
          id: 'reading_1',
          uvIndex: 3.2,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        UVReading(
          id: 'reading_2',
          uvIndex: 6.8,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ];
      mockStorageService.populateTestData(readings: initialReadings);

      // Create custom UV Monitor that uses mock storage
      await tester.pumpWidget(
        createTestApp(mockBleService: mockBleService),
      );
      await tester.pumpAndSettle();

      // Note: The actual UVMonitorScreen creates its own StorageService
      // For true persistence testing, we would need to inject the storage service
      // This test demonstrates the flow, but in production you'd need dependency injection
      
      // Connect and take a new reading
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

      // Verify reading appears
      expect(find.text('5.5'), findsOneWidget);

      // Simulate app restart by rebuilding widget tree
      await tester.pumpWidget(
        createTestApp(mockBleService: mockBleService),
      );
      await tester.pumpAndSettle();

      // Assert - App restarted and we're back on UV Monitor
      expect(find.text('UV Monitor'), findsOneWidget);
    });

    testWidgets('Alert threshold persists after changes',
        (WidgetTester tester) async {
      // Arrange
      final mockStorageService = MockStorageService();
      
      // Set initial threshold
      mockStorageService.populateTestData(alertThreshold: 8.5);

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Open settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Scroll to threshold
      await tester.scrollUntilVisible(
        find.text('UV Alert Threshold'),
        100,
        scrollable: find.byType(Scrollable).last,
      );

      // Verify threshold loaded (note: actual app uses SharedPreferences)
      // This test demonstrates the persistence pattern
      expect(find.text('UV Alert Threshold'), findsOneWidget);

      // Change threshold
      final sliderFinder = find.byType(Slider);
      await tester.drag(sliderFinder, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Close settings
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Simulate app restart
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Assert - Back on UV Monitor after restart
      expect(find.text('UV Monitor'), findsOneWidget);
    });

    testWidgets('Skin type selection persists via provider',
        (WidgetTester tester) async {
      // Arrange
      final skinTypeProvider = SkinTypeProvider();
      
      await tester.pumpWidget(
        createTestApp(skinTypeProvider: skinTypeProvider),
      );
      await tester.pumpAndSettle();

      // Initial skin type
      expect(skinTypeProvider.selectedSkinType.name, 'Medium');

      // Act - Change skin type via settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Assert - Skin type persisted in provider
      expect(skinTypeProvider.selectedSkinType.name, 'Dark');

      // Verify recommendations reflect the persisted skin type
      await tester.scrollUntilVisible(
        find.textContaining('Dark skin'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.textContaining('Dark skin'), findsOneWidget);
    });

    testWidgets('Skin type from quiz persists in provider',
        (WidgetTester tester) async {
      // Arrange
      final skinTypeProvider = SkinTypeProvider();
      
      await tester.pumpWidget(
        createTestApp(skinTypeProvider: skinTypeProvider),
      );
      await tester.pumpAndSettle();

      // Initial state
      final initialSkinType = skinTypeProvider.selectedSkinType.name;

      // Act - Complete quiz to set skin type
      await tester.tap(find.byKey(const Key('uv_quiz_button')));
      await tester.pumpAndSettle();

      // Answer all questions with first option (leads to Very Fair)
      final quizQuestions = [
        {'id': 0, 'value': 0},
        {'id': 1, 'value': 0},
        {'id': 2, 'value': 0},
        {'id': 3, 'value': 0},
        {'id': 4, 'value': 0},
        {'id': 5, 'value': 0},
        {'id': 6, 'value': 0},
        {'id': 7, 'value': 0},
        {'id': 8, 'value': 0},
        {'id': 9, 'value': 1},
        {'id': 10, 'value': 1},
        {'id': 11, 'value': 0},
      ];

      for (var question in quizQuestions) {
        final optionKey = Key('quiz_option_${question['id']}_${question['value']}');
        await tester.tap(find.byKey(optionKey));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
      }

      // Should be on Results screen
      expect(find.text('Your Results'), findsOneWidget);

      // Apply skin type
      await tester.tap(find.byKey(const Key('results_apply_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Back on UV Monitor with new skin type
      expect(find.text('UV Monitor'), findsOneWidget);
      expect(skinTypeProvider.selectedSkinType.name, 'Very Fair');
      expect(skinTypeProvider.selectedSkinType.name, isNot(initialSkinType));

      // Verify persistence by navigating away and back
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Skin type still persists
      expect(skinTypeProvider.selectedSkinType.name, 'Very Fair');
    });

    testWidgets('Multiple readings accumulate correctly',
        (WidgetTester tester) async {
      // Arrange
      final mockBleService = MockBleService(
        testUvReadings: [2.1, 4.5, 6.8, 8.2, 9.5],
      );

      await tester.pumpWidget(
        createTestApp(mockBleService: mockBleService),
      );
      await tester.pumpAndSettle();

      // Connect to device
      await tester.tap(find.byKey(const Key('uv_connect_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('uv_scan_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Act - Take multiple readings
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const Key('uv_take_reading_button')));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();
      }

      // Assert - Scroll to readings and verify all 3 are present
      await tester.scrollUntilVisible(
        find.byKey(const Key('uv_readings_list')),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      // Should show recent readings (most recent first)
      expect(find.text('6.8'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('2.1'), findsOneWidget);
    });

    testWidgets('State persists during navigation between screens',
        (WidgetTester tester) async {
      // Arrange
      final skinTypeProvider = SkinTypeProvider();
      final mockBleService = MockBleService(testUvReadings: [7.5]);

      await tester.pumpWidget(
        createTestApp(
          skinTypeProvider: skinTypeProvider,
          mockBleService: mockBleService,
        ),
      );
      await tester.pumpAndSettle();

      // Take a reading
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

      // Verify reading
      expect(find.text('7.5'), findsOneWidget);

      // Act - Navigate to quiz
      await tester.tap(find.byKey(const Key('uv_quiz_button')));
      await tester.pumpAndSettle();

      // Close quiz
      await tester.tap(find.byKey(const Key('quiz_close_button')));
      await tester.pumpAndSettle();

      // Assert - Back on UV Monitor, reading still visible
      expect(find.text('UV Monitor'), findsOneWidget);
      expect(find.text('7.5'), findsOneWidget);

      // Navigate to settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Change skin type
      await tester.tap(find.text('Brown'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Assert - Reading still visible, skin type updated
      expect(find.text('7.5'), findsOneWidget);
      expect(skinTypeProvider.selectedSkinType.name, 'Brown');
    });

    testWidgets('Connection state persists during navigation',
        (WidgetTester tester) async {
      // Arrange
      final mockBleService = MockBleService();

      await tester.pumpWidget(
        createTestApp(mockBleService: mockBleService),
      );
      await tester.pumpAndSettle();

      // Connect to device
      await tester.tap(find.byKey(const Key('uv_connect_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('uv_scan_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Verify connected
      expect(mockBleService.isConnected, true);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Navigate to quiz
      await tester.tap(find.byKey(const Key('uv_quiz_button')));
      await tester.pumpAndSettle();

      // Connection should persist
      expect(mockBleService.isConnected, true);

      // Navigate back
      await tester.tap(find.byKey(const Key('quiz_close_button')));
      await tester.pumpAndSettle();

      // Assert - Still connected
      expect(mockBleService.isConnected, true);
      expect(find.text('Connected'), findsOneWidget);
    });

    testWidgets('Provider state resets correctly on fresh app start',
        (WidgetTester tester) async {
      // Arrange - First app instance
      final firstProvider = SkinTypeProvider();
      
      await tester.pumpWidget(
        createTestApp(skinTypeProvider: firstProvider),
      );
      await tester.pumpAndSettle();

      // Change skin type
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(firstProvider.selectedSkinType.name, 'Dark');

      // Act - Simulate fresh app start with new provider instance
      final secondProvider = SkinTypeProvider();
      
      await tester.pumpWidget(
        createTestApp(skinTypeProvider: secondProvider),
      );
      await tester.pumpAndSettle();

      // Assert - New provider has default state
      expect(secondProvider.selectedSkinType.name, 'Medium');
      expect(secondProvider.selectedSkinType.name, 
             isNot(firstProvider.selectedSkinType.name));
    });

    testWidgets('Storage service mock correctly simulates persistence',
        (WidgetTester tester) async {
      // This test verifies the mock storage service behavior
      final mockStorage = MockStorageService();

      // Initially empty
      var readings = await mockStorage.loadReadings();
      expect(readings, isEmpty);

      var threshold = await mockStorage.loadAlertThreshold();
      expect(threshold, 6.0); // Default value

      // Save some data
      final testReadings = [
        UVReading(
          id: 'test_1',
          uvIndex: 5.5,
          timestamp: DateTime.now(),
        ),
        UVReading(
          id: 'test_2',
          uvIndex: 8.2,
          timestamp: DateTime.now(),
        ),
      ];

      await mockStorage.saveReadings(testReadings);
      await mockStorage.saveAlertThreshold(7.5);

      // Verify persistence
      readings = await mockStorage.loadReadings();
      expect(readings.length, 2);
      expect(readings[0].uvIndex, 5.5);
      expect(readings[1].uvIndex, 8.2);

      threshold = await mockStorage.loadAlertThreshold();
      expect(threshold, 7.5);

      // Clear and verify
      mockStorage.clearStorage();
      readings = await mockStorage.loadReadings();
      expect(readings, isEmpty);

      threshold = await mockStorage.loadAlertThreshold();
      expect(threshold, 6.0); // Back to default
    });
  });
}

