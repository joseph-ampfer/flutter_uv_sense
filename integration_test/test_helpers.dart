import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:simple_app/models/data_models.dart';
import 'package:simple_app/services/ble_service.dart';
import 'package:simple_app/services/storage_service.dart';

/// Mock BLE Service for integration testing
class MockBleService extends BleService {
  final List<MockBluetoothDevice> _testDevices;
  final List<double> _testUvReadings;
  bool _mockIsConnected = false;
  bool _mockIsScanning = false;
  bool _mockIsReading = false;
  MockBluetoothDevice? _mockConnectedDevice;
  int _readingIndex = 0;

  MockBleService({
    List<MockBluetoothDevice>? testDevices,
    List<double>? testUvReadings,
  })  : _testDevices = testDevices ??
            [
              MockBluetoothDevice(
                name: 'UV Sensor 1',
                id: 'AA:BB:CC:DD:EE:01',
              ),
              MockBluetoothDevice(
                name: 'UV Sensor 2',
                id: 'AA:BB:CC:DD:EE:02',
              ),
              MockBluetoothDevice(
                name: 'Test UV Device',
                id: 'AA:BB:CC:DD:EE:03',
              ),
            ],
        _testUvReadings = testUvReadings ?? [3.5, 7.2, 9.8, 5.4, 2.1];

  @override
  bool get isConnected => _mockIsConnected;

  @override
  bool get isScanning => _mockIsScanning;

  @override
  bool get isReading => _mockIsReading;

  @override
  BluetoothDevice? get connectedDevice => _mockConnectedDevice?.device;
  
  /// Get the name of the connected device (helper for tests)
  String? get connectedDeviceName => _mockConnectedDevice?.name;

  @override
  List<BluetoothDevice> get discoveredDevices =>
      _testDevices.map((d) => d.device).toList();

  @override
  Future<bool> requestPermissions() async {
    return true;
  }

  @override
  Future<bool> isBluetoothAvailable() async {
    return true;
  }

  @override
  Future<void> scanForDevices() async {
    _mockIsScanning = true;
    notifyListeners();

    // Simulate scanning delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Devices are already available in _testDevices
    _mockIsScanning = false;
    notifyListeners();
  }

  @override
  Future<void> connectToDevice(BluetoothDevice device) async {
    // Find the mock device
    final mockDevice = _testDevices.firstWhere(
      (d) => d.device.remoteId.toString() == device.remoteId.toString(),
      orElse: () => throw Exception('Device not found'),
    );

    // Simulate connection delay
    await Future.delayed(const Duration(milliseconds: 300));

    _mockConnectedDevice = mockDevice;
    _mockIsConnected = true;
    notifyListeners();
  }

  @override
  Future<double?> startUVReading() async {
    if (!_mockIsConnected) {
      throw Exception('Not connected to a device');
    }

    _mockIsReading = true;
    notifyListeners();

    // Simulate 3-second reading
    await Future.delayed(const Duration(seconds: 3));

    // Get next UV reading from test data
    final uvValue = _testUvReadings[_readingIndex % _testUvReadings.length];
    _readingIndex++;

    _mockIsReading = false;
    notifyListeners();

    return uvValue;
  }

  @override
  Future<double?> readCurrentValue() async {
    if (!_mockIsConnected) {
      throw Exception('Not connected to a device');
    }

    final uvValue = _testUvReadings[_readingIndex % _testUvReadings.length];
    _readingIndex++;
    return uvValue;
  }

  @override
  Future<void> disconnect() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _mockConnectedDevice = null;
    _mockIsConnected = false;
    notifyListeners();
  }

  @override
  Future<Map<String, String>?> getLastDeviceInfo() async {
    if (_mockConnectedDevice != null) {
      return {
        'id': _mockConnectedDevice!.id,
        'name': _mockConnectedDevice!.name,
      };
    }
    return null;
  }

  @override
  Future<bool> reconnectToLastDevice() async {
    // Don't auto-reconnect in tests
    return false;
  }

  /// Reset the reading index for test repeatability
  void resetReadingIndex() {
    _readingIndex = 0;
  }
}

/// Mock Bluetooth Device for testing
class MockBluetoothDevice {
  final String name;
  final String id;
  late final BluetoothDevice device;

  MockBluetoothDevice({
    required this.name,
    required this.id,
  }) {
    // Create a real BluetoothDevice from the mock ID
    // Note: BluetoothDevice.fromId only takes an ID, the name comes from the actual device
    device = BluetoothDevice.fromId(id);
  }
}

/// Mock Storage Service for integration testing
class MockStorageService extends StorageService {
  final Map<String, dynamic> _inMemoryStorage = {};

  @override
  Future<void> saveReadings(List<UVReading> readings) async {
    final jsonList = readings.map((reading) => reading.toJson()).toList();
    _inMemoryStorage['uv_readings'] = jsonList;
  }

  @override
  Future<List<UVReading>> loadReadings() async {
    final jsonList = _inMemoryStorage['uv_readings'] as List<dynamic>?;
    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }
    return jsonList
        .map((json) => UVReading.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAlertThreshold(double threshold) async {
    _inMemoryStorage['uv_alert_threshold'] = threshold;
  }

  @override
  Future<double> loadAlertThreshold() async {
    return (_inMemoryStorage['uv_alert_threshold'] as double?) ?? 6.0;
  }

  /// Clear all storage for test isolation
  void clearStorage() {
    _inMemoryStorage.clear();
  }

  /// Pre-populate storage with test data
  void populateTestData({
    List<UVReading>? readings,
    double? alertThreshold,
  }) {
    if (readings != null) {
      final jsonList = readings.map((r) => r.toJson()).toList();
      _inMemoryStorage['uv_readings'] = jsonList;
    }
    if (alertThreshold != null) {
      _inMemoryStorage['uv_alert_threshold'] = alertThreshold;
    }
  }
}

