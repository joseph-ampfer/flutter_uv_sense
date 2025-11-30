---
title: "Architecture"
description: "System architecture and design decisions"
weight: 3
---

# Architecture

Deep dive into the UV Monitor App's technical architecture, design patterns, and key decisions.

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Architectural Pattern](#architectural-pattern)
3. [Component Diagram](#component-diagram)
4. [Data Flow](#data-flow)
5. [State Management](#state-management)
6. [Design Decisions](#design-decisions)
7. [Technology Choices](#technology-choices)
8. [Performance Considerations](#performance-considerations)

---

## System Overview

The UV Monitor App is built using a **layered architecture** with clear separation between:
- Presentation (UI)
- Business Logic (Services & Providers)
- Data (Models & Storage)
- External Communication (BLE)

### High-Level Architecture

```
┌─────────────────────────────────────────────────┐
│              Presentation Layer                  │
│   ┌──────────────────┐  ┌──────────────────┐   │
│   │  UV Monitor      │  │  Quiz & Results  │   │
│   │  Screen          │  │  Screens         │   │
│   └──────────────────┘  └──────────────────┘   │
└─────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────┐
│           Business Logic Layer                   │
│   ┌──────────────┐         ┌──────────────┐    │
│   │  BleService  │         │ SkinType     │    │
│   │ (Provider)   │         │ Provider     │    │
│   └──────────────┘         └──────────────┘    │
│                                                  │
│   ┌──────────────┐         ┌──────────────┐    │
│   │  Storage     │         │ Recommendation│   │
│   │  Service     │         │ Engine       │    │
│   └──────────────┘         └──────────────┘    │
└─────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────┐
│               Data Layer                         │
│   ┌──────────────────────────────────────┐     │
│   │  Models (UVReading, SkinType, etc.)  │     │
│   └──────────────────────────────────────┘     │
└─────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────┐
│          External Systems                        │
│   ┌──────────────┐         ┌──────────────┐    │
│   │   ESP32      │         │  Local       │    │
│   │   UV Sensor  │         │  Storage     │    │
│   │   (BLE)      │         │ (SharedPrefs)│    │
│   └──────────────┘         └──────────────┘    │
└─────────────────────────────────────────────────┘
```

---

## Architectural Pattern

### Service-Oriented Architecture

The app follows a **service-oriented architecture** pattern:

**Services** (`lib/services/`)
- Encapsulate external system interactions
- BLE communication (BleService)
- Local storage (StorageService)
- Independent, testable units

**Providers** (`lib/providers/`)
- Manage application state
- Extend ChangeNotifier
- Notify UI of state changes
- SkinTypeProvider for user preferences

**Models** (`lib/models/`)
- Pure data structures
- No business logic
- JSON serialization support
- Immutable where possible

**Screens** (`lib/screens/`)
- Presentation only
- Consume services/providers
- Handle user interactions
- Delegate logic to services

### Benefits

✅ **Testability** - Each layer can be tested independently  
✅ **Maintainability** - Clear responsibilities  
✅ **Scalability** - Easy to add new features  
✅ **Reusability** - Services can be used across screens

---

## Component Diagram

### Core Components

```
┌───────────────────────────────────────────────┐
│                   main.dart                    │
│  ┌─────────────────────────────────────────┐ │
│  │        MultiProvider Setup              │ │
│  │  ┌────────────┐    ┌────────────────┐  │ │
│  │  │ BleService │    │ SkinTypeProvider│  │ │
│  │  └────────────┘    └────────────────┘  │ │
│  └─────────────────────────────────────────┘ │
└───────────────────────────────────────────────┘
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
┌──────────────────┐    ┌──────────────────┐
│ UV Monitor Screen│    │   Quiz Screens   │
│                  │    │                  │
│  Uses:           │    │  Uses:           │
│  - BleService    │    │  - Quiz Data     │
│  - SkinTypeProv. │    │  - SkinTypeProv. │
│  - StorageServ.  │    │  - Navigation    │
│  - Mock Data     │    │                  │
└──────────────────┘    └──────────────────┘
```

### Component Interactions

**BleService Component:**
- Scans for devices
- Manages connections
- Streams UV data
- Notifies listeners

**SkinTypeProvider Component:**
- Stores selected skin type
- Updates from quiz results
- Provides data for recommendations

**StorageService Component:**
- Persists UV readings
- Saves alert thresholds
- Loads data on startup

**Screen Components:**
- Listen to providers
- Display data
- Handle user input
- Navigate between screens

---

## Data Flow

### UV Reading Flow

```
ESP32 Sensor
     │
     │ (BLE GATT Protocol)
     ▼
BleService
     │
     │ (notifyListeners)
     ▼
UV Monitor Screen
     │
     │ (Create UVReading object)
     ▼
StorageService
     │
     │ (JSON encode)
     ▼
SharedPreferences
```

### Quiz Flow

```
User Input
     │
     ▼
Quiz Screen
     │
     │ (Collect responses)
     ▼
Results Screen
     │
     │ (Calculate skin type)
     ▼
SkinTypeProvider
     │
     │ (notifyListeners)
     ▼
UV Monitor Screen
     │
     │ (Update recommendations)
     ▼
Display Updated Advice
```

### Recommendation Generation Flow

```
Current UV Index ─────┐
                      │
Skin Type ────────────┤
                      │
                      ▼
              Recommendation Engine
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
    Safe Exposure Time      Protection Advice
          │                       │
          └───────────┬───────────┘
                      ▼
              Display to User
```

---

## State Management

### Provider Pattern Implementation

**Why Provider?**
- ✅ Simple and straightforward
- ✅ Good for medium-complexity apps
- ✅ Built-in Flutter support
- ✅ Easy to test
- ✅ Good performance

**State Structure:**

```dart
// BleService extends ChangeNotifier
class BleService extends ChangeNotifier {
  // State variables
  BluetoothDevice? _connectedDevice;
  List<BluetoothDevice> _discoveredDevices = [];
  bool _isScanning = false;
  bool _isConnecting = false;
  double _currentUVIndex = 0.0;

  // Getters expose state
  BluetoothDevice? get connectedDevice => _connectedDevice;
  List<BluetoothDevice> get discoveredDevices => _discoveredDevices;
  bool get isScanning => _isScanning;
  bool get isConnecting => _isConnecting;
  double get currentUVIndex => _currentUVIndex;

  // Methods modify state and notify
  Future<void> scanForDevices() async {
    _isScanning = true;
    notifyListeners();
    // ... scanning logic ...
    _isScanning = false;
    notifyListeners();
  }
}
```

**UI Consumption:**

```dart
// Widgets watch for changes
Widget build(BuildContext context) {
  final bleService = context.watch<BleService>();
  
  return Text('UV: ${bleService.currentUVIndex}');
  // Rebuilds when BleService notifies
}
```

### Local State vs Global State

**Global State (Providers):**
- BLE connection status
- Current UV reading
- Selected skin type
- Shared across screens

**Local State (StatefulWidget):**
- UV readings list
- Alert threshold
- UI-specific state (e.g., current page in quiz)
- Screen-specific data

---

## Design Decisions

### 1. Provider over Bloc/Riverpod

**Decision:** Use Provider for state management

**Rationale:**
- Simpler learning curve for students
- Sufficient for app's complexity
- Good Flutter integration
- Widely adopted and documented

**Trade-offs:**
- Less structured than Bloc
- Manual state management
- Good enough for this scope

### 2. SharedPreferences over SQLite

**Decision:** Use SharedPreferences for local storage

**Rationale:**
- Simple key-value storage sufficient
- No complex queries needed
- Lightweight and fast
- Easy to implement

**Trade-offs:**
- Not suitable for large datasets
- Limited to 50 readings (acceptable)
- No relational capabilities (not needed)

### 3. flutter_blue_plus over flutter_blue

**Decision:** Use flutter_blue_plus package

**Rationale:**
- More actively maintained
- Better null-safety support
- Improved connection stability
- Better documentation

**Trade-offs:**
- Smaller community than flutter_blue
- But better maintained

### 4. Mock Data Approach

**Decision:** Static data in `mock_data.dart`

**Rationale:**
- Skin types are fixed (Fitzpatrick scale)
- Quiz questions are static
- UV recommendations follow standard table
- Easy to update without code changes

**Benefits:**
- Clear separation of data and logic
- Easy to modify questions/recommendations
- Supports internationalization in future

### 5. Local-First Architecture

**Decision:** No cloud sync, all data local

**Rationale:**
- Privacy-focused design
- No account management needed
- Simpler implementation
- Faster performance
- Works offline

**Trade-offs:**
- No multi-device sync
- No backup/restore
- No collaborative features
- Acceptable for MVP

---

## Technology Choices

### Flutter Framework

**Why Flutter?**
- ✅ Cross-platform (single codebase)
- ✅ Fast development (hot reload)
- ✅ Beautiful UIs (Material Design)
- ✅ Good BLE support
- ✅ Active community

**Version:** 3.9+ (stable, modern features)

### Key Packages

**flutter_blue_plus** (BLE)
- Most actively maintained BLE package
- Comprehensive API
- Good error handling
- Cross-platform support

**provider** (State Management)
- Official Flutter recommendation
- Simple and effective
- Good performance
- Easy testing

**shared_preferences** (Storage)
- Standard for key-value storage
- Fast and reliable
- Cross-platform
- Simple API

**permission_handler** (Permissions)
- Handles runtime permissions
- Cross-platform
- Required for BLE on Android

---

## Performance Considerations

### BLE Communication

**Optimizations:**
- Scan timeout of 10 seconds (balance discovery vs battery)
- Connection timeout of 15 seconds (prevent hanging)
- Auto-reconnect to last device (better UX)
- Stream subscriptions properly cancelled (prevent leaks)

**Battery Impact:**
- BLE is low-energy by design
- Notification-based updates (not polling)
- Disconnect when not needed
- Efficient data parsing

### UI Performance

**Optimizations:**
- Provider for efficient rebuilds (only affected widgets)
- Const constructors where possible
- Lazy loading with PageView (quiz)
- Minimal widget tree depth

**Smooth Animations:**
- 60 FPS target
- Hardware-accelerated rendering
- Efficient state updates

### Data Storage

**Optimizations:**
- Limit to 50 readings (prevents unbounded growth)
- JSON serialization (fast and compact)
- Async operations (non-blocking UI)
- Batch operations where possible

### Memory Management

**Considerations:**
- Stream subscriptions disposed properly
- Controllers disposed in dispose()
- Weak references where appropriate
- No memory leaks in tests

---

## Scalability

### Current Limitations

- Single device connection
- 50 reading limit
- No cloud sync
- Basic alert system

### Future Scalability

**Easy to Add:**
- More skin types
- Additional quiz questions
- More recommendation rules
- New UV metrics

**Requires Architecture Changes:**
- Multi-device support (would need device management layer)
- Cloud sync (would need backend API layer)
- Advanced analytics (would need data warehouse)
- Push notifications (would need notification service)

### Extensibility Points

**Adding New Features:**
1. New services can be added to `services/`
2. New providers for complex state
3. New models for data structures
4. New screens with routing

**Plugin Architecture:**
- Services are independent
- Can swap implementations
- Good for testing
- Easy to extend

---

## Security Considerations

### Data Privacy

**Current Approach:**
- All data stored locally
- No external transmission
- No user accounts
- No tracking/analytics

**BLE Security:**
- Standard Bluetooth pairing
- Connection encryption (Bluetooth standard)
- No sensitive data transmitted
- Device-level security

### Permissions

**Required Permissions:**
- Bluetooth (for sensor connection)
- Location (Android BLE requirement)
- Explained clearly to users
- Minimal permissions requested

---

## Testing Architecture

### Test Pyramid

```
         ┌──────────────┐
        ┌┤ Integration  ├┐
       ┌┤└──────────────┘├┐
      ┌┤   Widget Tests   ├┐
     ┌┤└──────────────────┘├┐
    ┌┤     Unit Tests       ├┐
    └┴──────────────────────┴┘
```

**Unit Tests** (Most)
- Services logic
- Models serialization
- Providers state changes
- Calculation functions

**Widget Tests** (Middle)
- Screen rendering
- User interactions
- Widget composition
- Navigation

**Integration Tests** (Least, Most Valuable)
- Complete user flows
- BLE connection flow
- Quiz completion flow
- Data persistence flow

### Testability Features

**Dependency Injection:**
- Services injected via providers
- Easy to mock in tests
- Isolated testing

**Separation of Concerns:**
- Business logic separate from UI
- Pure functions where possible
- Testable units

---

## Deployment Architecture

### Build Targets

**Android:**
- APK for direct installation
- AAB for Play Store distribution
- Minimum SDK: Android 5.0 (API 21)

**iOS:**
- IPA for App Store
- Minimum iOS: 12.0
- Requires Mac and Xcode for building

**Desktop:**
- Windows exe
- macOS app
- Linux binary
- Limited BLE support

### CI/CD Considerations

**Automated Testing:**
- Run tests on PR
- Check code coverage
- Lint checking

**Build Automation:**
- Automated builds for releases
- Version management
- Asset optimization

---

## Conclusion

The UV Monitor App architecture balances:
- ✅ **Simplicity** - Easy to understand and maintain
- ✅ **Testability** - Comprehensive test coverage
- ✅ **Performance** - Fast and responsive
- ✅ **Scalability** - Room to grow
- ✅ **Best Practices** - Following Flutter conventions

**Next Steps:**
- [Developer Guide](/docs/developer-guide/) - Implementation details
- [Testing Guide](/docs/testing/) - Testing strategies
- [Features](/features/) - Feature documentation

---

**Questions?** Refer to inline code documentation or consult with your development team.

