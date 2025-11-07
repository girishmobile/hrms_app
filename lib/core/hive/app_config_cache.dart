import 'package:hive/hive.dart';
import 'package:hrms/core/hive/user_model.dart';

class AppConfigCache {
  static const String _boxName = 'app_config_box';
  static const String _userModelKey = 'user_model';

  static Box get _box => Hive.box(_boxName);

  /// Save UserModel to Hive
  static Future<void> saveUserModel(UserModel user) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_userModelKey, user.toJson());
  }

  /// Get UserModel from Hive
  static Future<UserModel?> getUserModel() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_userModelKey);
      if (data == null) return null;

      // ✅ Safely cast nested map
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      // If Hive isn't initialized or opening the box fails, treat as no user cached
      print('AppConfigCache.getUserModel error: $e');
      return null;
    }
  }

  /// Clear all saved user data
  static Future<void> clearUserData() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_userModelKey);
  }
}
