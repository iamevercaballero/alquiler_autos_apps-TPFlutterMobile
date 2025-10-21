import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPrefs {
  static Future<void> saveJson(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value));
  }

  static Future<List<dynamic>> readJsonList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(key);
    if (s == null) return [];
    return jsonDecode(s) as List<dynamic>;
  }
}
