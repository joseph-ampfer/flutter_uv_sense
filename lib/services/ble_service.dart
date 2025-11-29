import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/ble_config.dart';

class BleService extends ChangeNotifier {
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _uvCharacteristic;
  StreamSubscription? _characteristicSubscription;
  StreamSubscription? _connectionStateSubscription;
  
  // State variables
  List<BluetoothDevice> _discoveredDevices = [];
  bool _isScanning = false;
  bool _isConnecting = false;
  bool _isReading = false;
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  
  // Getters
  List<BluetoothDevice> get discoveredDevices => _discoveredDevices;
  bool get isScanning => _isScanning;
  bool get isConnecting => _isConnecting;
  bool get isReading => _isReading;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  bool get isConnected => _connectionState == BluetoothConnectionState.connected;
  BluetoothConnectionState get connectionState => _connectionState;

  // Request necessary permissions
  Future<bool> requestPermissions() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.location.request().isGranted) {
      return true;
    }
    return false;
  }

  // Check if Bluetooth is available and on
  Future<bool> isBluetoothAvailable() async {
    try {
      return await FlutterBluePlus.isAvailable;
    } catch (e) {
      print('Error checking Bluetooth availability: $e');
      return false;
    }
  }

  // Scan for BLE devices
  Future<void> scanForDevices() async {
    try {
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) {
        throw Exception('Bluetooth permissions not granted');
      }

      final isAvailable = await isBluetoothAvailable();
      if (!isAvailable) {
        throw Exception('Bluetooth is not available');
      }

      // Stop any ongoing scan
      await FlutterBluePlus.stopScan();

      _isScanning = true;
      _discoveredDevices = [];
      notifyListeners();

      final List<BluetoothDevice> foundDevices = [];
      
      // Listen to scan results
      final scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        foundDevices.clear();
        for (ScanResult result in results) {
          // Filter by device name or service UUID
          if (result.device.platformName.toUpperCase().contains(BleConfig.deviceNameFilter.toUpperCase())) {
            if (!foundDevices.any((d) => d.remoteId == result.device.remoteId)) {
              foundDevices.add(result.device);
            }
          }
        }
        _discoveredDevices = List.from(foundDevices);
        notifyListeners();
      });

      // Start scanning
      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: BleConfig.scanForDevicesDurationSeconds),
      );

      // Wait for scan to complete
      await Future.delayed(Duration(seconds: BleConfig.scanForDevicesDurationSeconds));
      
      // Stop scanning
      await FlutterBluePlus.stopScan();
      scanSubscription.cancel();
      
      _isScanning = false;
      notifyListeners();
      
    } catch (e) {
      print('Error scanning for devices: $e');
      _isScanning = false;
      notifyListeners();
      rethrow;
    }
  }

  // Connect to a device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _isConnecting = true;
      notifyListeners();

      // Disconnect from any existing device
      await disconnect();

      _connectedDevice = device;

      // Listen to connection state changes
      _connectionStateSubscription = device.connectionState.listen((state) {
        _connectionState = state;
        if (state == BluetoothConnectionState.disconnected) {
          _connectedDevice = null;
          _uvCharacteristic = null;
        }
        notifyListeners();
      });

      // Connect to the device
      await device.connect(
        timeout: Duration(seconds: BleConfig.connectionTimeoutSeconds),
      );

      // Discover services
      final services = await device.discoverServices();
      
      // Find the UV data characteristic
      for (var service in services) {
        if (service.uuid.toString().toLowerCase() == BleConfig.serviceUUID.toLowerCase()) {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toLowerCase() == BleConfig.characteristicUUID.toLowerCase()) {
              _uvCharacteristic = characteristic;
              
              // Enable notifications
              await characteristic.setNotifyValue(true);
              
              // Listen to characteristic updates
              _characteristicSubscription = characteristic.lastValueStream.listen((value) {
                // Handle real-time updates if needed
                print('Real-time UV data received');
              });
              
              break;
            }
          }
        }
      }

      if (_uvCharacteristic == null) {
        throw Exception('UV characteristic not found on device');
      }

      // Save device info for auto-reconnect
      await _saveLastDevice(device);

      _isConnecting = false;
      _connectionState = BluetoothConnectionState.connected;
      notifyListeners();

    } catch (e) {
      print('Error connecting to device: $e');
      _connectedDevice = null;
      _isConnecting = false;
      _connectionState = BluetoothConnectionState.disconnected;
      notifyListeners();
      rethrow;
    }
  }

  // Parse UV data from bytes
  double? _parseUVData(List<int> bytes) {
    try {
      // Try parsing as string first
      String dataString = utf8.decode(bytes);
      
      // Try direct parse
      double? value = double.tryParse(dataString);
      if (value != null) {
        return value;
      }

      // Try base64 decode
      try {
        String decoded = utf8.decode(base64.decode(dataString));
        value = double.tryParse(decoded);
        if (value != null) {
          return value;
        }
      } catch (e) {
        // Not base64, continue
      }

      print('Could not parse UV data: $dataString');
      return null;
    } catch (e) {
      print('Error parsing UV data: $e');
      return null;
    }
  }

  // Start a 3-second UV reading session
  Future<double?> startUVReading() async {
    if (!isConnected || _uvCharacteristic == null) {
      throw Exception('Not connected to a device');
    }

    _isReading = true;
    notifyListeners();

    double? highestValue;
    final List<double> readings = [];
    
    // Subscribe to characteristic updates during reading period
    final subscription = _uvCharacteristic!.lastValueStream.listen((value) {
      final uvValue = _parseUVData(value);
      if (uvValue != null) {
        readings.add(uvValue);
        if (highestValue == null || uvValue > highestValue!) {
          highestValue = uvValue;
        }
      }
    });

    // Wait for sampling duration
    await Future.delayed(Duration(seconds: BleConfig.samplingDurationSeconds));
    
    subscription.cancel();
    _isReading = false;
    notifyListeners();
    
    return highestValue;
  }

  // Read current UV value once
  Future<double?> readCurrentValue() async {
    if (!isConnected || _uvCharacteristic == null) {
      throw Exception('Not connected to a device');
    }

    try {
      final value = await _uvCharacteristic!.read();
      return _parseUVData(value);
    } catch (e) {
      print('Error reading current value: $e');
      return null;
    }
  }

  // Disconnect from device
  Future<void> disconnect() async {
    try {
      await _characteristicSubscription?.cancel();
      await _connectionStateSubscription?.cancel();
      
      if (_connectedDevice != null) {
        await _connectedDevice!.disconnect();
      }
      
      _connectedDevice = null;
      _uvCharacteristic = null;
      _connectionState = BluetoothConnectionState.disconnected;
      notifyListeners();
    } catch (e) {
      print('Error disconnecting: $e');
    }
  }

  // Save last connected device info
  Future<void> _saveLastDevice(BluetoothDevice device) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(BleConfig.lastDeviceIdKey, device.remoteId.toString());
      await prefs.setString(BleConfig.lastDeviceNameKey, device.platformName);
    } catch (e) {
      print('Error saving device info: $e');
    }
  }

  // Get last connected device info
  Future<Map<String, String>?> getLastDeviceInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceId = prefs.getString(BleConfig.lastDeviceIdKey);
      final deviceName = prefs.getString(BleConfig.lastDeviceNameKey);
      
      if (deviceId != null && deviceName != null) {
        return {'id': deviceId, 'name': deviceName};
      }
    } catch (e) {
      print('Error getting last device info: $e');
    }
    return null;
  }

  // Try to reconnect to last device
  Future<bool> reconnectToLastDevice() async {
    try {
      final deviceInfo = await getLastDeviceInfo();
      if (deviceInfo == null) return false;

      // Get bonded devices
      final bondedDevices = await FlutterBluePlus.bondedDevices;
      
      // Try to find the device
      BluetoothDevice? device;
      for (var bondedDevice in bondedDevices) {
        if (bondedDevice.remoteId.toString() == deviceInfo['id']) {
          device = bondedDevice;
          break;
        }
      }

      if (device != null) {
        await connectToDevice(device);
        return true;
      }

      return false;
    } catch (e) {
      print('Error reconnecting to last device: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _characteristicSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    super.dispose();
  }
}
