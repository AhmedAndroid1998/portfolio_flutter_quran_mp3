import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const _key = 'app_theme_color';

  static Future<void> saveColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_key, color.value);
  }

  static Future<Color> loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_key);
    return colorValue != null ? Color(colorValue) : Colors.indigoAccent;
  }
}
