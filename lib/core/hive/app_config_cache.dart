import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrms/core/hive/user_model.dart';

class AppConfigCache {
  static const String _userModelKey = 'user_model';

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
      print('AppConfigCache.getUserModel error: $e');
      return null;
    }
  }

  /// Clear all saved user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userModelKey);
  }
}
