import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _userKey = 'user_data';

  /// Save user data to SharedPreferences
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert any Timestamp/DateTime to String
    final cleanedData = {
      ...userData,
      if (userData['createdAt'] != null)
        'createdAt': userData['createdAt'] is String
            ? userData['createdAt']
            : userData['createdAt'].toDate().toIso8601String(),
    };

    await prefs.setString(_userKey, jsonEncode(cleanedData));
  }

  /// Get user data from SharedPreferences
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);

    if (jsonString == null) return null;

    final decoded = jsonDecode(jsonString);
    if (decoded['createdAt'] != null) {
      decoded['createdAt'] = DateTime.parse(decoded['createdAt']);
    }

    return decoded;
  }

  /// Remove user data on logout
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
