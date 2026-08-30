import 'package:flutter/material.dart';

class PushNotification {
  static bool _initialized = false;

  Future<String?> initialize() async {
    if (_initialized) return null;
    _initialized = true;
    debugPrint('PushNotification ready — wire Firebase when credentials exist.');
    return null;
  }
}
