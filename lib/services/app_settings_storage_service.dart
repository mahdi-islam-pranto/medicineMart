import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings_models.dart';

/// Service for managing app settings in local storage using SharedPreferences
///
/// This service handles:
/// - Saving app settings to SharedPreferences after login
/// - Loading app settings from SharedPreferences
/// - Providing fallback values when settings are not available
/// - Clearing settings on logout
class AppSettingsStorageService {
  static const String _appSettingsKey = 'app_settings';

  /// Save app settings to SharedPreferences
  static Future<bool> saveAppSettings(AppSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(settings.toJson());
      
      print('💾 Saving app settings to SharedPreferences');
      print('📱 App Name: ${settings.appName}');
      print('📧 Email: ${settings.email}');
      print('📞 Phone: ${settings.number}');
      print('🔢 Version: ${settings.appVersion}');
      
      return await prefs.setString(_appSettingsKey, settingsJson);
    } catch (e) {
      print('❌ Error saving app settings: $e');
      return false;
    }
  }

  /// Load app settings from SharedPreferences
  static Future<AppSettings?> loadAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsString = prefs.getString(_appSettingsKey);
      
      if (settingsString == null || settingsString.isEmpty) {
        print('📂 No app settings found in SharedPreferences');
        return null;
      }

      final settingsJson = json.decode(settingsString) as Map<String, dynamic>;
      final settings = AppSettings.fromJson(settingsJson);
      
      print('📂 Loaded app settings from SharedPreferences');
      print('📱 App Name: ${settings.appName}');
      print('📧 Email: ${settings.email}');
      print('📞 Phone: ${settings.number}');
      print('🔢 Version: ${settings.appVersion}');
      
      return settings;
    } catch (e) {
      print('❌ Error loading app settings: $e');
      return null;
    }
  }

  /// Get app name from settings or fallback
  static Future<String> getAppName() async {
    try {
      final settings = await loadAppSettings();
      return settings?.appName ?? 'Health & Medicine';
    } catch (e) {
      print('❌ Error getting app name: $e');
      return 'Health & Medicine';
    }
  }

  /// Get email from settings or fallback
  static Future<String> getEmail() async {
    try {
      final settings = await loadAppSettings();
      return settings?.email ?? 'mmodumadicenmart@gmail.com';
    } catch (e) {
      print('❌ Error getting email: $e');
      return 'mmodumadicenmart@gmail.com';
    }
  }

  /// Get phone number from settings or fallback
  static Future<String> getPhoneNumber() async {
    try {
      final settings = await loadAppSettings();
      return settings?.number ?? '01746733817';
    } catch (e) {
      print('❌ Error getting phone number: $e');
      return '01746733817';
    }
  }

  /// Get app version from settings or fallback
  static Future<String> getAppVersion() async {
    try {
      final settings = await loadAppSettings();
      return settings?.appVersion ?? '1.0.0';
    } catch (e) {
      print('❌ Error getting app version: $e');
      return '1.0.0';
    }
  }

  /// Get domain URL from settings or fallback
  static Future<String> getDomainUrl() async {
    try {
      final settings = await loadAppSettings();
      return settings?.domainUrl ?? 'http://modumadicenmart.com';
    } catch (e) {
      print('❌ Error getting domain URL: $e');
      return 'http://modumadicenmart.com';
    }
  }

  /// Get app short description from settings or fallback
  static Future<String> getAppShortDescription() async {
    try {
      final settings = await loadAppSettings();
      return settings?.appShortDescription ?? 'Best Price & Quickly Service';
    } catch (e) {
      print('❌ Error getting app short description: $e');
      return 'Best Price & Quickly Service';
    }
  }

  /// Check if app settings exist in SharedPreferences
  static Future<bool> hasAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_appSettingsKey);
    } catch (e) {
      print('❌ Error checking app settings existence: $e');
      return false;
    }
  }

  /// Clear app settings from SharedPreferences
  static Future<bool> clearAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('🗑️ Clearing app settings from SharedPreferences');
      return await prefs.remove(_appSettingsKey);
    } catch (e) {
      print('❌ Error clearing app settings: $e');
      return false;
    }
  }

  /// Get all settings as a map for easy access
  static Future<Map<String, String>> getAllSettings() async {
    try {
      final settings = await loadAppSettings();
      if (settings == null) {
        return _getFallbackSettings();
      }
      
      return {
        'appName': settings.appName,
        'email': settings.email,
        'phoneNumber': settings.number,
        'appVersion': settings.appVersion,
        'domainUrl': settings.domainUrl,
        'appShortDescription': settings.appShortDescription,
      };
    } catch (e) {
      print('❌ Error getting all settings: $e');
      return _getFallbackSettings();
    }
  }

  /// Get fallback settings when API data is not available
  static Map<String, String> _getFallbackSettings() {
    return {
      'appName': 'Health & Medicine',
      'email': 'mmodumadicenmart@gmail.com',
      'phoneNumber': '01746733817',
      'appVersion': '1.0.0',
      'domainUrl': 'http://modumadicenmart.com',
      'appShortDescription': 'Best Price & Quickly Service',
    };
  }
}
