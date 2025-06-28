import 'package:flutter/services.dart';

class BleAdvertisingService {
  static const MethodChannel _channel = MethodChannel('com.beykoz.beykoz/ble_advertise');

  static Future<void> startAdvertising(String sessionCode) async {
    await _channel.invokeMethod('startAdvertising', {'sessionCode': sessionCode});
  }

  static Future<void> stopAdvertising() async {
    await _channel.invokeMethod('stopAdvertising');
  }
} 