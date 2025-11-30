---
title: "Testing Guide"
description: "Comprehensive testing documentation"
weight: 4
---

# Testing Guide

Complete guide to testing strategies, running tests, and writing new tests for the UV Monitor App.

---

## Table of Contents

1. [Testing Strategy](#testing-strategy)
2. [Test Structure](#test-structure)
3. [Unit Tests](#unit-tests)
4. [Widget Tests](#widget-tests)
5. [Integration Tests](#integration-tests)
6. [Running Tests](#running-tests)
7. [Writing Tests](#writing-tests)
8. [Test Coverage](#test-coverage)
9. [Best Practices](#best-practices)

---

## Testing Strategy

The UV Monitor App employs a comprehensive testing strategy following the test pyramid approach.

### Test Pyramid

```
         ┌─────────────────┐
        ┌┤  Integration    ├┐   ← Few, slow, high value
       ┌┤└─────────────────┘├┐
      ┌┤    Widget Tests     ├┐  ← More, faster
     ┌┤└─────────────────────┘├┐
    ┌┤       Unit Tests        ├┐ ← Most, fastest
    └┴─────────────────────────┴┘
```

**Unit Tests (70%)**
- Test individual functions and classes
- Fast execution
- High code coverage
- Easy to write and maintain

**Widget Tests (20%)**
- Test UI components
- Verify user interactions
- Check rendering
- Medium execution speed

**Integration Tests (10%)**
- Test complete user flows
- End-to-end scenarios
- Slower but highest confidence
- Require device/emulator

---

## Test Structure

### Directory Organization

```
test/
├── models/
│   └── data_models_test.dart        # Model tests
├── providers/
│   └── skin_type_provider_test.dart # Provider tests
├── services/
│   ├── ble_service_test.dart        # BLE service tests
│   └── storage_service_test.dart    # Storage tests
├── widgets/
│   ├── uv_monitor_screen_test.dart  # Monitor screen tests
│   ├── quiz_screen_test.dart        # Quiz tests
│   └── results_screen_test.dart     # Results tests
└── widget_test.dart                 # Main app tests

integration_test/
├── ble_flow_integration_test.dart       # BLE flow
├── quiz_flow_integration_test.dart      # Quiz flow
├── persistence_integration_test.dart    # Data persistence
├── settings_flow_integration_test.dart  # Settings
└── test_helpers.dart                    # Test utilities
```

### Test File Naming

**Convention:** `{filename}_test.dart`

Examples:
- `ble_service.dart` → `ble_service_test.dart`
- `quiz_screen.dart` → `quiz_screen_test.dart`

---

## Unit Tests

### Purpose

Unit tests verify individual units of code in isolation:
- Functions
- Classes
- Methods
- Business logic

### Example: Model Tests

```dart
// test/models/data_models_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:uv_app/models/data_models.dart';

void main() {
  group('UVReading', () {
    test('should serialize to JSON correctly', () {
      // Arrange
      final reading = UVReading(
        id: 'test_1',
        uvIndex: 5.5,
        timestamp: DateTime(2025, 1, 1, 12, 0),
      );

      // Act
      final json = reading.toJson();

      // Assert
      expect(json['id'], 'test_1');
      expect(json['uvIndex'], 5.5);
      expect(json['timestamp'], '2025-01-01T12:00:00.000');
    });

    test('should deserialize from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'test_1',
        'uvIndex': 5.5,
        'timestamp': '2025-01-01T12:00:00.000',
      };

      // Act
      final reading = UVReading.fromJson(json);

      // Assert
      expect(reading.id, 'test_1');
      expect(reading.uvIndex, 5.5);
      expect(reading.timestamp, DateTime(2025, 1, 1, 12, 0));
    });

    test('should handle edge cases in deserialization', () {
      final json = {
        'id': 'edge_1',
        'uvIndex': 0,
        'timestamp': '2025-01-01T00:00:00.000',
      };

      final reading = UVReading.fromJson(json);

      expect(reading.uvIndex, 0);
    });
  });
}
```

### Example: Provider Tests

```dart
// test/providers/skin_type_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:uv_app/providers/skin_type_provider.dart';
import 'package:uv_app/data/mock_data.dart';

void main() {
  group('SkinTypeProvider', () {
    test('should initialize with default skin type', () {
      final provider = SkinTypeProvider();
      
      expect(provider.selectedSkinType, skinTypes[2]); // Medium
    });

    test('should update skin type and notify listeners', () {
      final provider = SkinTypeProvider();
      bool notified = false;
      
      provider.addListener(() {
        notified = true;
      });

      provider.updateSkinType(skinTypes[0]); // Very Fair

      expect(provider.selectedSkinType, skinTypes[0]);
      expect(notified, true);
    });
  });
}
```

### Example: Service Tests with Mocks

```dart
// test/services/storage_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uv_app/services/storage_service.dart';
import 'package:uv_app/models/data_models.dart';

void main() {
  group('StorageService', () {
    setUp(() {
      // Initialize fake shared preferences
      SharedPreferences.setMockInitialValues({});
    });

    test('should save and load readings', () async {
      final service = StorageService();
      final readings = [
        UVReading(
          id: 'reading_1',
          uvIndex: 5.5,
          timestamp: DateTime.now(),
        ),
      ];

      // Save
      await service.saveReadings(readings);

      // Load
      final loadedReadings = await service.loadReadings();

      expect(loadedReadings.length, 1);
      expect(loadedReadings[0].id, 'reading_1');
      expect(loadedReadings[0].uvIndex, 5.5);
    });

    test('should return default threshold when none saved', () async {
      final service = StorageService();

      final threshold = await service.loadAlertThreshold();

      expect(threshold, 6.0);
    });

    test('should save and load alert threshold', () async {
      final service = StorageService();

      await service.saveAlertThreshold(8.0);
      final threshold = await service.loadAlertThreshold();

      expect(threshold, 8.0);
    });
  });
}
```

---

## Widget Tests

### Purpose

Widget tests verify UI components and user interactions:
- Widget rendering
- User input handling
- Navigation
- State changes reflected in UI

### Example: Basic Widget Test

```dart
// test/widgets/quiz_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uv_app/screens/quiz_screen.dart';

void main() {
  group('QuizScreen', () {
    testWidgets('should display first question', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: QuizScreen(),
        ),
      );

      // Verify question text is displayed
      expect(find.text('Which skin type are you?'), findsOneWidget);
      
      // Verify question counter
      expect(find.text('1/12'), findsOneWidget);
    });

    testWidgets('should navigate to next question on answer', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QuizScreen(),
        ),
      );

      // Tap an option
      await tester.tap(find.text('Find my skin type'));
      await tester.pump(Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verify moved to next question
      expect(find.text('What color are your eyes?'), findsOneWidget);
    });

    testWidgets('should show progress indicator', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QuizScreen(),
        ),
      );

      // Should show 1/12 initially
      expect(find.text('1/12'), findsOneWidget);
    });
  });
}
```

### Example: Widget Test with Provider

```dart
// test/widgets/uv_monitor_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uv_app/screens/uv_monitor_screen.dart';
import 'package:uv_app/services/ble_service.dart';
import 'package:uv_app/providers/skin_type_provider.dart';

void main() {
  group('UVMonitorScreen', () {
    testWidgets('should display UV reading', (WidgetTester tester) async {
      // Create mock services
      final bleService = BleService();
      final skinTypeProvider = SkinTypeProvider();

      // Build widget with providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: bleService),
            ChangeNotifierProvider.value(value: skinTypeProvider),
          ],
          child: MaterialApp(
            home: UVMonitorScreen(),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('0.0'), findsOneWidget);
    });
  });
}
```

---

## Integration Tests

### Purpose

Integration tests verify complete user flows from end to end:
- Multiple screens
- Complete workflows
- Real services (or realistic mocks)
- Device-level interactions

### Example: Quiz Flow Test

```dart
// integration_test/quiz_flow_integration_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uv_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Quiz Flow Integration Test', () {
    testWidgets('should complete full quiz flow', (tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to quiz
      await tester.tap(find.text('Take Skin Type Quiz'));
      await tester.pumpAndSettle();

      // Answer all questions
      for (int i = 0; i < 12; i++) {
        // Find first option and tap
        final firstOption = find.byType(ListTile).first;
        await tester.tap(firstOption);
        await tester.pump(Duration(milliseconds: 300));
        await tester.pumpAndSettle();
      }

      // Should be on results screen
      expect(find.text('Your Skin Type'), findsOneWidget);

      // Should show a skin type result
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('should update skin type in provider', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Complete quiz
      await tester.tap(find.text('Take Skin Type Quiz'));
      await tester.pumpAndSettle();

      // Select specific answers for Fair skin
      await tester.tap(find.text('Find my skin type'));
      await tester.pumpAndSettle();

      // Answer remaining questions
      // ... (complete quiz logic)

      // Return to main screen
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify skin type is reflected in recommendations
      expect(find.textContaining('Fair'), findsWidgets);
    });
  });
}
```

### Example: Persistence Test

```dart
// integration_test/persistence_integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uv_app/main.dart' as app;
import 'package:uv_app/services/storage_service.dart';
import 'package:uv_app/models/data_models.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Data Persistence Integration Test', () {
    testWidgets('should persist UV readings across app restarts', 
        (tester) async {
      final storageService = StorageService();

      // Save some readings
      final readings = [
        UVReading(
          id: 'test_1',
          uvIndex: 7.5,
          timestamp: DateTime.now(),
        ),
      ];
      await storageService.saveReadings(readings);

      // Restart app
      app.main();
      await tester.pumpAndSettle();

      // Verify readings are loaded
      expect(find.text('7.5'), findsOneWidget);
    });
  });
}
```

---

## Running Tests

### Unit and Widget Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/ble_service_test.dart

# Run tests matching pattern
flutter test --name "BleService"

# Verbose output
flutter test --verbose

# Run tests with coverage
flutter test --coverage
```

### Integration Tests

```bash
# Run all integration tests (requires device/emulator)
flutter test integration_test/

# Run specific integration test
flutter test integration_test/quiz_flow_integration_test.dart

# On specific device
flutter test integration_test/ -d <device_id>

# List devices
flutter devices
```

### Watch Mode (during development)

```bash
# Re-run tests on file changes
flutter test --watch
```

---

## Writing Tests

### Test Structure (AAA Pattern)

```dart
test('description of what is being tested', () {
  // Arrange - Set up test data and conditions
  final input = 'test data';
  
  // Act - Execute the code being tested
  final result = functionUnderTest(input);
  
  // Assert - Verify the results
  expect(result, expectedValue);
});
```

### Best Practices for Writing Tests

**1. Clear Test Names**
```dart
// Good
test('should return empty list when no readings exist', () {});

// Bad
test('test1', () {});
```

**2. One Assertion Per Test (when possible)**
```dart
// Good
test('should return correct UV level for index 3', () {
  expect(getUVLevel(3).level, 'Moderate');
});

test('should return correct color for UV index 3', () {
  expect(getUVLevel(3).color, Colors.yellow);
});

// Acceptable when testing related aspects
test('should create valid UVReading from JSON', () {
  final reading = UVReading.fromJson(json);
  expect(reading.id, 'test_1');
  expect(reading.uvIndex, 5.5);
});
```

**3. Test Edge Cases**
```dart
group('UV Level Classification', () {
  test('should handle minimum value (0)', () {
    expect(getUVLevel(0).level, 'Low');
  });

  test('should handle boundary (2.0)', () {
    expect(getUVLevel(2.0).level, 'Low');
  });

  test('should handle just above boundary (2.1)', () {
    expect(getUVLevel(2.1).level, 'Moderate');
  });

  test('should handle maximum value (15+)', () {
    expect(getUVLevel(20).level, 'Extreme');
  });
});
```

**4. Use setUp and tearDown**
```dart
group('StorageService', () {
  late StorageService service;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    service = StorageService();
  });

  tearDown(() {
    // Clean up if needed
  });

  test('test 1', () {});
  test('test 2', () {});
});
```

### Mocking Dependencies

```dart
// Using mockito
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks
@GenerateMocks([BleService])
import 'ble_service_test.mocks.dart';

void main() {
  test('should use mocked service', () {
    // Create mock
    final mockBleService = MockBleService();
    
    // Define behavior
    when(mockBleService.currentUVIndex).thenReturn(5.5);
    when(mockBleService.isConnected).thenReturn(true);
    
    // Use in test
    expect(mockBleService.currentUVIndex, 5.5);
    expect(mockBleService.isConnected, true);
    
    // Verify interactions
    verify(mockBleService.currentUVIndex).called(1);
  });
}
```

---

## Test Coverage

### Generating Coverage Reports

```bash
# Generate coverage data
flutter test --coverage

# Output: coverage/lcov.info
```

### Viewing Coverage

```bash
# Install lcov (if not installed)
# Ubuntu/Debian:
sudo apt-get install lcov

# macOS:
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Coverage Goals

**Target Coverage:**
- **Overall:** 70%+
- **Services:** 80%+
- **Models:** 90%+
- **Providers:** 80%+
- **Screens:** 60%+ (UI code harder to test)

**What to Cover:**
✅ Business logic  
✅ Data transformations  
✅ Error handling  
✅ Edge cases  
✅ Critical paths  

**What Not to Focus On:**
- Generated code
- Simple getters/setters
- UI layout code (test with widget tests instead)

---

## Best Practices

### General Testing Best Practices

**1. Fast Tests**
- Keep tests fast (<1s per test)
- Mock external dependencies
- Avoid real network calls
- Use fakes for complex dependencies

**2. Isolated Tests**
- Tests should not depend on each other
- Each test should set up its own data
- Clean up after tests

**3. Readable Tests**
- Clear test names
- Good arrange/act/assert structure
- Comments for complex logic

**4. Maintainable Tests**
- Don't test implementation details
- Test behavior, not internals
- Refactor tests with code

**5. Reliable Tests**
- No flaky tests
- Deterministic results
- No timing dependencies

### Flutter-Specific Best Practices

**Widget Tests:**
```dart
// Use pumpAndSettle for animations
await tester.pumpAndSettle();

// Use pump with duration for specific timing
await tester.pump(Duration(milliseconds: 300));

// Find widgets by key for reliability
find.byKey(Key('my_widget'));

// Use semantics for accessibility testing
expect(tester.getSemantics(find.byType(Text)), matchesSemantics(
  label: 'Hello',
));
```

**Provider Tests:**
```dart
// Always wrap widgets with providers
MultiProvider(
  providers: [
    ChangeNotifierProvider.value(value: mockService),
  ],
  child: WidgetUnderTest(),
);
```

### Continuous Integration

**GitHub Actions Example:**
```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter test integration_test/
```

---

## Troubleshooting Tests

### Common Issues

**Problem:** Tests pass locally but fail in CI
- ✅ Check Flutter version consistency
- ✅ Verify all dependencies installed
- ✅ Check for timing issues (use pumpAndSettle)
- ✅ Review environment differences

**Problem:** Flaky widget tests
- ✅ Use `pumpAndSettle()` instead of `pump()`
- ✅ Add delays for animations
- ✅ Check for race conditions
- ✅ Use `findsOneWidget` instead of checking counts

**Problem:** Mock not working
- ✅ Run `flutter pub run build_runner build`
- ✅ Check mock is imported
- ✅ Verify `when()` setup correct
- ✅ Check method is virtual (not final/static)

---

## Summary

### Test Coverage Breakdown

| Component | Unit Tests | Widget Tests | Integration Tests |
|-----------|------------|--------------|-------------------|
| Models | ✅ | - | - |
| Services | ✅ | - | ✅ |
| Providers | ✅ | - | ✅ |
| Screens | ✅ | ✅ | ✅ |
| Full Flows | - | - | ✅ |

### Key Takeaways

✅ **Test pyramid** - More unit tests, fewer integration tests  
✅ **Fast feedback** - Run unit tests frequently  
✅ **Comprehensive coverage** - Test critical paths thoroughly  
✅ **Maintainable** - Keep tests simple and readable  
✅ **Automated** - Run in CI/CD pipeline  

---

## Next Steps

- [Developer Guide](/docs/developer-guide/) - Understanding the code
- [Architecture](/docs/architecture/) - System design
- [Getting Started](/getting-started/) - Setup for development

---

**Happy Testing!** 🧪

