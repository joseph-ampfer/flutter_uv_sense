---
marp: true
size: 4:3
paginate: true
title: HW2 – Grading Rubric (Individual Project)
---

# HW2 Grading (Individual Project) Rubric  

- Total: **25 points**  
- Each assignment: **5 points**  
- No partial points (all-or-nothing per assignment)  
- This rubric is **only for individual projects**  

---

## 📘 Assignment 1 (5 pts)

> Notice!
>
> - It's critically important to understand the scope, requirements, and expectations of the projects.  
> - Students must visit me if anything is unclear or need help.  
> - Earning 5 points in this assignment means you understand how to start, make progress, and finalize the projects successfully.  

---

**Understand project success**

- [x] Downloaded individual project documents from Canvas  
- [x] Read and understood rubrics & requirements  
- [x] Reviewed GitHub PDFs (Projects + Requirements)  
- [x] Understood how to use Git/GitHub  
  - Visit me if you need help

**Points:** __5__ / 5  

---

## 📘 Assignment 2 (5 pts)

**Write requirements**

- [x] Decided AI option  
option 2
- [x] Defined features (problem, importance, solution)  
  - List features here:  
    1. UV Sensor Integration

      * Problem: Users lack accurate, real-time UV exposure data tailored to their location and activity.
      * Importance: Generic weather apps give rough UV indices, but not precise readings—especially with shade, clouds, and micro-environments. Personalized data helps prevent over/under exposure.
      * Solution: Use an ESP32 with UV sensor to gather real-time readings and connect to the Flutter app via Bluetooth/Wi-Fi.

    2. UV Tracking App

      * Problem: People don’t track their cumulative daily/weekly UV exposure.
      * Importance: Overexposure increases risk of skin cancer and aging, while underexposure leads to vitamin D deficiency.
      * Solution: Build a Flutter app that logs UV data, displays trends, and visualizes safe vs unsafe exposure ranges.

    3. User Sensitivity Quiz

      * Problem: UV tolerance varies by skin type, genetics, and lifestyle, but most apps give “one-size-fits-all” advice.
      * Importance: Personalized recommendations reduce risk and increase user trust in the app.
      * Solution: Create a short quiz to assess user’s UV sensitivity (based on dermatology research such as Fitzpatrick skin type).

    4. Recommendation Engine

      * Problem: Users need actionable advice, not just numbers.
      * Importance: Showing a UV index of “7” means little unless the user knows how to respond.
      * Solution: Build a recommendation table (time to stay outside, need for sunscreen, vitamin D goals, shade advice) based on quiz results + live sensor data.

    5. UI/UX Flow & Visualization

      * Problem: Poorly designed apps discourage usage and fail to deliver insights.
      * Importance: A clean interface ensures users actually use the app daily.
      * Solution: Sketch a flow (sensor connect → dashboard → quiz → recommendations → history logs). Build Flutter UI screens to support it.

---

- [x] Listed requirements to complete features  
  - List requirements here:  
    1. For UV Sensor Integration

      * ESP32 board + UV sensor module (e.g., VEML6075)
      * Microcontroller code to read sensor data and transmit
      * Flutter app side code for Bluetooth/Wi-Fi communication
      * Data format consistency (e.g., JSON)

    2. For UV Tracking App

      * Flutter app base with state management (e.g., Provider/Bloc)
      * Local database (SQLite or Hive) to store logs
      * Graphing/visualization package (charts\_flutter, fl\_chart)
      * Background service to auto-log readings

    3. For User Sensitivity Quiz

      * Research Fitzpatrick skin type and UV sensitivity questionnaires
      * Flutter quiz UI (forms, radio buttons, etc.)
      * Scoring algorithm to classify user type
      * Store results linked to user profile

    4. For Recommendation Engine

      * Build a recommendation table (matrix of skin type × UV index ranges)
      * Logic to merge sensor data + quiz results
      * Flutter logic to display advice dynamically
      * Handle edge cases (low UV, night, indoors)

    5. For UI/UX Flow & Visualization

      * Wireframe sketches for app flow
      * Flutter UI screens: login/intro → connect sensor → dashboard → quiz → recommendations → history
      * Consistent theme/colors for clarity
      * Testing with mock data before connecting sensor
- [x] Published on Canvas (individual project page)  
  - Link: [canvas](https://nku.instructure.com/courses/81929/pages/member-joe-ampfer-individual-project-page)  

**Points:** __5__ / 5  

---

### Your Individual Project Feature/Requirements Count

It is possible to change the features/requirements if you encounter “unknown unknowns,” with explanation.

1. Number of individual features: ( __5_ )  
2. Number of individual requirements: ( __20_ )  

---

### Your Individual Project Features

- What is the problem?  
UV radiation changes with shade, clouds, and time of day. This app will give you pinpoint precision and reccomendations.
- Why is it important?  
Many people care about their skin, and UV radiation is a huge factor. Some people don't get enough for vitamin D, leading to depression and low bone density. Others get too much sun, leading to wrinkles and cancer.
- How will you solve it (including the design)?  
I will build a Flutter app that connects to an ESP32 IoT UV sensor to provide real-time UV data. The app will:

Connect to the sensor via Bluetooth or Wi-Fi

Track and log daily/weekly UV exposure

Include a quiz to determine user UV sensitivity (based on skin type research)

Use a recommendation engine to suggest actions (safe exposure time, sunscreen, shade, vitamin D advice)

Present information with a clear UI flow: sensor connect → dashboard with live UV readings → sensitivity quiz → personalized recommendations → history log with graphs.

---

## 📘 Assignment 3 (5 pts)

**Make schedules**

- [x] Checked course & personal calendar  
- [x] Created milestones  

**Points:** __5__ / 5  

---

### Write your milestones

Make clear when you plan to implement requirements and finish milestones.

* Feature 1: UV Sensor Integration

  * Requirement 1.1: ESP32 board + UV sensor module setup

    * Plan: Week 1 — order/setup hardware, test sensor readings locally
  * Requirement 1.2: Microcontroller code to read sensor data and transmit

    * Plan: Week 2 — write/test ESP32 code, verify stable output
  * Requirement 1.3: Flutter app side code for Bluetooth/Wi-Fi communication

    * Plan: Week 3 — basic connection between app and ESP32
  * Requirement 1.4: Data format consistency (JSON)

    * Plan: Week 3 — finalize protocol, confirm app reads sensor data correctly

* Feature 2: UV Tracking App

  * Requirement 2.1: Flutter app base with state management

    * Plan: Week 2 — scaffold Flutter project, set up state management
  * Requirement 2.2: Local database (SQLite or Hive)

    * Plan: Week 3–4 — create local storage for logs
  * Requirement 2.3: Graphing/visualization package

    * Plan: Week 4 — implement simple graphs for UV history
  * Requirement 2.4: Background service to auto-log readings

    * Plan: Week 5 — schedule periodic sensor data logging

* Feature 3: User Sensitivity Quiz

  * Requirement 3.1: Research Fitzpatrick skin type and UV sensitivity questionnaires

    * Plan: Week 2 — gather research, finalize quiz questions
  * Requirement 3.2: Flutter quiz UI

    * Plan: Week 4 — implement quiz screens with radio buttons/forms
  * Requirement 3.3: Scoring algorithm to classify user type

    * Plan: Week 4 — add scoring logic
  * Requirement 3.4: Store results linked to user profile

    * Plan: Week 5 — save quiz results into database

* Feature 4: Recommendation Engine

  * Requirement 4.1: Build recommendation table (matrix of skin type × UV index ranges)

    * Plan: Week 5 — design table and rules
  * Requirement 4.2: Logic to merge sensor data + quiz results

    * Plan: Week 6 — connect real-time data to recommendation engine
  * Requirement 4.3: Flutter logic to display advice dynamically

    * Plan: Week 6 — render recommendations on dashboard
  * Requirement 4.4: Handle edge cases (low UV, night, indoors)

    * Plan: Week 7 — finalize polish and exception handling

* Feature 5: UI/UX Flow & Visualization

  * Requirement 5.1: Wireframe sketches for app flow

    * Plan: Week 1 — make paper/digital sketches
  * Requirement 5.2: Flutter UI screens (login → connect sensor → dashboard → quiz → recommendations → history)

    * Plan: Week 2–5 — implement screens incrementally
  * Requirement 5.3: Consistent theme/colors for clarity

    * Plan: Week 5 — apply design system/theme
  * Requirement 5.4: Testing with mock data before connecting sensor

    * Plan: Week 3–4 — mock data tests before integrating ESP32

---

If the schedule changes, update your Canvas page with:  

- Actual date finished:  
- Explanation of schedule slip:  

---

## 📘 Assignment 4 (5 pts)

**Prepare to report progress**

- [x] Ready to share progress on Canvas (individual project page)  
  - Link: [canvas](https://nku.instructure.com/courses/81929/pages/member-joe-ampfer-individual-project-page)  

**Points:** __5__ / 5  

---

## 📘 Assignment 5 (5 pts)

**Share work on GitHub**

- [x] Created project repository (new GitHub ID if needed)  
- [x] Understood GitHub, Markdown, Marp, Hugo  
- [x] Repo + GitHub.io site created  
  - Repo Link: [github](https://github.com/joseph-ampfer/flutter_uv_sense)  
  - GitHub.io Link: [io](https://joseph-ampfer.github.io/flutter_uv_sense/)  (It's OK to be empty in the beginning, but there should be a link)  

**Points:** __5__ / 5  

---

# 📊 Total Summary  

| Assignment            | Max Points | Earned Points |
|-----------------------|------------|---------------|
| 1. Understand success | 5          | __5__          |
| 2. Requirements       | 5          | __5__          |
| 3. Schedules          | 5          | __5__          |
| 4. Report progress    | 5          | __5__          |
| 5. GitHub             | 5          | __5__          |
| **Total**             | **25**     | **__25__**      |

---

## 📤 Submission  

Both team leaders and team members must upload this **individual project rubric** as part of the HW2 deliverable on Canvas.
