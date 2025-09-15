* [ ] Defined features (problem, importance, solution)

1. UV Sensor Integration

   * [ ] Problem: Users lack accurate, real-time UV exposure data tailored to their location and activity
   * [ ] Importance: Generic weather apps give rough UV indices, but not precise readings—especially with shade, clouds, and micro-environments
   * [ ] Solution: Use an ESP32 with UV sensor to gather real-time readings and connect to the Flutter app via Bluetooth/Wi-Fi

2. UV Tracking App

   * [ ] Problem: People don’t track their cumulative daily/weekly UV exposure
   * [ ] Importance: Overexposure increases risk of skin cancer and aging, while underexposure leads to vitamin D deficiency
   * [ ] Solution: Build a Flutter app that logs UV data, displays trends, and visualizes safe vs unsafe exposure ranges

3. User Sensitivity Quiz

   * [ ] Problem: UV tolerance varies by skin type, genetics, and lifestyle, but most apps give “one-size-fits-all” advice
   * [ ] Importance: Personalized recommendations reduce risk and increase user trust in the app
   * [ ] Solution: Create a short quiz to assess user’s UV sensitivity (based on dermatology research such as Fitzpatrick skin type)

4. Recommendation Engine

   * [ ] Problem: Users need actionable advice, not just numbers
   * [ ] Importance: Showing a UV index of “7” means little unless the user knows how to respond
   * [ ] Solution: Build a recommendation table (time to stay outside, need for sunscreen, vitamin D goals, shade advice) based on quiz results + live sensor data

5. UI/UX Flow & Visualization

   * [ ] Problem: Poorly designed apps discourage usage and fail to deliver insights
   * [ ] Importance: A clean interface ensures users actually use the app daily
   * [ ] Solution: Sketch a flow (sensor connect → dashboard → quiz → recommendations → history logs). Build Flutter UI screens to support it

---

* [ ] Listed requirements to complete features

1. For UV Sensor Integration

   * [ ] ESP32 board + UV sensor module (e.g., VEML6075)
   * [ ] Microcontroller code to read sensor data and transmit
   * [ ] Flutter app side code for Bluetooth/Wi-Fi communication
   * [ ] Data format consistency (e.g., JSON)

2. For UV Tracking App

   * [ ] Flutter app base with state management (e.g., Provider/Bloc)
   * [ ] Local database (SQLite or Hive) to store logs
   * [ ] Graphing/visualization package (charts\_flutter, fl\_chart)
   * [ ] Background service to auto-log readings

3. For User Sensitivity Quiz

   * [ ] Research Fitzpatrick skin type and UV sensitivity questionnaires
   * [ ] Flutter quiz UI (forms, radio buttons, etc.)
   * [ ] Scoring algorithm to classify user type
   * [ ] Store results linked to user profile

4. For Recommendation Engine

   * [ ] Build a recommendation table (matrix of skin type × UV index ranges)
   * [ ] Logic to merge sensor data + quiz results
   * [ ] Flutter logic to display advice dynamically
   * [ ] Handle edge cases (low UV, night, indoors)

5. For UI/UX Flow & Visualization

   * [ ] Wireframe sketches for app flow
   * [ ] Flutter UI screens: login/intro → connect sensor → dashboard → quiz → recommendations → history
   * [ ] Consistent theme/colors for clarity
   * [ ] Testing with mock data before connecting sensor


