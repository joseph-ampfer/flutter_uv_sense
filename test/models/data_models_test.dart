import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_app/models/data_models.dart';

void main() {
  group('UVReading', () {
    test('should create UVReading with required properties', () {
      final timestamp = DateTime(2025, 11, 29, 12, 0);
      final reading = UVReading(
        id: 'test-123',
        uvIndex: 7.5,
        timestamp: timestamp,
      );

      expect(reading.id, 'test-123');
      expect(reading.uvIndex, 7.5);
      expect(reading.timestamp, timestamp);
    });

    test('should serialize UVReading to JSON correctly', () {
      final timestamp = DateTime(2025, 11, 29, 12, 0);
      final reading = UVReading(
        id: 'test-456',
        uvIndex: 5.2,
        timestamp: timestamp,
      );

      final json = reading.toJson();

      expect(json['id'], 'test-456');
      expect(json['uvIndex'], 5.2);
      expect(json['timestamp'], timestamp.toIso8601String());
    });

    test('should deserialize UVReading from JSON correctly', () {
      final timestamp = DateTime(2025, 11, 29, 12, 0);
      final json = {
        'id': 'test-789',
        'uvIndex': 8.3,
        'timestamp': timestamp.toIso8601String(),
      };

      final reading = UVReading.fromJson(json);

      expect(reading.id, 'test-789');
      expect(reading.uvIndex, 8.3);
      expect(reading.timestamp, timestamp);
    });

    test('should handle integer uvIndex in JSON deserialization', () {
      final timestamp = DateTime(2025, 11, 29, 12, 0);
      final json = {
        'id': 'test-int',
        'uvIndex': 9, // Integer instead of double
        'timestamp': timestamp.toIso8601String(),
      };

      final reading = UVReading.fromJson(json);

      expect(reading.uvIndex, 9.0);
      expect(reading.uvIndex, isA<double>());
    });

    test('should round-trip through JSON serialization', () {
      final timestamp = DateTime(2025, 11, 29, 12, 0);
      final original = UVReading(
        id: 'round-trip',
        uvIndex: 6.7,
        timestamp: timestamp,
      );

      final json = original.toJson();
      final deserialized = UVReading.fromJson(json);

      expect(deserialized.id, original.id);
      expect(deserialized.uvIndex, original.uvIndex);
      expect(deserialized.timestamp, original.timestamp);
    });
  });

  group('Device', () {
    test('should create Device with required properties', () {
      final device = Device(
        id: 'device-001',
        name: 'UV Sensor',
      );

      expect(device.id, 'device-001');
      expect(device.name, 'UV Sensor');
      expect(device.batteryLevel, 0);
      expect(device.isConnected, false);
      expect(device.connectionState, BleConnectionState.disconnected);
      expect(device.signalStrength, null);
    });

    test('should create Device with all properties', () {
      final device = Device(
        id: 'device-002',
        name: 'UV Sensor Pro',
        batteryLevel: 85,
        isConnected: true,
        connectionState: BleConnectionState.connected,
        signalStrength: -45,
      );

      expect(device.id, 'device-002');
      expect(device.name, 'UV Sensor Pro');
      expect(device.batteryLevel, 85);
      expect(device.isConnected, true);
      expect(device.connectionState, BleConnectionState.connected);
      expect(device.signalStrength, -45);
    });

    test('should copy Device with updated properties', () {
      final original = Device(
        id: 'device-003',
        name: 'Original Device',
        batteryLevel: 50,
        isConnected: false,
        connectionState: BleConnectionState.disconnected,
      );

      final copied = original.copyWith(
        batteryLevel: 75,
        isConnected: true,
        connectionState: BleConnectionState.connected,
      );

      expect(copied.id, original.id);
      expect(copied.name, original.name);
      expect(copied.batteryLevel, 75);
      expect(copied.isConnected, true);
      expect(copied.connectionState, BleConnectionState.connected);
    });

    test('should copy Device with no changes when no parameters provided', () {
      final original = Device(
        id: 'device-004',
        name: 'Test Device',
        batteryLevel: 60,
        signalStrength: -50,
      );

      final copied = original.copyWith();

      expect(copied.id, original.id);
      expect(copied.name, original.name);
      expect(copied.batteryLevel, original.batteryLevel);
      expect(copied.isConnected, original.isConnected);
      expect(copied.signalStrength, original.signalStrength);
    });

    test('should update only specified properties in copyWith', () {
      final original = Device(
        id: 'device-005',
        name: 'Test',
        batteryLevel: 100,
        isConnected: true,
        signalStrength: -30,
      );

      final copied = original.copyWith(signalStrength: -60);

      expect(copied.id, original.id);
      expect(copied.batteryLevel, original.batteryLevel);
      expect(copied.isConnected, original.isConnected);
      expect(copied.signalStrength, -60);
    });
  });

  group('BleConnectionState', () {
    test('should have correct enum values', () {
      expect(BleConnectionState.disconnected, isA<BleConnectionState>());
      expect(BleConnectionState.connecting, isA<BleConnectionState>());
      expect(BleConnectionState.connected, isA<BleConnectionState>());
      expect(BleConnectionState.disconnecting, isA<BleConnectionState>());
    });

    test('should be able to compare enum values', () {
      expect(BleConnectionState.connected == BleConnectionState.connected, true);
      expect(BleConnectionState.connected == BleConnectionState.disconnected, false);
    });
  });

  group('SkinType', () {
    test('should create SkinType with all properties', () {
      final skinType = SkinType(
        id: '1',
        name: 'Fair',
        description: 'Burns easily',
        color: Colors.blue,
        burnTime: 10,
      );

      expect(skinType.id, '1');
      expect(skinType.name, 'Fair');
      expect(skinType.description, 'Burns easily');
      expect(skinType.color, Colors.blue);
      expect(skinType.burnTime, 10);
    });
  });

  group('UVRecommendation', () {
    test('should create UVRecommendation with all properties', () {
      final recommendation = UVRecommendation(
        uvIndex: 8.0,
        safeExposure: 15,
        protection: ['Use sunscreen', 'Wear hat'],
      );

      expect(recommendation.uvIndex, 8.0);
      expect(recommendation.safeExposure, 15);
      expect(recommendation.protection.length, 2);
      expect(recommendation.protection[0], 'Use sunscreen');
    });
  });

  group('UVLevel', () {
    test('should create UVLevel with level and color', () {
      final uvLevel = UVLevel('High', Colors.orange);

      expect(uvLevel.level, 'High');
      expect(uvLevel.color, Colors.orange);
    });
  });

  group('QuizOption', () {
    test('should create QuizOption with text and value', () {
      final option = QuizOption(
        text: 'Light blue eyes',
        value: 0,
      );

      expect(option.text, 'Light blue eyes');
      expect(option.value, 0);
    });
  });

  group('QuizQuestion', () {
    test('should create QuizQuestion with all properties', () {
      final question = QuizQuestion(
        id: 1,
        question: 'What color are your eyes?',
        description: 'Select the closest match',
        options: [
          QuizOption(text: 'Blue', value: 0),
          QuizOption(text: 'Brown', value: 1),
        ],
      );

      expect(question.id, 1);
      expect(question.question, 'What color are your eyes?');
      expect(question.description, 'Select the closest match');
      expect(question.options.length, 2);
    });

    test('should create QuizQuestion without optional description', () {
      final question = QuizQuestion(
        id: 2,
        question: 'What is your skin type?',
        options: [
          QuizOption(text: 'Fair', value: 0),
        ],
      );

      expect(question.id, 2);
      expect(question.description, null);
      expect(question.options.length, 1);
    });
  });
}

