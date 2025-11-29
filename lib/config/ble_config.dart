// BLE Configuration Constants
// Update these values to match your ESP32 BLE setup

class BleConfig {
  // TODO: Update these UUIDs to match your ESP32 configuration
  // These are placeholder values using standard Environmental Sensing Service
  static const String serviceUUID = "df9ef566-2d76-4ba4-b592-14f76ec9f391";
  static const String characteristicUUID = "95b5cdfe-707e-452c-ac71-4915e02a7d71";
  
  // Device identification
  // The app will look for devices with names containing this string
  // Update this to match your ESP32 device name
  static const String deviceNameFilter = "UV Sense";
  
  // Reading configuration
  static const int samplingDurationSeconds = 3;
  static const int scanDurationSeconds = 4;
  
  // Connection settings
  static const int connectionTimeoutSeconds = 10;
  static const int maxReconnectAttempts = 3;
  
  // Storage keys
  static const String lastDeviceIdKey = "last_device_id";
  static const String lastDeviceNameKey = "last_device_name";
}

