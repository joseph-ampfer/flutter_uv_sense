---
marp: true
size: 16:9
paginate: true
title: Week 1 Report - UV Sense
theme: default
backgroundColor: white
---

# UV Sense
## Week 1 Individual Project Report

**Personalized UV Monitoring & Protection**

Cross-Platform Development - ASE456

---

# Project Scope

## 📊 **By the Numbers**

### **Features**
- **5** Core Features

### **Requirements** 
- **5** Core User Stories

---

# The Problem

## UV Exposure Challenges

- **Generic weather apps** provide rough UV indices, not precise readings
- **Micro-environments** (shade, clouds, location) aren't considered
- **Personal factors** (skin type, sensitivity) are ignored
- **Lack of tracking** cumulative daily/weekly exposure
- **No actionable advice** - just numbers without context

---

# Why This Matters

## Health Impact

**Too Little UV:**
- Vitamin D deficiency
- Depression and low bone density
- Seasonal mood disorders

**Too Much UV:**
- Skin cancer risk
- Premature aging and wrinkles
- Sunburns and skin damage

> **Personalized data helps prevent both over- and under-exposure**

---

# Feature 1: UV Sensor Integration

## Real-Time Precision

**Problem:** Users lack accurate, real-time UV data tailored to their specific environment

**Solution:** 
- ESP32 microcontroller + UV sensor (VEML6075)
- Bluetooth/Wi-Fi connectivity to Flutter app
- Real-time readings accounting for shade, clouds, and micro-environments

---

# Feature 2: UV Tracking App

## Exposure History & Trends

**Problem:** People don't track cumulative UV exposure over time

**Solution:**
- Flutter app with local database (SQLite/Hive)
- Daily/weekly exposure logging
- Trend visualization with charts
- Safe vs unsafe exposure range indicators

---

# Feature 3: User Sensitivity Quiz

## Personalized Recommendations

**Problem:** UV tolerance varies by skin type, but most apps give generic advice

**Solution:**
- Quiz based on Fitzpatrick skin type research
- Assessment of user's UV sensitivity profile
- Personalized recommendations tailored to individual needs

---

# Feature 4: Recommendation Engine

## Actionable Guidance

**Problem:** Users need actionable advice, not just numbers

**Solution:**
- Recommendation matrix (skin type × UV index ranges)
- Specific guidance: safe exposure time, sunscreen needs, shade advice
- Vitamin D optimization recommendations
- Real-time decision support

---

# Feature 5: UI/UX Flow & Visualization

## Intuitive User Experience

**Problem:** Poorly designed apps discourage daily usage

**Solution:**
- Clean, intuitive interface design
- Clear data visualizations and charts
- Smooth user flow: connect → dashboard → quiz → recommendations → history
- Consistent theme and user-friendly interactions

---

# Technical Implementation

## Development Stack

### Hardware
- **ESP32** microcontroller board
- **VEML6075** UV sensor module
- Bluetooth/Wi-Fi communication

### Software
- **Flutter** cross-platform app
- **State management** (Provider/Bloc)
- **Local storage** (SQLite/Hive)
- **Visualization** (fl_chart, charts_flutter)
- **Background services** for auto-logging

---

# Solution Architecture

## App Flow Design

```
Sensor Connect → Live Dashboard → Sensitivity Quiz → 
Personalized Recommendations → Historical Data & Trends
```

### Key Components:
- Real-time sensor data collection
- User profile and sensitivity assessment
- Dynamic recommendation generation
- Historical tracking and visualization
- Cross-platform mobile interface

---

# User Stories & Requirements

## Core User Needs

1. **Real-time data:** Connect to UV sensor for location-specific readings
2. **Exposure tracking:** Monitor daily/weekly UV exposure patterns  
3. **Personal assessment:** Complete sensitivity quiz for tailored advice
4. **Actionable guidance:** Receive specific recommendations based on current conditions
5. **Intuitive interface:** Easy-to-use app with clear visualizations

---

# Next Steps

## Week 2 Development Plan

- [ ] Set up Flutter development environment
- [ ] Create basic app structure and navigation
- [ ] Design UI mockups and wireframes
- [ ] Research ESP32 and sensor integration
- [ ] Begin implementing core features

**Goal:** Working prototype with mock data by end of Week 2