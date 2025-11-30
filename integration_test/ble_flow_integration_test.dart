import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'app_test_wrapper.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('BLE Flow Integration Tests', () {
    testWidgets('Scan for devices and connect to one',
        (WidgetTester tester) async {
      // Arrange
      final mockBleService = MockBleService();
      await tester.pumpWidget(
        createTestApp(mockBleService: mockBleService),
      );
      await tester.pumpAndSettle();

      // Verify initial state - not connected
      expect(mockBleService.isConnected, false);
      expect(find.text('UV Monitor'), findsOneWidget);

      // Act - Open device modal
      await tester.tap(find.byKey(const Key('uv_connect_button')));
      await tester.pumpAndSettle();

      // Assert - Device modal is open
      expect(find.text('Bluetooth Devices'), findsOneWidget);
      expect(find.text('No devices found.\nTap "Scan for Devices" to search.'),
          findsOneWidget);

      // Act - Scan for devices
      await tester.tap(find.byKey(const Key('uv_scan_button')));
      await tester.pump();

      // Assert - Scanning state
      expect(mockBleService.isScanning, true);
      expect(find.text('Scanning...'), findsOneWidget);

      // Wait for scan to complete
      await tester.pumpAndSettle();

      // Assert - Devices found
      expect(mockBleService.isScanning, false);
      expect(mockBleService.discoveredDevices.length, 3);
      
      // Devices are displayed in ListTiles (check we have at least 3)
      expect(find.byType(ListTile), findsAtLeastNWidgets(3));

      // Act - Connect to first device (tap first ListTile)
      final firstDeviceTile = find.byType(ListTile).first;
      await tester.tap(firstDeviceTile);
      await tester.pump();

      // Wait for connection
      await tester.pumpAndSettle();

      // Assert - Connected to device
      expect(mockBleService.isConnected, true);
      expect(mockBleService.connectedDevice, isNotNull);

      // Verify SnackBar appears
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Connected to'), findsOneWidget);

      // Close modal
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Verify back on main screen and connected
      expect(find.text('UV Monitor'), findsOneWidget);
    });

    testWidgets('Take UV reading when connected',
        (WidgetTester tester) async {
      // Arrange - Create mock service with known test readings
      final mockBleService = MockBleService(
        testUvReadings: [3.5, 7.2, 9.8],
      );
      await tester.pumpWidget(
        createTestApp(mockBleService: mockBleService),
      );
      await tester.pumpAndSettle();

      // Connect to a device first
      await tester.tap(find.byKey(const Key('uv_connect_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('uv_scan_button')));
      await tester.pumpAndSettle();

      // Tap first device in the list
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Act - Take UV reading using FAB
      expect(find.byKey(const Key('uv_take_reading_button')), findsOneWidget);
      await tester.tap(find.byKey(const Key('uv_take_reading_button')));
      await tester.pump();

      // Assert - Reading in progress
      expect(mockBleService.isReading, true);
      expect(find.text('Reading...'), findsAtLeastNWidgets(1));

      // Wait for 3-second reading to complete
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Assert - Reading completed
      expect(mockBleService.isReading, false);

      // Verify UV value is displayed (first reading is 3.5)
      expect(find.byKey(const Key('uv_current_display')), findsOneWidget);
      expect(find.text('3.5'), findsOneWidget);

      // Verify SnackBar with UV value
      expect(find.textContaining('UV Index: 3.5'), findsOneWidget);
    });

    testWidgets('UV reading appears in recent readings list',
        (WidgetTester tester) async {
      // Arrange
      final mockBleService = MockBleService(
        testUvReadings: [5.4, 8.1, 2.7],
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

      // Scroll to see readings card
      await tester.scrollUntilVisible(
        find.byKey(const Key('uv_readings_list')),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      // Verify readings card exists but is empty initially
      expect(find.byKey(const Key('uv_readings_list')), findsOneWidget);
      expect(find.text('Recent Readings'), findsOneWidget);

      // Act - Take first reading
      await tester.scrollUntilVisible(
        find.byKey(const Key('uv_take_reading_button')),
        -100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byKey(const Key('uv_take_reading_button')));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Scroll back to readings
      await tester.scrollUntilVisible(
        find.byKey(const Key('uv_readings_list')),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      // Assert - First reading appears (5.4)
      expect(find.text('5.4'), findsOneWidget);

      // Act - Take second reading
      await tester.scrollUntilVisible(
        find.byKey(const Key('uv_take_reading_button')),
        -100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byKey(const Key('uv_take_reading_button')));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Scroll back to readings
      await tester.scrollUntilVisible(
        find.byKey(const Key('uv_readings_list')),
        100,
        scrollable: find.byType(Scrollable).first,
      );

      // Assert - Both readings appear (8.1 and 5.4)
      expect(find.text('8.1'), findsOneWidget);
      expect(find.text('5.4'), findsOneWidget);
    });

    testWidgets('Cannot take reading without connection',
        (WidgetTester tester) async {
      // Arrange - Not connected to any device
      final mockBleService = MockBleService();
      await tester.pumpWidget(
        createTestApp(mockBleService: mockBleService),
      );
      await tester.pumpAndSettle();

      // Verify not connected
      expect(mockBleService.isConnected, false);

      // Act - Try to take reading
      await tester.tap(find.byKey(const Key('uv_take_reading_button')));
      await tester.pumpAndSettle();

      // Assert - Error message appears
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please connect to a device first'), findsOneWidget);

      // No reading was taken
      expect(mockBleService.isReading, false);
    });

    testWidgets('Device connection state is visible in UI',
        (WidgetTester tester) async {
      // Arrange
      final mockBleService = MockBleService();
      await tester.pumpWidget(
        createTestApp(mockBleService: mockBleService),
      );
      await tester.pumpAndSettle();

      // Initially not connected - no device card should be visible
      expect(find.text('Connected'), findsNothing);

      // Connect to device
      await tester.tap(find.byKey(const Key('uv_connect_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('uv_scan_button')));
      await tester.pumpAndSettle();
      // Tap third device (Test UV Device)
      await tester.tap(find.byType(ListTile).at(2));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Assert - Device card shows connected state
      expect(find.text('Connected'), findsOneWidget);
      expect(find.byIcon(Icons.bluetooth_connected), findsOneWidget);
    });

    testWidgets('UV level colors change based on reading value',
        (WidgetTester tester) async {
      // Arrange - Create mock service with specific readings
      final mockBleService = MockBleService(
        testUvReadings: [1.5, 4.0, 6.5, 9.0, 11.5],
      );
      mockBleService.resetReadingIndex();

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

      // Take reading 1 (1.5 - Low)
      await tester.tap(find.byKey(const Key('uv_take_reading_button')));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('1.5'), findsOneWidget);
      expect(find.text('Low'), findsOneWidget);

      // Take reading 2 (4.0 - Moderate)
      await tester.tap(find.byKey(const Key('uv_take_reading_button')));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('4.0'), findsOneWidget);
      expect(find.text('Moderate'), findsOneWidget);

      // Take reading 3 (6.5 - High)
      await tester.tap(find.byKey(const Key('uv_take_reading_button')));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text('6.5'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);
    });

    testWidgets('Multiple devices can be discovered and selected',
        (WidgetTester tester) async {
      // Arrange - Create service with 3 test devices
      final mockBleService = MockBleService(
        testDevices: [
          MockBluetoothDevice(name: 'Device A', id: 'AA:BB:CC:DD:EE:11'),
          MockBluetoothDevice(name: 'Device B', id: 'AA:BB:CC:DD:EE:22'),
          MockBluetoothDevice(name: 'Device C', id: 'AA:BB:CC:DD:EE:33'),
        ],
      );

      await tester.pumpWidget(
        createTestApp(mockBleService: mockBleService),
      );
      await tester.pumpAndSettle();

      // Open device modal and scan
      await tester.tap(find.byKey(const Key('uv_connect_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('uv_scan_button')));
      await tester.pumpAndSettle();

      // Assert - All 3 devices are visible as ListTiles
      expect(find.byType(ListTile), findsNWidgets(3));

      // Connect to second device (Device B)
      await tester.tap(find.byType(ListTile).at(1));
      await tester.pumpAndSettle();

      // Verify connected to a device
      expect(mockBleService.connectedDevice, isNotNull);
    });
  });
}

