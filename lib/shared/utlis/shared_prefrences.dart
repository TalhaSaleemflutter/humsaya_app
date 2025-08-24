import 'package:shared_preferences/shared_preferences.dart';

// Class to handle saving and getting data in SharedPreferences
class SharedPreferenceHelper {
  // Save a boolean value
  static Future<void> saveBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Get a boolean value (default to false if not found)
  static Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false; // Default to false if not found
  }

  // Save a string value
  static Future<void> saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Get a string value (default to empty string if not found)
  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  // Method to remove a specific key from SharedPreferences
  static Future<void> removeValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
