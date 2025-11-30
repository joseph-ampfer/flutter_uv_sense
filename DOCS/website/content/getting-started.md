---
title: "Getting Started"
description: "Install and set up the UV Monitor App"
---

# Getting Started

Get up and running with the UV Monitor App in minutes.

---

## Prerequisites

Before you begin, make sure you have the following:

### Software Requirements
- **Flutter SDK** 3.9 or higher
- **Dart SDK** (bundled with Flutter)
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)
- **Git** for cloning the repository

### Hardware Requirements
- **Smartphone or Tablet** running Android 5.0+ or iOS 12+
- **ESP32 UV Sensor** with custom firmware (optional for testing)
- **Bluetooth** capability on your device

### Development Tools (Optional)
- **VS Code** with Flutter extension (recommended)
- **Flutter DevTools** for debugging
- **Android Emulator** or **iOS Simulator**

---

## Installation

### Step 1: Install Flutter

If you haven't installed Flutter yet:

```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install
# Add Flutter to your PATH

# Verify installation
flutter doctor
```

Run `flutter doctor` to check for any missing dependencies and follow its recommendations.

### Step 2: Clone the Repository

```bash
git clone <repository-url>
cd uv_app
```

### Step 3: Install Dependencies

```bash
flutter pub get
```

This will download all required packages:
- `flutter_blue_plus` - Bluetooth connectivity
- `shared_preferences` - Local storage
- `permission_handler` - Runtime permissions
- `provider` - State management

### Step 4: Check Your Setup

```bash
flutter doctor -v
```

Ensure all checks pass for your target platform (Android or iOS).

---

## Running the App

### On Android Device/Emulator

1. **Connect your Android device** via USB with USB debugging enabled, or start an Android emulator

2. **Verify device connection:**
   ```bash
   flutter devices
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### On iOS Device/Simulator

1. **Open iOS Simulator** or connect your iPhone

2. **Verify device connection:**
   ```bash
   flutter devices
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### On Desktop (Limited BLE Support)

**Windows:**
```bash
flutter run -d windows
```

**macOS:**
```bash
flutter run -d macos
```

**Note:** Desktop platforms have limited Bluetooth Low Energy support.

---

## Building for Production

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS App (macOS only)

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode to archive and distribute.

---

## First Launch

### 1. Grant Permissions

When you first launch the app, it will request:
- **Bluetooth permissions** - To connect to UV sensor
- **Location permissions** - Required by Android for BLE scanning

Tap "Allow" to enable all features.

### 2. Take the Skin Type Quiz

For the best experience:
1. Tap **"Take Skin Type Quiz"** on the main screen
2. Answer 11 questions about your skin characteristics
3. View your results and skin type classification
4. Your personalized recommendations are now active!

### 3. Connect Your UV Sensor

If you have an ESP32 UV sensor:
1. Power on your sensor device
2. Tap **"Connect Device"** in the app
3. Tap **"Scan for Devices"**
4. Select your device from the list
5. Wait for connection confirmation
6. UV readings will start streaming!

**Don't have a sensor?** You can still explore the app and quiz features. The app will display sample data for testing purposes.

---

## Configuration

### BLE Settings

Edit `lib/config/ble_config.dart` to customize:

```dart
class BleConfig {
  // Your custom UUIDs
  static const String serviceUUID = 
    '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  static const String characteristicUUID = 
    'beb5483e-36e1-4688-b7f5-ea07361b26a8';
  
  // Device name filter
  static const String deviceNameFilter = 'ESP32';
  
  // Timeouts (seconds)
  static const int scanForDevicesDurationSeconds = 10;
  static const int connectionTimeoutSeconds = 15;
}
```

### App Settings

Within the app, you can customize:
- **UV Alert Threshold** - Set your warning level (default: 6.0)
- **Skin Type** - Retake quiz to update
- **Device Connection** - Manage paired devices

---

## Troubleshooting

### Bluetooth Connection Issues

**Problem:** App can't find devices
- ✅ Ensure Bluetooth is enabled on your phone
- ✅ Ensure location services are enabled (Android requirement)
- ✅ Check that your UV sensor is powered on
- ✅ Make sure device name contains "ESP32" (or update filter)
- ✅ Try moving closer to the device

**Problem:** Connection keeps failing
- ✅ Restart both the app and the sensor device
- ✅ Check that no other app is connected to the sensor
- ✅ Clear Bluetooth cache in phone settings
- ✅ Try "Forget device" and re-pair

### Permission Issues

**Problem:** App crashes on launch
- ✅ Grant all requested permissions
- ✅ Go to Settings > Apps > UV Monitor > Permissions
- ✅ Enable Bluetooth and Location
- ✅ Restart the app

### Build Issues

**Problem:** `flutter pub get` fails
- ✅ Check internet connection
- ✅ Clear pub cache: `flutter pub cache repair`
- ✅ Update Flutter: `flutter upgrade`

**Problem:** Build errors
- ✅ Run `flutter clean`
- ✅ Run `flutter pub get`
- ✅ Try building again
- ✅ Check Flutter version compatibility

---

## Testing

### Run Unit and Widget Tests

```bash
flutter test
```

### Run Integration Tests

```bash
# On connected device or emulator
flutter test integration_test/
```

### Specific Integration Test

```bash
flutter test integration_test/quiz_flow_integration_test.dart
```

### Generate Test Coverage

```bash
flutter test --coverage
```

View coverage:
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Next Steps

Now that you're set up:

1. **[Read the User Guide](/docs/user-guide/)** - Learn how to use all features
2. **[Explore the Developer Guide](/docs/developer-guide/)** - Understand the architecture
3. **[Review Features](/features/)** - See what the app can do
4. **[Check the Architecture Docs](/docs/architecture/)** - Deep dive into implementation

---

## Need Help?

- Check the [Documentation](/docs/) for detailed guides
- Review the code comments and inline documentation
- Examine the test files for usage examples
- Contact your instructor or development team

Happy monitoring! ☀️

