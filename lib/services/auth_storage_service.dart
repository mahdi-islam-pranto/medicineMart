import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Service for managing authentication data in local storage
///
/// This service provides helper methods to:
/// - Get the logged-in user's customer ID
/// - Get the logged-in user's data
/// - Check if user is logged in
class AuthStorageService {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  /// Get the logged-in user's customer ID
  /// Returns null if no user is logged in
  static Future<int?> getCustomerId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson == null || userJson.isEmpty) {
        print('⚠️ No user data found in SharedPreferences');
        return null;
      }

      final userData = json.decode(userJson) as Map<String, dynamic>;
      final userId = userData['id'];
      
      if (userId == null) {
        print('⚠️ User ID is null in stored user data');
        return null;
      }

      // Parse the ID to int
      final customerId = int.tryParse(userId.toString());
      
      if (customerId == null) {
        print('⚠️ Failed to parse user ID to int: $userId');
        return null;
      }

      print('✅ Retrieved customer ID: $customerId');
      return customerId;
    } catch (e) {
      print('❌ Error getting customer ID: $e');
      return null;
    }
  }

  /// Get the logged-in user's data
  /// Returns null if no user is logged in
  static Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson == null || userJson.isEmpty) {
        print('⚠️ No user data found in SharedPreferences');
        return null;
      }

      final user = User.fromJson(json.decode(userJson));
      print('✅ Retrieved user: ${user.fullName} (ID: ${user.id})');
      return user;
    } catch (e) {
      print('❌ Error getting user: $e');
      return null;
    }
  }

  /// Get the authentication token
  /// Returns null if no token is stored
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      
      if (token == null || token.isEmpty) {
        print('⚠️ No auth token found in SharedPreferences');
        return null;
      }

      return token;
    } catch (e) {
      print('❌ Error getting auth token: $e');
      return null;
    }
  }

  /// Check if a user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      return userJson != null && userJson.isNotEmpty;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  /// Get customer ID with a fallback value for development
  /// This should only be used during development/testing
  /// In production, always handle null customer ID appropriately
  @Deprecated('Use getCustomerId() and handle null properly instead')
  static Future<int> getCustomerIdOrDefault([int defaultId = 1]) async {
    final customerId = await getCustomerId();
    if (customerId == null) {
      print('⚠️ No customer ID found, using default: $defaultId');
      return defaultId;
    }
    return customerId;
  }
}

