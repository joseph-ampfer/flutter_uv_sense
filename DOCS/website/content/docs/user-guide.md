---
title: "User Guide"
description: "Complete guide to using the UV Monitor App"
weight: 1
---

# User Guide

Complete guide to using the UV Monitor App for safe and informed UV exposure management.

---

## Table of Contents

1. [First Launch](#first-launch)
2. [Connecting Your UV Sensor](#connecting-your-uv-sensor)
3. [Understanding the UV Monitor Screen](#understanding-the-uv-monitor-screen)
4. [Taking the Skin Type Quiz](#taking-the-skin-type-quiz)
5. [Personalized Recommendations](#personalized-recommendations)
6. [Setting UV Alerts](#setting-uv-alerts)
7. [Managing Settings](#managing-settings)
8. [Tips for Best Results](#tips-for-best-results)
9. [Troubleshooting](#troubleshooting)

---

## First Launch

When you first open the UV Monitor App, you'll see:

- **Main UV Monitor Dashboard** - The primary screen showing UV readings
- **Connect Device Button** - To pair with your UV sensor
- **Skin Type Quiz Option** - To personalize your experience
- **UV Reading History** - Empty at first, will populate with readings

### First Steps Recommendation

**💡 Tip:** Take the skin type quiz first for the best personalized experience!

1. Grant necessary permissions (Bluetooth, Location)
2. Take the skin type quiz
3. Connect your UV sensor
4. Start monitoring!

---

## Connecting Your UV Sensor

### Step 1: Enable Bluetooth

Before connecting, ensure:

1. ✅ Bluetooth is turned ON on your device
2. ✅ Location services are enabled (Android requirement for BLE)
3. ✅ The app has Bluetooth and Location permissions
4. ✅ Your UV sensor device is powered on and nearby

![Monitor Screen](/images/monitor_screen.png)

### Step 2: Scan for Devices

1. Tap the **"Connect Device"** button on the main screen
2. Tap **"Scan for Devices"**
3. Wait 5-10 seconds while the app searches
4. Your device will appear in the list (usually named "ESP32" or similar)

**Note:** The scan timeout is 10 seconds. If your device doesn't appear, try scanning again.

### Step 3: Pair Your Device

1. Tap on your device in the discovered devices list
2. Wait for the connection to establish (5-15 seconds)
3. Once connected, you'll see:
   - 🟢 Green connection indicator
   - Device name displayed
   - "Connected" status
4. UV readings will start streaming automatically!

### Troubleshooting Connection

**Device not appearing in scan?**
- Make sure your sensor is within 10 feet (3 meters)
- Verify the sensor is powered on and has battery
- Check that device name filter matches (default: "ESP32")
- Try moving to an area with less Bluetooth interference

**Connection keeps failing?**
- Turn Bluetooth off and on
- Restart the UV sensor device
- Restart the app
- Try "Forget device" in Bluetooth settings and re-pair

**Still having issues?**
- Ensure no other app is connected to the sensor
- Clear Bluetooth cache in phone settings
- Check sensor firmware is up to date

---

## Understanding the UV Monitor Screen

The main dashboard displays all essential information at a glance.

### Real-Time UV Display

**Large UV Index Number**
- Shows the current UV index reading
- Updates in real-time as sensor streams data
- Large, easy-to-read font

**Color-Coded Levels**
The app uses WHO (World Health Organization) standard color coding:

| UV Index | Level | Color | Meaning |
|----------|-------|-------|---------|
| 0-2 | Low | 🟢 Green | Minimal protection needed |
| 3-5 | Moderate | 🟡 Yellow | Use sunscreen |
| 6-7 | High | 🟠 Orange | Protection required |
| 8-10 | Very High | 🔴 Red | Extra protection needed |
| 11+ | Extreme | 🟣 Purple | Avoid sun exposure |

**Visual Indicators**
- Background color matches the UV level
- Level text (Low, Moderate, High, etc.)
- Icon showing sun intensity

### Recent Readings History

![Recent Readings](/images/recent_readings.png)

**Features:**
- View your last 50 UV readings
- Each reading shows:
  - UV index value
  - Color-coded level indicator
  - Timestamp (date and time)
  - Visual icon
- Scroll to see older readings
- Automatic persistence (data saved even when app closed)

**Using the History:**
- Track trends throughout the day
- Identify peak UV times
- Plan outdoor activities
- Review exposure patterns

---

## Taking the Skin Type Quiz

### Why Personalization Matters

UV tolerance varies greatly between individuals based on:

- 🧬 **Genetics and skin type** - Different melanin levels
- 👁️ **Eye and hair color** - Physical characteristics
- ☀️ **Tanning vs burning tendency** - Sun reaction
- ⏰ **Recent sun exposure** - Current adaptation level

**Generic advice doesn't work for everyone!** Personalized recommendations based on your specific skin type provide accurate safe exposure times and protection requirements.

### Starting the Quiz

![Quiz Start](/images/start_quiz.png)

1. Tap **"Take Skin Type Quiz"** on the main screen
2. Read the welcome screen explaining the process
3. Tap **"Find my skin type"** to begin
4. Answer all questions honestly for best results

### Quiz Questions

![Quiz Questions](/images/quiz_middle.png)

The quiz includes 11 questions covering:

**Physical Characteristics:**
- Eye color (light blue/gray/green to brownish black)
- Natural hair color (sandy red to black)
- Unexposed skin color (reddish to dark brown)
- Freckles on unexposed areas

**Sun Reactions:**
- What happens when you stay too long in sun (painful burns to never burns)
- Tanning ability (hardly at all to turns dark brown quickly)
- Tanning after several hours (never to always)
- Face sensitivity to sun

**Recent Exposure:**
- When you last exposed your body to sun
- How often you expose your face to sun

**Time Required:** Just 2-3 minutes!

### Understanding Your Results

![Quiz Results](/images/quiz_results.png)

After completing the quiz, you'll learn:

**Your Skin Type:**
1. **Very Fair** - Always burns, never tans (Burn time: 5 min)
2. **Fair** - Usually burns, tans minimally (Burn time: 10 min)
3. **Medium** - Sometimes burns, tans gradually (Burn time: 15 min)
4. **Olive** - Burns minimally, tans well (Burn time: 20 min)
5. **Brown** - Rarely burns, tans darkly (Burn time: 25 min)
6. **Dark** - Never burns, always tans (Burn time: 30 min)

**What This Means:**
- Your specific UV sensitivity level
- Base burn time at UV index of 1
- Personalized protection needs
- Safe exposure time calculations

**Retaking the Quiz:**
You can retake the quiz anytime if:
- You've tanned significantly
- Your routine has changed
- You want to verify your type
- You answered incorrectly before

---

## Personalized Recommendations

Based on your skin type and current UV level, the app provides actionable advice.

### How Recommendations Work

**Algorithm:**
1. Get current UV index from sensor
2. Retrieve your skin type profile
3. Calculate: `safe_time = base_recommendation × (your_burn_time / 20)`
4. Select appropriate protection advice
5. Display personalized recommendations

### Safe Exposure Times

The app tells you exactly how long you can safely be in the sun without protection.

**Example Calculations:**

**UV Index 3 (Moderate) + Medium Skin Type:**
- ✅ Safe for 30 minutes
- 🧴 Use SPF 15+ sunscreen
- 🕶️ Wear sunglasses on bright days
- 💡 Be cautious around reflective surfaces

**UV Index 6 (High) + Fair Skin Type:**
- ⚠️ Safe for 12-15 minutes
- 🧴 Use SPF 30 sunscreen
- 🌳 Seek shade during midday hours
- 👕 Wear hat and sunglasses
- 🧥 Cover up with clothing

**UV Index 9 (Very High) + Very Fair Skin Type:**
- 🚨 Safe for only 5 minutes
- 🧴 Use SPF 50+ sunscreen
- 🌳 Minimize sun exposure between 10 AM - 4 PM
- 🌳 Seek shade during midday
- 👕 Wear protective clothing and hat
- 🕶️ Wear UV-blocking sunglasses

**UV Index 11+ (Extreme) + Any Skin Type:**
- 🚫 Avoid sun exposure between 10 AM - 4 PM
- 🌳 Seek shade whenever possible
- 🧴 Use SPF 50+ sunscreen
- 👕 Wear protective clothing and wide-brimmed hat
- 🕶️ Wear UV-blocking sunglasses
- ⚠️ Extreme caution required

### Protection Advice

Recommendations include specific actions:

**Sunscreen:**
- SPF level recommendations (15, 30, or 50+)
- Application reminders
- Reapplication timing

**Timing:**
- Best times for sun exposure
- When to avoid sun (peak hours)
- Safe duration calculations

**Clothing & Accessories:**
- Protective clothing needs
- Hat recommendations
- Sunglasses (UV-blocking)

**Behavior:**
- Shade seeking advice
- Activity planning
- Indoor alternatives

---

## Setting UV Alerts

### Customize Your Threshold

Protect yourself with personalized UV alerts.

**How to Set:**
1. Tap the **Settings** icon (gear icon)
2. Find **UV Alert Threshold** slider
3. Adjust to your preferred level (0-15 UV index)
4. Default is UV Index 6.0
5. Setting is saved automatically

**When You'll Be Notified:**
- When current UV reading exceeds your threshold
- Visual alert on screen
- Warning color indication

### Recommended Thresholds by Skin Type

- **Very Fair Skin:** 3.0 (Moderate level)
- **Fair Skin:** 4.0-5.0 (Upper Moderate)
- **Medium Skin:** 6.0 (High level) - *Default*
- **Olive Skin:** 7.0 (Upper High)
- **Brown/Dark Skin:** 7.0-8.0 (Very High)

**💡 Tip:** Set lower thresholds if you burn easily, have sensitive skin, or take photosensitivity medications.

---

## Managing Settings

### Available Settings

**UV Alert Threshold**
- Customize when you receive warnings
- Slider from 0-15 UV index
- Saved automatically

**Device Connection**
- View connected device
- Disconnect current device
- Scan for new devices
- Connection status

**Skin Type**
- View current skin type
- Retake quiz option
- Update your profile

**Data Management**
- View number of stored readings
- Clear reading history
- Reset to defaults

### Your Data & Privacy

**Local Storage:**
- ✅ All readings stored on your device only
- ✅ No cloud sync or external servers
- ✅ No account creation required
- ✅ No personal data collection
- ✅ Full control over your data

**What's Stored:**
- UV readings with timestamps (last 50)
- Your skin type selection
- Alert threshold setting
- Last connected device ID

**Data Control:**
- Clear history anytime
- Uninstall removes all data
- No tracking or analytics

---

## Tips for Best Results

### Maximize App Effectiveness

**1. Keep Your Sensor Nearby**
- Maintain Bluetooth range (within 30 feet)
- Carry sensor during outdoor activities
- Ensure sensor has battery power
- Position sensor in open area (not covered)

**2. Update Your Skin Type**
- Retake quiz if you've tanned significantly
- Update after extended indoor/outdoor periods
- Reassess after seasonal changes
- Verify if you've changed medications

**3. Check Readings Regularly**
- UV changes throughout the day
- Peak times usually 10 AM - 4 PM
- Check before outdoor activities
- Monitor during extended exposure

**4. Act on Recommendations**
- Recommendations are personalized for YOU
- Follow SPF suggestions
- Respect safe exposure times
- Use protective measures

**5. Battery Management**
- Bluetooth connections use battery
- Disconnect when not actively monitoring
- Keep both devices charged
- Consider portable chargers for long outings

**6. Understand Your Environment**
- Shade reduces UV significantly
- Water/snow reflect UV (increase exposure)
- Clouds don't always block UV
- Altitude increases UV intensity

---

## Troubleshooting

### Common Issues & Solutions

#### Bluetooth & Connection

**Problem:** Can't find devices when scanning
- ✅ Enable Bluetooth on phone
- ✅ Enable Location services (Android requirement)
- ✅ Grant app permissions
- ✅ Ensure sensor is powered on
- ✅ Move closer to sensor (within 10 feet)
- ✅ Reduce Bluetooth interference

**Problem:** Connection drops frequently
- ✅ Keep sensor within range
- ✅ Check sensor battery level
- ✅ Reduce obstacles between devices
- ✅ Close other Bluetooth apps
- ✅ Restart both devices

**Problem:** "Connection Timeout" error
- ✅ Sensor may be connected to another device
- ✅ Restart sensor and try again
- ✅ Forget device in Bluetooth settings
- ✅ Re-scan and reconnect

#### App Behavior

**Problem:** App crashes on launch
- ✅ Ensure all permissions granted
- ✅ Update app to latest version
- ✅ Clear app cache
- ✅ Reinstall app
- ✅ Check OS version compatibility

**Problem:** Readings not updating
- ✅ Verify connection status (should be green)
- ✅ Check sensor is transmitting data
- ✅ Reconnect to device
- ✅ Restart app

**Problem:** History not saving
- ✅ Check device storage space
- ✅ App may need storage permission
- ✅ Try clearing old readings and restart

#### Quiz & Recommendations

**Problem:** Can't complete quiz
- ✅ Ensure you answer each question
- ✅ Wait for auto-advance (300ms)
- ✅ Try restarting quiz
- ✅ Check for app updates

**Problem:** Recommendations seem wrong
- ✅ Verify skin type is correct
- ✅ Retake quiz if unsure
- ✅ Check current UV reading accuracy
- ✅ Compare with other UV sources

---

## Need More Help?

**Additional Resources:**
- [Getting Started Guide](/getting-started/) - Setup and installation
- [Features Overview](/features/) - Detailed feature descriptions
- [Developer Documentation](/docs/developer-guide/) - Technical details
- [About Page](/about/) - Project background

**Contact:**
- Check with your instructor
- Review source code documentation
- Examine integration tests for examples

---

## Stay Safe! ☀️

### Key Takeaways

- 📱 **Connect** your UV sensor for real-time readings
- 🧪 **Personalize** with the skin type quiz
- 📊 **Monitor** your UV exposure throughout the day
- 🛡️ **Protect** by following recommendations
- ⚡ **Alert** yourself with custom thresholds

**Remember:** A little prevention goes a long way for healthy skin!

**Enjoy your safer sun experience!** 🌞

