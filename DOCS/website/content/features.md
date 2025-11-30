---
title: "Features"
description: "Detailed overview of UV Monitor App features"
---

# Features

## Comprehensive UV Monitoring Solution

The UV Monitor App provides a complete solution for tracking and managing your UV exposure with advanced features designed for both safety and convenience.

---

## 🔌 Bluetooth UV Sensor Integration

### Real-Time Data Streaming
Connect seamlessly to your ESP32-based UV sensor device using Bluetooth Low Energy (BLE) technology. The app continuously streams UV index readings, providing you with up-to-the-second information about your UV exposure.

**Technical Details:**
- Uses GATT protocol for reliable communication
- Custom service and characteristic UUIDs
- Automatic reconnection to last paired device
- Connection state monitoring with visual indicators
- Battery level reporting (if supported by device)

**User Experience:**
- Simple device scanning interface
- One-tap connection
- Visual connection status
- Automatic pairing on app launch
- Signal strength indicators

### Device Management
- **Scan for Devices**: Discover nearby UV sensor devices
- **Easy Pairing**: Connect with a single tap
- **Persistent Connection**: Auto-reconnect to last device
- **Troubleshooting**: Clear error messages and connection help

![Monitor Screen](/images/monitor_screen.png)

---

## 👤 Personalized Skin Type Assessment

### Evidence-Based Quiz
Our 11-question assessment is based on the Fitzpatrick Skin Type Scale, a dermatologically-validated system for classifying skin phototypes.

**Questions Cover:**
- Physical characteristics (eye color, hair color, natural skin tone)
- Sun reaction tendencies (burning vs tanning)
- Freckling patterns
- Recent sun exposure history
- Face sensitivity to sun

**6 Skin Type Categories:**
1. **Very Fair** - Always burns, never tans (5 min burn time)
2. **Fair** - Usually burns, tans minimally (10 min burn time)
3. **Medium** - Sometimes burns, tans gradually (15 min burn time)
4. **Olive** - Burns minimally, tans well (20 min burn time)
5. **Brown** - Rarely burns, tans darkly (25 min burn time)
6. **Dark** - Never burns, always tans (30 min burn time)

### Interactive Quiz Experience
- Modern, user-friendly interface
- Progress indicator
- Smooth page transitions
- Auto-advance after answer selection
- Detailed results screen with skin type characteristics

![Quiz Flow](/images/quiz_middle.png)

---

## 🧠 Intelligent Recommendation Engine

### Personalized Safety Advice
The app combines your skin type with real-time UV readings to provide actionable, personalized recommendations.

**Algorithm:**
1. Read current UV index from sensor
2. Retrieve your skin type profile
3. Calculate safe exposure time: `base_time × (skin_burn_time / 20)`
4. Generate protection advice based on UV level
5. Display recommendations with clear action items

### Example Recommendations

**Low UV (0-2) + Medium Skin Type:**
- ✅ Safe for 60 minutes
- 🧴 Minimal protection needed
- 🕶️ Sunglasses recommended for snow/water activities

**Moderate UV (3-5) + Fair Skin Type:**
- ⏱️ Safe for 15 minutes
- 🧴 Use SPF 15+ sunscreen
- 🕶️ Wear sunglasses on bright days
- 💡 Be cautious around reflective surfaces

**Very High UV (8-10) + Very Fair Skin Type:**
- ⚠️ Safe for only 5 minutes
- 🧴 Use SPF 50+ sunscreen
- 🌳 Minimize sun exposure 10 AM - 4 PM
- 👕 Wear protective clothing and hat
- 🕶️ Wear UV-blocking sunglasses

**Extreme UV (11+) + Any Skin Type:**
- 🚫 Avoid sun exposure
- 🌳 Seek shade whenever possible
- 🧴 Use SPF 50+ sunscreen if outdoors
- 👕 Wear protective clothing and wide-brimmed hat
- 🕶️ Always wear UV-blocking sunglasses

---

## 📊 Historical Data Tracking

### Recent Readings List
View your last 50 UV readings with complete details:
- UV index value
- Color-coded danger level
- Timestamp
- Visual list with icons

### Data Persistence
- All readings saved locally using SharedPreferences
- Data survives app restarts
- Privacy-focused: no cloud sync, all data stays on device
- JSON serialization for efficient storage
- Configurable history limit

![Recent Readings](/images/recent_readings.png)

---

## 🔔 Customizable Alert System

### UV Threshold Alerts
Set your own UV alert threshold based on your sensitivity and comfort level.

**Features:**
- Adjustable threshold slider (0-15 UV index)
- Default set to 6.0 (High level)
- Visual indicator when threshold exceeded
- Persistent threshold settings
- Recommended thresholds by skin type

**Suggested Thresholds:**
- Very Fair Skin: 3.0
- Fair Skin: 4.0
- Medium Skin: 6.0
- Olive/Brown/Dark Skin: 7.0-8.0

---

## 🎨 Color-Coded UV Level System

### WHO Standard Color Coding
The app uses the World Health Organization's UV Index standard for color coding:

| UV Index | Level | Color | Protection |
|----------|-------|-------|------------|
| 0-2 | Low | 🟢 Green | Minimal |
| 3-5 | Moderate | 🟡 Yellow | Use sunscreen |
| 6-7 | High | 🟠 Orange | Protection required |
| 8-10 | Very High | 🔴 Red | Extra protection |
| 11+ | Extreme | 🟣 Purple | Avoid exposure |

### Visual Clarity
- Large, easy-to-read UV index display
- Prominent color coding
- Level text labels
- Instant understanding at a glance

---

## 📱 Cross-Platform Mobile App

### Built with Flutter
Native performance on multiple platforms:
- ✅ **Android** - Full BLE support
- ✅ **iOS** - Full BLE support
- ⚠️ **Desktop** - Limited BLE support (Windows/macOS/Linux)

### Modern UI/UX
- Material Design 3
- Smooth animations and transitions
- Responsive layouts
- Intuitive navigation
- Accessibility considerations

### Performance
- Fast startup time
- Efficient BLE communication
- Minimal battery impact
- Smooth 60 FPS animations
- Optimized state management

---

## 🛡️ Privacy & Security

### Local-First Architecture
- All data stored locally on your device
- No cloud sync or external servers
- No account creation required
- No personal data collection
- Full control over your data

### Permissions
Required permissions explained:
- **Bluetooth**: Connect to UV sensor
- **Location**: Required by Android for BLE scanning
- **Storage**: Save UV readings and preferences

---

## 🧪 Quality & Testing

### Comprehensive Test Suite
- **Unit Tests**: Services, providers, models
- **Widget Tests**: UI components and interactions
- **Integration Tests**: End-to-end user flows
- **High Coverage**: Critical paths fully tested

### Tested Scenarios
- BLE connection and reconnection
- Data persistence and loading
- Quiz flow completion
- Settings changes
- Error handling
- Edge cases

---

## 🚀 Future Enhancements

Features planned for future releases:
- 📈 Data visualization with charts and graphs
- 📅 Weekly/monthly UV exposure reports
- 🌤️ Weather API integration for forecasts
- 📤 Export data to CSV
- 🔔 Push notifications for alerts
- 👥 Multiple user profiles
- 🌙 Dark mode support
- 🌍 Multi-language support

---

## Learn More

- [Getting Started](/getting-started/) - Install and set up the app
- [User Guide](/docs/user-guide/) - Detailed usage instructions
- [Developer Guide](/docs/developer-guide/) - Technical documentation
- [About](/about/) - Project background and goals

