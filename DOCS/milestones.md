### Milestones

* [ ] Feature 1: UV Sensor Integration

  * [ ] Requirement 1.1: ESP32 board + UV sensor module setup

    * [ ] Plan: Week 1 — order/setup hardware, test sensor readings locally
  * [ ] Requirement 1.2: Microcontroller code to read sensor data and transmit

    * [ ] Plan: Week 2 — write/test ESP32 code, verify stable output
  * [ ] Requirement 1.3: Flutter app side code for Bluetooth/Wi-Fi communication

    * [ ] Plan: Week 3 — basic connection between app and ESP32
  * [ ] Requirement 1.4: Data format consistency (JSON)

    * [ ] Plan: Week 3 — finalize protocol, confirm app reads sensor data correctly

* [ ] Feature 2: UV Tracking App

  * [ ] Requirement 2.1: Flutter app base with state management

    * [ ] Plan: Week 2 — scaffold Flutter project, set up state management
  * [ ] Requirement 2.2: Local database (SQLite or Hive)

    * [ ] Plan: Week 3–4 — create local storage for logs
  * [ ] Requirement 2.3: Graphing/visualization package

    * [ ] Plan: Week 4 — implement simple graphs for UV history
  * [ ] Requirement 2.4: Background service to auto-log readings

    * [ ] Plan: Week 5 — schedule periodic sensor data logging

* [ ] Feature 3: User Sensitivity Quiz

  * [ ] Requirement 3.1: Research Fitzpatrick skin type and UV sensitivity questionnaires

    * [ ] Plan: Week 2 — gather research, finalize quiz questions
  * [ ] Requirement 3.2: Flutter quiz UI

    * [ ] Plan: Week 4 — implement quiz screens with radio buttons/forms
  * [ ] Requirement 3.3: Scoring algorithm to classify user type

    * [ ] Plan: Week 4 — add scoring logic
  * [ ] Requirement 3.4: Store results linked to user profile

    * [ ] Plan: Week 5 — save quiz results into database

* [ ] Feature 4: Recommendation Engine

  * [ ] Requirement 4.1: Build recommendation table (matrix of skin type × UV index ranges)

    * [ ] Plan: Week 5 — design table and rules
  * [ ] Requirement 4.2: Logic to merge sensor data + quiz results

    * [ ] Plan: Week 6 — connect real-time data to recommendation engine
  * [ ] Requirement 4.3: Flutter logic to display advice dynamically

    * [ ] Plan: Week 6 — render recommendations on dashboard
  * [ ] Requirement 4.4: Handle edge cases (low UV, night, indoors)

    * [ ] Plan: Week 7 — finalize polish and exception handling

* [ ] Feature 5: UI/UX Flow & Visualization

  * [ ] Requirement 5.1: Wireframe sketches for app flow

    * [ ] Plan: Week 1 — make paper/digital sketches
  * [ ] Requirement 5.2: Flutter UI screens (login → connect sensor → dashboard → quiz → recommendations → history)

    * [ ] Plan: Week 2–5 — implement screens incrementally
  * [ ] Requirement 5.3: Consistent theme/colors for clarity

    * [ ] Plan: Week 5 — apply design system/theme
  * [ ] Requirement 5.4: Testing with mock data before connecting sensor

    * [ ] Plan: Week 3–4 — mock data tests before integrating ESP32

