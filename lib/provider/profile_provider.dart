import 'package:flutter/material.dart';

import '../auth_service/auth_service.dart';
import '../models/user.dart';
import '../utils/common_methods.dart';

class ProfileProvider extends ChangeNotifier {
  String name = '';
  String email = '';
  String image = '';

  Future<void> loadFromSession() async {
    final user = teacher ?? await getUserInfo();
    if (user == null) return;
    applyUser(user);
  }

  void applyUser(Teacher user) {
    name = user.name ?? '';
    email = user.email ?? '';
    image = user.image ?? '';
    notifyListeners();
  }

  void clear() {
    name = '';
    email = '';
    image = '';
    notifyListeners();
  }
}
