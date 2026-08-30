import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/common_methods.dart';

const userKey = 'Teacher';
const authTokenKey = 'auth_token';
const usernameKey = 'username';
const shiftKey = 'shift';
const introPageKey = 'intro';
const locKey = 'location';
const companyKey = 'company';

Future<void> saveIntro(String intro) async {
  final prefs = await SharedPreferences.getInstance();
  final result = await prefs.setString(introPageKey, intro);
  debugPrint('saved intro $result $intro');
}

Future<void> saveUserInfo(Teacher user) async {
  final prefs = await SharedPreferences.getInstance();
  final result = await prefs.setString(userKey, jsonEncode(user.toJson()));
  if (user.token != null && user.token!.isNotEmpty) {
    await prefs.setString(authTokenKey, user.token!);
    kToken = user.token;
  }
  final loginName = user.email ?? user.username;
  if (loginName != null && loginName.isNotEmpty) {
    await prefs.setString(usernameKey, loginName);
  }
  if (user.shift != null) {
    await prefs.setInt(shiftKey, user.shift!);
  }
  teacher = user;
  debugPrint('saved user $result');
}

Future<void> saveCompanyInfo(int companyId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(companyKey, companyId);
}

Future<void> saveLocationInSp({
  required double lat,
  required double lng,
  int id = 0,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    locKey,
    jsonEncode({'id': id, 'lat': lat, 'lng': lng}),
  );
}

Future<int?> getCompany() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(companyKey);
}

Future<Map<String, dynamic>?> getLoc() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString(locKey);
  if (data == null) return null;
  return jsonDecode(data) as Map<String, dynamic>;
}

Future<String?> getIntro() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(introPageKey);
}

Future<Teacher?> getUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final userData = prefs.getString(userKey);
  if (userData == null) return null;
  teacher = Teacher.fromJson(jsonDecode(userData) as Map<String, dynamic>);
  kToken = teacher?.token ?? prefs.getString(authTokenKey);
  return teacher;
}

Future<Map<String, dynamic>> teacherApiBody() async {
  final user = teacher ?? await getUserInfo();
  final prefs = await SharedPreferences.getInstance();
  final username = user?.email ??
      user?.username ??
      prefs.getString(usernameKey) ??
      '';
  final token = user?.token ?? kToken ?? prefs.getString(authTokenKey) ?? '';
  final hrid = user?.displayId ?? user?.hrid ?? user?.id;
  final shift = user?.shift ?? prefs.getInt(shiftKey);
  return {
    'hrid': '${hrid ?? ''}',
    'username': username,
    'auth_token': token,
    'shift': '${shift ?? 1}',
  };
}

Future<void> clearPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final introData = prefs.getString(introPageKey);
  teacher = null;
  kToken = null;
  await prefs.clear();
  if (introData != null) {
    await prefs.setString(introPageKey, introData);
  }
}
