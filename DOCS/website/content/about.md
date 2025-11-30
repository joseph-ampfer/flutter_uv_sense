---
title: "About"
description: "About the UV Monitor App project"
---

# About UV Monitor App

## Project Overview

The UV Monitor App is a comprehensive mobile application developed as part of the Cross-Platform Development course (ASE456) at Northern Kentucky University. It demonstrates real-world application of modern mobile development practices, Bluetooth Low Energy communication, and user-centered design principles.

---

## The Problem

### UV Exposure Challenges

**Lack of Accurate Data:**
- Generic weather apps provide only rough UV indices for entire regions
- They don't account for micro-environments like shade, cloud cover, or reflective surfaces
- Indoor vs outdoor differences are not captured
- Real-time changes throughout the day are missed

**Poor Tracking:**
- Most people don't monitor their cumulative UV exposure
- No awareness of daily or weekly totals
- Difficult to correlate exposure with skin reactions

**One-Size-Fits-All Advice:**
- UV tolerance varies greatly by skin type, genetics, and lifestyle
- Generic recommendations don't account for individual sensitivity
- Fitzpatrick skin types have different safe exposure times
- Recent sun exposure affects current tolerance

**Health Consequences:**
- **Overexposure:** Increased risk of skin cancer, premature aging, sunburn
- **Underexposure:** Vitamin D deficiency, weakened immune system
- Lack of awareness leads to preventable skin damage

---

## The Solution

### Real-Time Personal Monitoring

The UV Monitor App addresses these challenges through:

**1. Hardware Integration**
- ESP32-based UV sensor with VEML6075 sensor module
- Bluetooth Low Energy for wireless communication
- Real-time streaming of accurate UV index data
- Portable and battery-powered for outdoor use

**2. Personalized Assessment**
- Evidence-based skin type quiz (Fitzpatrick scale)
- 11 questions covering physical characteristics and sun reactions
- Scientific scoring algorithm
- Individual risk profile generation

**3. Intelligent Recommendations**
- Dynamic advice based on current UV level + skin type
- Calculated safe exposure times
- Specific protection measures (SPF, clothing, timing)
- Color-coded danger levels for quick understanding

**4. Data Persistence & Tracking**
- Local storage of all UV readings
- Historical view of exposure patterns
- Privacy-focused: no cloud, no accounts
- Trend analysis capability

---

## Project Goals

### Educational Objectives

This project demonstrates mastery of:

**Cross-Platform Development:**
- Flutter framework for iOS and Android
- Dart programming language
- Material Design principles
- Responsive UI design

**Mobile Technologies:**
- Bluetooth Low Energy (BLE) communication
- GATT protocol implementation
- Permission handling
- Sensor data streaming

**Software Architecture:**
- Provider state management pattern
- Service-oriented architecture
- Model-View-ViewModel concepts
- Separation of concerns

**Data Management:**
- Local persistence with SharedPreferences
- JSON serialization/deserialization
- Efficient data structures
- Privacy-by-design approach

**Quality Assurance:**
- Unit testing
- Widget testing
- Integration testing
- Test-driven development practices

### Real-World Application

Beyond education, this app provides genuine value:
- **For outdoor enthusiasts:** Track exposure during activities
- **For parents:** Monitor children's UV exposure
- **For sun-sensitive individuals:** Prevent overexposure
- **For vitamin D awareness:** Ensure adequate exposure
- **For skin health:** Long-term exposure tracking

---

## Technical Achievements

### Core Features Implemented

✅ **BLE Integration**
- Device scanning and discovery
- Connection management with reconnection logic
- Real-time data streaming
- Connection state monitoring
- Error handling and recovery

✅ **User Personalization**
- 11-question dermatological quiz
- Fitzpatrick skin type classification
- 6 distinct skin type profiles
- Personalized safe exposure calculations

✅ **Recommendation Engine**
- UV level classification (WHO standards)
- Dynamic advice generation
- Skin type-adjusted timing
- Context-aware protection measures

✅ **Data Persistence**
- Local storage of up to 50 readings
- Alert threshold persistence
- Skin type profile storage
- Efficient JSON serialization

✅ **Comprehensive Testing**
- 300+ lines of unit tests
- Widget tests for all screens
- Integration tests for complete flows
- Mock objects for isolated testing

### Code Quality

- **Architecture:** Clean separation of services, models, providers, screens
- **Documentation:** Inline comments and code documentation
- **Linting:** Follows Flutter/Dart style guidelines
- **Version Control:** Structured Git workflow with feature branches
- **Testing:** High coverage of critical paths

---

## Development Process

### Agile Methodology

The project followed an agile development approach:

**Sprint 1:** Requirements & Foundation
- Feature definition and requirements gathering
- Architecture design
- Basic UI mockups
- BLE research and prototyping

**Sprint 2:** Core Implementation
- BLE service implementation
- UI screen development
- State management setup
- Basic testing

**Sprint 3:** Features & Polish
- Skin type quiz implementation
- Recommendation engine
- Data persistence
- Comprehensive testing

**Sprint 4:** Testing & Documentation
- Integration tests
- Bug fixes and refinements
- Documentation
- User guide creation

---

## Technologies Used

### Frontend
- **Flutter 3.9+** - Cross-platform UI framework
- **Dart** - Programming language
- **Material Design 3** - Design system
- **Provider** - State management

### Connectivity
- **flutter_blue_plus** - BLE communication library
- **ESP32** - Microcontroller platform
- **VEML6075** - UV sensor hardware

### Storage & Permissions
- **shared_preferences** - Local key-value storage
- **permission_handler** - Runtime permissions

### Testing & Development
- **mockito** - Mocking framework
- **flutter_test** - Testing framework
- **integration_test** - End-to-end testing
- **build_runner** - Code generation

---

## Future Enhancements

### Planned Features

**Data Visualization:**
- Charts showing UV trends over time
- Daily/weekly/monthly summaries
- Exposure heatmaps
- Goal tracking

**Advanced Notifications:**
- Push notifications for UV alerts
- Smart reminders based on patterns
- Medication reminder (for photosensitivity)

**Extended Integration:**
- Weather API for UV forecasts
- Calendar integration for outdoor events
- Health app integration (Apple Health, Google Fit)

**Enhanced Personalization:**
- Multiple user profiles
- Medication tracking (photosensitivity drugs)
- Skin condition logging
- Sunscreen application reminders

**Social Features:**
- Export and share reports
- Family accounts
- Group outdoor activity planning

**Cloud Sync (Optional):**
- Multi-device sync
- Backup and restore
- Long-term data analysis
- Anonymous research contribution

---

## Course Information

**Course:** ASE456 - Cross-Platform Development  
**Institution:** Northern Kentucky University  
**Term:** Fall 2025  
**Focus Areas:**
- Mobile application development
- Cross-platform frameworks
- Bluetooth communication
- User experience design
- Software testing
- Agile methodology

---

## Acknowledgments

This project builds upon:
- **Fitzpatrick Skin Type Scale** - Dermatological research
- **WHO UV Index** - World Health Organization standards
- **Flutter Community** - Open source packages and documentation
- **Espressif** - ESP32 platform and tools

---

## License & Usage

This is an educational project developed for academic purposes. The code serves as a reference implementation for:
- Cross-platform mobile development
- BLE integration patterns
- State management in Flutter
- Testing strategies

---

## Contact & Resources

For more information:
- Review the [Documentation](/docs/)
- Check out the [Features](/features/)
- See [Getting Started](/getting-started/) for installation
- View the source code repository

**Thank you for exploring the UV Monitor App!** ☀️

