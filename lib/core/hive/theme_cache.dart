import 'package:hive/hive.dart';

class ThemeCache {
  static const String _boxName = 'settingsBox';
  static const String _themeKey = 'isDarkTheme';

  /// Save theme
  static Future<void> saveTheme(bool isDark) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_themeKey, isDark);
  }

  /// Load theme
  static Future<bool> getTheme() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_themeKey, defaultValue: false); // false = Light Theme
  }

  /// Clear theme
  static Future<void> clearTheme() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_themeKey);
  }
}
