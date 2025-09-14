import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_item.dart';

/// Service for managing favorites in local storage using SharedPreferences
class FavoritesStorageService {
  static const String _favoritesKey = 'user_favorites';

  /// Save favorites to SharedPreferences
  static Future<bool> saveFavorites(List<FavoriteItem> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = favorites.map((item) => item.toJson()).toList();
      final favoritesString = json.encode(favoritesJson);
      
      print('💾 Saving ${favorites.length} favorites to SharedPreferences');
      return await prefs.setString(_favoritesKey, favoritesString);
    } catch (e) {
      print('❌ Error saving favorites: $e');
      return false;
    }
  }

  /// Load favorites from SharedPreferences
  static Future<List<FavoriteItem>> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesString = prefs.getString(_favoritesKey);
      
      if (favoritesString == null || favoritesString.isEmpty) {
        print('📂 No favorites found in SharedPreferences');
        return [];
      }

      final favoritesJson = json.decode(favoritesString) as List;
      final favorites = favoritesJson
          .map((json) => FavoriteItem.fromJson(json as Map<String, dynamic>))
          .toList();
      
      print('📂 Loaded ${favorites.length} favorites from SharedPreferences');
      return favorites;
    } catch (e) {
      print('❌ Error loading favorites: $e');
      return [];
    }
  }

  /// Add a single favorite item
  static Future<bool> addFavorite(FavoriteItem favorite) async {
    try {
      final currentFavorites = await loadFavorites();
      
      // Check if already exists
      if (currentFavorites.any((item) => item.id == favorite.id)) {
        print('⚠️ Favorite already exists: ${favorite.name}');
        return true; // Already exists, consider it successful
      }
      
      currentFavorites.add(favorite);
      return await saveFavorites(currentFavorites);
    } catch (e) {
      print('❌ Error adding favorite: $e');
      return false;
    }
  }

  /// Remove a favorite item by ID
  static Future<bool> removeFavorite(String medicineId) async {
    try {
      final currentFavorites = await loadFavorites();
      final initialCount = currentFavorites.length;
      
      currentFavorites.removeWhere((item) => item.id == medicineId);
      
      if (currentFavorites.length == initialCount) {
        print('⚠️ Favorite not found for removal: $medicineId');
        return true; // Not found, but consider it successful
      }
      
      return await saveFavorites(currentFavorites);
    } catch (e) {
      print('❌ Error removing favorite: $e');
      return false;
    }
  }

  /// Check if a medicine is in favorites
  static Future<bool> isFavorite(String medicineId) async {
    try {
      final favorites = await loadFavorites();
      return favorites.any((item) => item.id == medicineId);
    } catch (e) {
      print('❌ Error checking favorite status: $e');
      return false;
    }
  }

  /// Clear all favorites
  static Future<bool> clearAllFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('🗑️ Clearing all favorites from SharedPreferences');
      return await prefs.remove(_favoritesKey);
    } catch (e) {
      print('❌ Error clearing favorites: $e');
      return false;
    }
  }

  /// Get favorites count
  static Future<int> getFavoritesCount() async {
    try {
      final favorites = await loadFavorites();
      return favorites.length;
    } catch (e) {
      print('❌ Error getting favorites count: $e');
      return 0;
    }
  }
}
