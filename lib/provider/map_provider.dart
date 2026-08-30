import 'package:flutter/material.dart';

class MapProvider extends ChangeNotifier {
  double? latitude;
  double? longitude;

  void updateLocation(double lat, double lng) {
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }

  void clear() {
    latitude = null;
    longitude = null;
    notifyListeners();
  }
}
