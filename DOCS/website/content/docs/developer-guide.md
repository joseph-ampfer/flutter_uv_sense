---
title: "Developer Guide"
description: "Technical documentation for UV Monitor App development"
weight: 2
---

# Developer Guide

Comprehensive technical documentation for developers working on or extending the UV Monitor App.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [State Management](#state-management)
4. [Data Models](#data-models)
5. [BLE Service](#ble-service)
6. [Storage Service](#storage-service)
7. [UI Components](#ui-components)
8. [Recommendation Engine](#recommendation-engine)
9. [Testing](#testing)
10. [Code Quality](#code-quality)

---

## Project Overview

**UV Monitor App** is a Flutter-based mobile application for real-time UV exposure monitoring with Bluetooth Low Energy (BLE) sensor integration.

### Target Platforms
- ✅ **Android** 5.0+ (Full BLE support)
- ✅ **iOS** 12+ (Full BLE support)
- ⚠️ **Desktop** (Windows/macOS/Linux with limited BLE support)

### Tech Stack

**Framework & Language:**
- Flutter SDK 3.9+
- Dart 3.0+
- Material Design 3

**Key Dependencies:**
```yaml
dependencies:
  flutter_blue_plus: ^1.32.0    # BLE connectivity
  shared_preferences: ^2.2.0     # Local storage
  permission_handler: ^11.0.0    # Runtime permissions
  provider: ^6.1.0               # State management

dev_dependencies:
  mockito: ^5.4.4               # Mocking for tests
  build_runner: ^2.4.13         # Code generation
  flutter_test:                 # Testing framework
    sdk: flutter
  integration_test:             # Integration tests
    sdk: flutter
```

---

## Architecture

### Project Structure

```
lib/
├── main.dart                    # App entry point, provider setup
├── config/
│   └── ble_config.dart         # BLE configuration constants
├── data/
│   └── mock_data.dart          # Static data, quiz questions
├── models/
│   └── data_models.dart        # All data models
├── providers/
│   └── skin_type_provider.dart # Skin type state management
├── screens/
│   ├── uv_monitor_screen.dart  # Main dashboard
│   ├── quiz_screen.dart        # Skin type quiz
│   └── results_screen.dart     # Quiz results
└── services/
    ├── ble_service.dart        # BLE communication
    └── storage_service.dart    # Local persistence
```

### Architecture Pattern

The app follows a **service-oriented architecture** with clear separation of concerns:

- **Services** - Handle external communication (BLE, Storage)
- **Providers** - Manage app state (ChangeNotifier pattern)
- **Models** - Pure data structures
- **Screens** - UI presentation layer
- **Config/Data** - Static configuration and mock data

---

## State Management

### Provider Pattern

The app uses the **Provider** package for reactive state management.

#### Main App Setup

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BleService()),
        ChangeNotifierProvider(create: (_) => SkinTypeProvider()),
      ],
      child: MaterialApp(
        title: 'UV Monitor App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const MainNavigationPage(),
        routes: {
          '/quiz': (context) => const QuizScreen(),
          '/results': (context) {
            final responses = ModalRoute.of(context)!
              .settings.arguments as Map<int, int>;
            return ResultsScreen(responses: responses);
          },
        },
      ),
    );
  }
}
```

### Two Main Providers

**1. BleService (ChangeNotifier)**
- Manages Bluetooth device connections
- Handles data streaming from UV sensor
- Provides connection state to UI

**2. SkinTypeProvider (ChangeNotifier)**
- Manages selected skin type
- Updates when quiz is completed
- Provides skin type data for recommendations

### Consuming Providers

```dart
// In widgets - watch for changes
final bleService = context.watch<BleService>();
final skinTypeProvider = context.watch<SkinTypeProvider>();

// Or read without rebuilding
final bleService = context.read<BleService>();
```

---

## Data Models

### Core Models

All models are defined in `lib/models/data_models.dart`.

#### UVReading

```dart
class UVReading {
  final String id;
  final double uvIndex;
  final DateTime timestamp;

  UVReading({
    required this.id,
    required this.uvIndex,
    required this.timestamp,
  });

  // JSON serialization for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uvIndex': uvIndex,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory UVReading.fromJson(Map<String, dynamic> json) {
    return UVReading(
      id: json['id'] as String,
      uvIndex: (json['uvIndex'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
```

#### SkinType

```dart
class SkinType {
  final String id;
  final String name;               // "Very Fair", "Fair", etc.
  final String description;        // "Always burns, never tans"
  final Color color;               // Visual representation
  final int burnTime;              // Minutes to burn at UV=1

  SkinType({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.burnTime,
  });
}
```

**6 Skin Types defined in `mock_data.dart`:**
1. Very Fair (burnTime: 5 min)
2. Fair (burnTime: 10 min)
3. Medium (burnTime: 15 min)
4. Olive (burnTime: 20 min)
5. Brown (burnTime: 25 min)
6. Dark (burnTime: 30 min)

#### UVRecommendation

```dart
class UVRecommendation {
  final double uvIndex;            // Threshold UV index
  final int safeExposure;          // Minutes safe in sun
  final List<String> protection;   // Protection advice strings

  UVRecommendation({
    required this.uvIndex,
    required this.safeExposure,
    required this.protection,
  });
}
```

#### Device

```dart
enum BleConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

class Device {
  final String id;
  final String name;
  final int batteryLevel;
  final bool isConnected;
  final BleConnectionState connectionState;
  final int? signalStrength;       // RSSI value

  Device({
    required this.id,
    required this.name,
    this.batteryLevel = 0,
    this.isConnected = false,
    this.connectionState = BleConnectionState.disconnected,
    this.signalStrength,
  });

  Device copyWith({/* ... */});
}
```

#### Quiz Models

```dart
class QuizOption {
  final String text;
  final int value;                 // Score value for this option
}

class QuizQuestion {
  final int id;
  final String question;
  final String? description;
  final List<QuizOption> options;
}
```

---

## BLE Service

The `BleService` class (`lib/services/ble_service.dart`) handles all Bluetooth Low Energy communication.

### Key Responsibilities

- Device scanning and discovery
- Connection management
- Data streaming from UV sensor
- Auto-reconnection to last device
- Permission handling
- Error handling and recovery

### BLE Configuration

Defined in `lib/config/ble_config.dart`:

```dart
class BleConfig {
  // Service and characteristic UUIDs (match ESP32 firmware)
  static const String serviceUUID = 
    '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  static const String characteristicUUID = 
    'beb5483e-36e1-4688-b7f5-ea07361b26a8';
  
  // Device filtering
  static const String deviceNameFilter = 'ESP32';
  
  // Timeouts
  static const int scanForDevicesDurationSeconds = 10;
  static const int connectionTimeoutSeconds = 15;
}
```

### Device Scanning

```dart
Future<void> scanForDevices() async {
  try {
    // Request necessary permissions
    final hasPermissions = await requestPermissions();
    if (!hasPermissions) {
      throw Exception('Bluetooth permissions not granted');
    }

    // Check if Bluetooth is available
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
        // Filter by device name
        if (result.device.platformName.toUpperCase()
            .contains(BleConfig.deviceNameFilter.toUpperCase())) {
          if (!foundDevices.any((d) => d.remoteId == result.device.remoteId)) {
            foundDevices.add(result.device);
          }
        }
      }
      _discoveredDevices = List.from(foundDevices);
      notifyListeners();
    });

    // Start scanning with timeout
    await FlutterBluePlus.startScan(
      timeout: Duration(seconds: BleConfig.scanForDevicesDurationSeconds),
    );

    // Wait for scan to complete
    await Future.delayed(
      Duration(seconds: BleConfig.scanForDevicesDurationSeconds)
    );
    
    await FlutterBluePlus.stopScan();
    scanSubscription.cancel();
    
    _isScanning = false;
    notifyListeners();
    
  } catch (e) {
    _isScanning = false;
    notifyListeners();
    rethrow;
  }
}
```

### Device Connection

```dart
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

    // Connect to the device with timeout
    await device.connect(
      timeout: Duration(seconds: BleConfig.connectionTimeoutSeconds),
    );

    // Discover services
    final services = await device.discoverServices();
    
    // Find the UV data characteristic
    for (var service in services) {
      if (service.uuid.toString().toLowerCase() == 
          BleConfig.serviceUUID.toLowerCase()) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toLowerCase() == 
              BleConfig.characteristicUUID.toLowerCase()) {
            _uvCharacteristic = characteristic;
            
            // Enable notifications
            await characteristic.setNotifyValue(true);
            
            // Listen to characteristic updates
            _characteristicSubscription = characteristic.lastValueStream
                .listen(_handleUVData);
            
            break;
          }
        }
      }
    }

    // Save device ID for auto-reconnect
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_device_id', device.remoteId.toString());

    _isConnecting = false;
    notifyListeners();
    
  } catch (e) {
    _isConnecting = false;
    _connectedDevice = null;
    notifyListeners();
    rethrow;
  }
}
```

### Data Streaming

```dart
void _handleUVData(List<int> value) {
  try {
    // Decode bytes to string
    String dataString = utf8.decode(value);
    
    // Parse JSON
    Map<String, dynamic> data = jsonDecode(dataString);
    
    // Extract UV index
    double uvIndex = (data['uv_index'] as num).toDouble();
    
    // Update current value
    _currentUVIndex = uvIndex;
    notifyListeners();
    
    // Trigger callback for screen updates
    if (_onDataReceived != null) {
      _onDataReceived!(uvIndex);
    }
  } catch (e) {
    print('Error parsing UV data: $e');
  }
}
```

### Auto-Reconnection

```dart
Future<void> reconnectToLastDevice() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final lastDeviceId = prefs.getString('last_device_id');
    
    if (lastDeviceId == null) return;
    
    // Get connected devices
    final connectedDevices = await FlutterBluePlus.connectedDevices;
    
    for (var device in connectedDevices) {
      if (device.remoteId.toString() == lastDeviceId) {
        await connectToDevice(device);
        return;
      }
    }
  } catch (e) {
    print('Error reconnecting to last device: $e');
  }
}
```

---

## Storage Service

The `StorageService` class (`lib/services/storage_service.dart`) handles local data persistence using SharedPreferences.

### Implementation

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/data_models.dart';

class StorageService {
  static const String _readingsKey = 'uv_readings';
  static const String _alertThresholdKey = 'uv_alert_threshold';

  // Save UV readings to local storage
  Future<void> saveReadings(List<UVReading> readings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = readings.map((reading) => reading.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_readingsKey, jsonString);
    } catch (e) {
      print('Error saving readings: $e');
    }
  }

  // Load UV readings from local storage
  Future<List<UVReading>> loadReadings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_readingsKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => UVReading.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading readings: $e');
      return [];
    }
  }

  // Save UV alert threshold
  Future<void> saveAlertThreshold(double threshold) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_alertThresholdKey, threshold);
    } catch (e) {
      print('Error saving alert threshold: $e');
    }
  }

  // Load UV alert threshold (returns default 6.0 if not found)
  Future<double> loadAlertThreshold() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_alertThresholdKey) ?? 6.0;
    } catch (e) {
      print('Error loading alert threshold: $e');
      return 6.0;
    }
  }
}
```

### Usage in UV Monitor Screen

```dart
final StorageService _storageService = StorageService();

// On init
Future<void> _loadPersistedData() async {
  try {
    final readings = await _storageService.loadReadings();
    final threshold = await _storageService.loadAlertThreshold();
    
    setState(() {
      uvReadings = readings;
      uvAlertThreshold = threshold;
    });
  } catch (e) {
    print('Error loading persisted data: $e');
  }
}

// When adding new reading
void _addUVReading(double uvValue) {
  final reading = UVReading(
    id: 'reading_${DateTime.now().millisecondsSinceEpoch}',
    uvIndex: uvValue,
    timestamp: DateTime.now(),
  );
  
  setState(() {
    uvReadings.insert(0, reading);
    // Keep only last 50 readings
    if (uvReadings.length > 50) {
      uvReadings = uvReadings.sublist(0, 50);
    }
  });
  
  // Persist to storage
  _storageService.saveReadings(uvReadings);
}
```

---

## UI Components

### Main Screens

#### 1. UV Monitor Screen

Primary dashboard showing:
- Real-time UV reading with color coding
- Connection status and controls
- Recent readings list
- Personalized recommendations
- Settings access

**Key Features:**
- Listens to `BleService` for data updates
- Uses `SkinTypeProvider` for recommendations
- Manages local state for UI
- Persists data with `StorageService`

#### 2. Quiz Screen

Paginated quiz with 11 questions:
- PageView for smooth transitions
- Auto-advance after answer selection
- Progress indicator
- Response tracking

```dart
class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  Map<int, int> responses = {};
  int currentPage = 0;

  void _handleOptionSelect(int questionId, int value) {
    setState(() {
      responses[questionId] = value;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (questionId == 11) {
        // Last question - navigate to results
        Navigator.pushNamed(context, '/results', arguments: responses);
      } else {
        // Next question
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}
```

#### 3. Results Screen

Displays quiz results:
- Calculates skin type from responses
- Shows skin type characteristics
- Updates `SkinTypeProvider`
- Navigates back to monitor screen

---

## Recommendation Engine

### Algorithm

```dart
UVRecommendation _getRecommendations(SkinType selectedSkinType) {
  // Find base recommendation for current UV level
  final recommendation = uvRecommendations.firstWhere(
    (r) => currentUV >= r.uvIndex,
    orElse: () => uvRecommendations.last,
  );
  
  // Adjust safe exposure time based on skin type
  // Formula: base_time × (user_burn_time / 20)
  final safeTime = (recommendation.safeExposure * 
                    (selectedSkinType.burnTime / 20)).round();
  
  return UVRecommendation(
    uvIndex: recommendation.uvIndex,
    safeExposure: safeTime,
    protection: recommendation.protection,
  );
}
```

### UV Level Classification

```dart
UVLevel _getUVLevel(double uvIndex) {
  if (uvIndex <= 2) return UVLevel('Low', Colors.green);
  if (uvIndex <= 5) return UVLevel('Moderate', Colors.yellow);
  if (uvIndex <= 7) return UVLevel('High', Colors.orange);
  if (uvIndex <= 10) return UVLevel('Very High', Colors.red);
  return UVLevel('Extreme', Colors.purple);
}
```

---

## Testing

### Test Structure

```
test/
├── models/
│   └── data_models_test.dart        # Model serialization tests
├── providers/
│   └── skin_type_provider_test.dart # Provider state tests
├── services/
│   ├── ble_service_test.dart        # BLE logic tests
│   └── storage_service_test.dart    # Persistence tests
├── widgets/
│   ├── uv_monitor_screen_test.dart  # UI component tests
│   ├── quiz_screen_test.dart        # Quiz interaction tests
│   └── results_screen_test.dart     # Results display tests
└── widget_test.dart                 # App-level widget tests

integration_test/
├── ble_flow_integration_test.dart
├── quiz_flow_integration_test.dart
├── persistence_integration_test.dart
└── settings_flow_integration_test.dart
```

### Running Tests

```bash
# All unit and widget tests
flutter test

# Specific test file
flutter test test/services/ble_service_test.dart

# Integration tests (requires device/emulator)
flutter test integration_test/

# With coverage
flutter test --coverage
```

### Example Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:uv_app/models/data_models.dart';

void main() {
  group('UVReading', () {
    test('should serialize to JSON correctly', () {
      final reading = UVReading(
        id: 'test_1',
        uvIndex: 5.5,
        timestamp: DateTime(2025, 1, 1, 12, 0),
      );

      final json = reading.toJson();

      expect(json['id'], 'test_1');
      expect(json['uvIndex'], 5.5);
      expect(json['timestamp'], '2025-01-01T12:00:00.000');
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'test_1',
        'uvIndex': 5.5,
        'timestamp': '2025-01-01T12:00:00.000',
      };

      final reading = UVReading.fromJson(json);

      expect(reading.id, 'test_1');
      expect(reading.uvIndex, 5.5);
      expect(reading.timestamp, DateTime(2025, 1, 1, 12, 0));
    });
  });
}
```

---

## Code Quality

### Linting

The project uses `flutter_lints ^5.0.0` which enforces Dart style guidelines.

**Key Rules:**
- Prefer const constructors
- Avoid print in production code
- Use meaningful variable names
- Document public APIs
- Avoid unused imports

### Code Organization

**Best Practices:**
- ✅ Separation of concerns (services, models, UI)
- ✅ Single responsibility principle
- ✅ Dependency injection via providers
- ✅ Immutable data models where possible
- ✅ Error handling and recovery
- ✅ Comprehensive documentation

### Performance

**Optimizations:**
- Efficient state management (minimal rebuilds)
- Lazy loading with PageView
- Limiting stored readings (50 max)
- Async operations for I/O
- Stream subscriptions properly cancelled

---

## Next Steps

- [Architecture Documentation](/docs/architecture/) - Deep dive into system design
- [Testing Guide](/docs/testing/) - Comprehensive testing information
- [Getting Started](/getting-started/) - Development environment setup
- [Features](/features/) - Detailed feature descriptions

---

**Questions?** Review inline code documentation, examine test files for examples, or consult with your team/instructor.

