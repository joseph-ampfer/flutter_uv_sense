import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/data_models.dart';

class StorageService {
  static const String _readingsKey = 'uv_readings';
  static const String _alertThresholdKey = 'uv_alert_threshold';

  // Save UV readings to local storage
  Future<void> saveReadings(List<UVReading> readings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = readings.map((reading) => reading.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_readingsKey, jsonString);
    } catch (e) {
      print('Error saving readings: $e');
    }
  }

  // Load UV readings from local storage
  Future<List<UVReading>> loadReadings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_readingsKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => UVReading.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading readings: $e');
      return [];
    }
  }

  // Save UV alert threshold
  Future<void> saveAlertThreshold(double threshold) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_alertThresholdKey, threshold);
    } catch (e) {
      print('Error saving alert threshold: $e');
    }
  }

  // Load UV alert threshold (returns default 6.0 if not found)
  Future<double> loadAlertThreshold() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_alertThresholdKey) ?? 6.0;
    } catch (e) {
      print('Error loading alert threshold: $e');
      return 6.0;
    }
  }
}

