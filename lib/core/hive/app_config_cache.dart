import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrms/core/hive/user_model.dart';

class AppConfigCache {
  static const String _userModelKey = 'user_model';
  static const String _locationPermissionKey = 'location_permission';
  static const String _onBoarding = 'boarding_data';

  /// Save UserModel to SharedPreferences
  static Future<void> saveUserModel(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString(_userModelKey, jsonString);
  }

  /// Get UserModel from SharedPreferences
  static Future<UserModel?> getUserModel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_userModelKey);

      if (jsonString == null) return null;

      final Map<String, dynamic> data = jsonDecode(jsonString);
      return UserModel.fromJson(data);
    } catch (e) {
      debugPrint('AppConfigCache.getUserModel error: $e');
      return null;
    }
  }

  /// SAVE Location Permission Flag
  static Future<void> saveOnBoarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onBoarding, value);
  }

  static Future<bool> getOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onBoarding) ?? false;
  }
  /// --------------------------------------------------------
  /// SAVE Location Permission Flag
  /// --------------------------------------------------------
  static Future<void> saveLocationPermissionStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationPermissionKey, value);
  }

  /// --------------------------------------------------------
  /// GET Location Permission Flag
  /// --------------------------------------------------------
  static Future<bool> isLocationPermissionGiven() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_locationPermissionKey) ?? false;
  }

  /// --------------------------------------------------------
  /// CLEAR Location Permission Flag
  /// --------------------------------------------------------
  static Future<void> clearLocationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_locationPermissionKey);
  }
  /// Clear all saved user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userModelKey);
    await prefs.remove(_locationPermissionKey);
    await prefs.remove(_onBoarding);
  }
}
