---
title: "UV Monitor App"
description: "Your Personal UV Exposure Assistant"
---

# UV Monitor App

## Your Personal UV Exposure Assistant

Stay safe in the sun with real-time UV monitoring and personalized recommendations based on your skin type.

![UV Monitor Screen](/images/monitor_screen.png)

---

## Why UV Monitoring Matters

**The Challenge:**
- Generic weather apps provide only rough UV indices
- They don't account for shade, clouds, or micro-environments
- Most people don't track their cumulative UV exposure
- Overexposure increases skin cancer risk, while underexposure leads to vitamin D deficiency

**Our Solution:**
Real-time, personalized UV monitoring with your own Bluetooth-connected sensor device and intelligent recommendations tailored to your skin type.

---

## Key Features

### 🔌 Real-Time BLE Sensor Integration
Connect to your ESP32 UV sensor via Bluetooth Low Energy for accurate, real-time UV index readings based on your exact location and environment.

### 👤 Personalized Recommendations
Take a quick 11-question skin type assessment based on the Fitzpatrick skin type scale to receive customized advice on safe exposure times and sun protection.

### 📊 Historical Tracking
View your recent UV readings with timestamps, track patterns throughout the day, and understand your exposure levels over time. All data persists locally on your device.

### 🔔 Smart Alerts
Set customizable UV alert thresholds and get notified when UV levels exceed your safe limits. Perfect for outdoor activities and sun-sensitive individuals.

### 🎨 Color-Coded UV Levels
Instantly understand UV danger levels with WHO-standard color coding:
- 🟢 **Low (0-2)**: Minimal protection needed
- 🟡 **Moderate (3-5)**: Use sunscreen
- 🟠 **High (6-7)**: Protection required
- 🔴 **Very High (8-10)**: Extra protection needed
- 🟣 **Extreme (11+)**: Avoid sun exposure

### 📱 Cross-Platform Support
Built with Flutter for seamless performance on Android, iOS, and desktop platforms.

---

## Technology Stack

**Frontend:**
- Flutter & Dart
- Material Design 3
- Provider for state management

**Connectivity:**
- Bluetooth Low Energy (BLE)
- ESP32 UV sensor integration
- flutter_blue_plus

**Data & Storage:**
- Local persistence with SharedPreferences
- JSON serialization
- No cloud dependencies

**Testing:**
- Comprehensive unit tests
- Widget tests
- Integration tests
- High test coverage

---

## Quick Start

Ready to get started? Check out our guides:

- [**Getting Started**](/getting-started/) - Installation and setup
- [**User Guide**](/docs/user-guide/) - How to use the app
- [**Developer Guide**](/docs/developer-guide/) - Technical documentation

---

## Screenshots

### Main Dashboard
![Monitor Screen](/images/monitor_screen.png)

### Recent Readings
![Recent Readings](/images/recent_readings.png)

### Skin Type Quiz
![Quiz Start](/images/start_quiz.png)
![Quiz Questions](/images/quiz_middle.png)
![Quiz Results](/images/quiz_results.png)

---

## Project Information

**Course:** Cross-Platform Development ASE456  
**Institution:** Northern Kentucky University  
**Platform:** Flutter/Dart  
**License:** Educational Project  

This project demonstrates real-world application of:
- Cross-platform mobile development
- Bluetooth Low Energy communication
- State management patterns
- Local data persistence
- User interface design
- Comprehensive testing strategies

---

## Learn More

Explore our comprehensive documentation:

- [Features Overview](/features/) - Detailed feature descriptions
- [Documentation](/docs/) - Complete technical and user guides
- [About](/about/) - Project background and goals

