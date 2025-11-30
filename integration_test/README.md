# Integration Tests

This directory contains integration tests for the UV Monitor app. These tests verify complete user flows including quiz completion, BLE operations, settings management, and data persistence.

## Test Structure

- **test_helpers.dart** - Mock implementations of BleService and StorageService
- **app_test_wrapper.dart** - Test app wrapper with injectable dependencies
- **quiz_flow_integration_test.dart** - Tests for the complete quiz flow
- **ble_flow_integration_test.dart** - Tests for BLE connection and UV reading flow
- **settings_flow_integration_test.dart** - Tests for settings management
- **persistence_integration_test.dart** - Tests for data persistence

## Running Integration Tests

### Run all integration tests

```bash
flutter test integration_test
```

### Run a specific test file

```bash
flutter test integration_test/quiz_flow_integration_test.dart
flutter test integration_test/ble_flow_integration_test.dart
flutter test integration_test/settings_flow_integration_test.dart
flutter test integration_test/persistence_integration_test.dart
```

### Run tests on a specific device

```bash
# List available devices
flutter devices

# Run on a specific device
flutter test integration_test --device-id=<device_id>
```

### Run with integration test driver (for reporting)

```bash
flutter drive \
  --driver=integration_test_driver/integration_test.dart \
  --target=integration_test/quiz_flow_integration_test.dart
```

## Test Coverage

### Quiz Flow Tests
- ✅ Complete quiz from UV Monitor to Results and back
- ✅ Quiz can be retaken from Results screen
- ✅ Quiz can be closed and returns to UV Monitor
- ✅ Results screen can be closed
- ✅ Different quiz responses lead to different skin types

### BLE Flow Tests
- ✅ Scan for devices and connect to one
- ✅ Take UV reading when connected
- ✅ UV reading appears in recent readings list
- ✅ Cannot take reading without connection
- ✅ Device connection state is visible in UI
- ✅ UV level colors change based on reading value
- ✅ Multiple devices can be discovered and selected

### Settings Flow Tests
- ✅ Open settings modal and change skin type
- ✅ Adjust UV alert threshold with slider
- ✅ Recommendations update based on selected skin type
- ✅ Skin type selection is visually highlighted
- ✅ Multiple skin type changes persist correctly
- ✅ Settings modal can be closed without making changes
- ✅ UV alert threshold range is correct (0-11)
- ✅ Skin type changes reflect in recommendations immediately

### Persistence Tests
- ✅ UV readings persist across app restarts
- ✅ Alert threshold persists after changes
- ✅ Skin type selection persists via provider
- ✅ Skin type from quiz persists in provider
- ✅ Multiple readings accumulate correctly
- ✅ State persists during navigation between screens
- ✅ Connection state persists during navigation
- ✅ Provider state resets correctly on fresh app start
- ✅ Storage service mock correctly simulates persistence

## Mock Services

### MockBleService
The mock BLE service simulates Bluetooth device discovery and UV readings without requiring actual hardware:
- Returns 3 predefined test devices
- Simulates scanning delays (500ms)
- Simulates connection delays (300ms)
- Simulates 3-second UV reading sessions
- Returns predictable UV values for testing

### MockStorageService
The mock storage service uses in-memory storage instead of SharedPreferences:
- Stores data in a Map for test isolation
- Provides methods to pre-populate test data
- Can be cleared between tests
- Simulates all persistence operations

## Notes

- All tests use mocked BLE and storage services for reliable CI/CD execution
- Tests do not require actual BLE hardware
- Each test is isolated and can run independently
- Tests verify both UI state and provider state
- Mock services can be customized per test with specific test data

## Troubleshooting

### Tests fail with "No device found"
Make sure you have either an emulator running or a physical device connected:
```bash
flutter devices
```

### Tests timeout
Integration tests can take longer than unit tests. If you experience timeouts, you can increase the timeout:
```dart
testWidgets('test name', (tester) async {
  // test code
}, timeout: const Timeout(Duration(minutes: 2)));
```

### Pump errors
If you see pump errors, ensure you're using `pumpAndSettle()` after navigation or async operations:
```dart
await tester.tap(find.text('Button'));
await tester.pumpAndSettle(); // Wait for animations to complete
```

