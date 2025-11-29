import 'package:flutter/material.dart';

class UVReading {
  final String id;
  final double uvIndex;
  final DateTime timestamp;

  UVReading({
    required this.id,
    required this.uvIndex,
    required this.timestamp,
  });
}

enum BleConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

class Device {
  final String id;
  final String name;
  final int batteryLevel;
  final bool isConnected;
  final BleConnectionState connectionState;
  final int? signalStrength; // RSSI value

  Device({
    required this.id,
    required this.name,
    this.batteryLevel = 0,
    this.isConnected = false,
    this.connectionState = BleConnectionState.disconnected,
    this.signalStrength,
  });

  Device copyWith({
    String? id,
    String? name,
    int? batteryLevel,
    bool? isConnected,
    BleConnectionState? connectionState,
    int? signalStrength,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      isConnected: isConnected ?? this.isConnected,
      connectionState: connectionState ?? this.connectionState,
      signalStrength: signalStrength ?? this.signalStrength,
    );
  }
}

class SkinType {
  final String id;
  final String name;
  final String description;
  final Color color;
  final int burnTime;

  SkinType({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.burnTime,
  });
}

class UVRecommendation {
  final double uvIndex;
  final int safeExposure;
  final List<String> protection;

  UVRecommendation({
    required this.uvIndex,
    required this.safeExposure,
    required this.protection,
  });
}

class UVLevel {
  final String level;
  final Color color;
  
  UVLevel(this.level, this.color);
}

class QuizOption {
  final String text;
  final int value;

  QuizOption({
    required this.text,
    required this.value,
  });
}

class QuizQuestion {
  final int id;
  final String question;
  final String? description;
  final List<QuizOption> options;

  QuizQuestion({
    required this.id,
    required this.question,
    this.description,
    required this.options,
  });
}