import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/models/data_models.dart';
import 'package:simple_app/services/storage_service.dart';

void main() {
  group('StorageService', () {
    late StorageService storageService;

    setUp(() {
      storageService = StorageService();
      
      // Setup SharedPreferences mock to return the mock instance
      SharedPreferences.setMockInitialValues({});
    });

    group('saveReadings', () {
      test('should save readings to SharedPreferences as JSON string', () async {
        final readings = [
          UVReading(
            id: '1',
            uvIndex: 5.5,
            timestamp: DateTime(2025, 11, 29, 12, 0),
          ),
          UVReading(
            id: '2',
            uvIndex: 7.2,
            timestamp: DateTime(2025, 11, 29, 13, 0),
          ),
        ];

        await storageService.saveReadings(readings);

        // Verify that readings were saved
        final prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString('uv_readings');
        expect(jsonString, isNotNull);
        expect(jsonString, contains('"id":"1"'));
        expect(jsonString, contains('"uvIndex":5.5'));
      });

      test('should save empty list of readings', () async {
        final readings = <UVReading>[];

        await storageService.saveReadings(readings);

        final prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString('uv_readings');
        expect(jsonString, '[]');
      });

      test('should overwrite existing readings', () async {
        // Save initial readings
        final initialReadings = [
          UVReading(
            id: '1',
            uvIndex: 5.0,
            timestamp: DateTime(2025, 11, 29, 10, 0),
          ),
        ];
        await storageService.saveReadings(initialReadings);

        // Save new readings
        final newReadings = [
          UVReading(
            id: '2',
            uvIndex: 8.0,
            timestamp: DateTime(2025, 11, 29, 14, 0),
          ),
        ];
        await storageService.saveReadings(newReadings);

        // Verify new readings replaced old ones
        final loadedReadings = await storageService.loadReadings();
        expect(loadedReadings.length, 1);
        expect(loadedReadings[0].id, '2');
      });
    });

    group('loadReadings', () {
      test('should load readings from SharedPreferences', () async {
        final readings = [
          UVReading(
            id: 'test-1',
            uvIndex: 6.3,
            timestamp: DateTime(2025, 11, 29, 15, 0),
          ),
        ];

        // Save readings first
        await storageService.saveReadings(readings);

        // Load readings
        final loadedReadings = await storageService.loadReadings();

        expect(loadedReadings.length, 1);
        expect(loadedReadings[0].id, 'test-1');
        expect(loadedReadings[0].uvIndex, 6.3);
        expect(loadedReadings[0].timestamp, DateTime(2025, 11, 29, 15, 0));
      });

      test('should return empty list when no readings are saved', () async {
        final loadedReadings = await storageService.loadReadings();

        expect(loadedReadings, isEmpty);
      });

      test('should return empty list when JSON string is empty', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uv_readings', '');

        final loadedReadings = await storageService.loadReadings();

        expect(loadedReadings, isEmpty);
      });

      test('should handle multiple readings correctly', () async {
        final readings = List.generate(
          5,
          (index) => UVReading(
            id: 'reading-$index',
            uvIndex: index * 2.0,
            timestamp: DateTime(2025, 11, 29, 10 + index, 0),
          ),
        );

        await storageService.saveReadings(readings);
        final loadedReadings = await storageService.loadReadings();

        expect(loadedReadings.length, 5);
        for (int i = 0; i < 5; i++) {
          expect(loadedReadings[i].id, 'reading-$i');
          expect(loadedReadings[i].uvIndex, i * 2.0);
        }
      });

      test('should return empty list on JSON decode error', () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uv_readings', 'invalid json {]');

        final loadedReadings = await storageService.loadReadings();

        expect(loadedReadings, isEmpty);
      });
    });

    group('saveAlertThreshold', () {
      test('should save alert threshold to SharedPreferences', () async {
        await storageService.saveAlertThreshold(8.5);

        final prefs = await SharedPreferences.getInstance();
        final threshold = prefs.getDouble('uv_alert_threshold');
        expect(threshold, 8.5);
      });

      test('should overwrite existing alert threshold', () async {
        await storageService.saveAlertThreshold(6.0);
        await storageService.saveAlertThreshold(9.0);

        final prefs = await SharedPreferences.getInstance();
        final threshold = prefs.getDouble('uv_alert_threshold');
        expect(threshold, 9.0);
      });

      test('should save zero threshold', () async {
        await storageService.saveAlertThreshold(0.0);

        final prefs = await SharedPreferences.getInstance();
        final threshold = prefs.getDouble('uv_alert_threshold');
        expect(threshold, 0.0);
      });
    });

    group('loadAlertThreshold', () {
      test('should load alert threshold from SharedPreferences', () async {
        await storageService.saveAlertThreshold(7.5);

        final threshold = await storageService.loadAlertThreshold();

        expect(threshold, 7.5);
      });

      test('should return default 6.0 when no threshold is saved', () async {
        final threshold = await storageService.loadAlertThreshold();

        expect(threshold, 6.0);
      });

      test('should return saved threshold instead of default', () async {
        await storageService.saveAlertThreshold(10.0);

        final threshold = await storageService.loadAlertThreshold();

        expect(threshold, 10.0);
        expect(threshold, isNot(6.0));
      });
    });

    group('Integration tests', () {
      test('should handle complete save and load cycle', () async {
        // Save readings
        final readings = [
          UVReading(
            id: 'int-1',
            uvIndex: 5.5,
            timestamp: DateTime(2025, 11, 29, 16, 0),
          ),
          UVReading(
            id: 'int-2',
            uvIndex: 8.2,
            timestamp: DateTime(2025, 11, 29, 17, 0),
          ),
        ];
        await storageService.saveReadings(readings);

        // Save threshold
        await storageService.saveAlertThreshold(7.0);

        // Load both
        final loadedReadings = await storageService.loadReadings();
        final loadedThreshold = await storageService.loadAlertThreshold();

        // Verify
        expect(loadedReadings.length, 2);
        expect(loadedReadings[0].id, 'int-1');
        expect(loadedReadings[1].id, 'int-2');
        expect(loadedThreshold, 7.0);
      });
    });
  });
}

