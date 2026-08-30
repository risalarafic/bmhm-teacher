import 'package:flutter/material.dart';

class L10n {
  static const all = [
    Locale('en'),
    Locale('ar'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'ar':
        return '🇦🇪';
      case 'en':
      default:
        return '🇬🇧';
    }
  }
}
