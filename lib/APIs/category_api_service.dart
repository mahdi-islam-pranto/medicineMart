import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/category_models.dart';
import 'api_config.dart';

/// Category API Service
///
/// This service handles all category-related API calls including
/// fetching all available categories with proper error handling.
class CategoryApiService {
  /// Get all categories
  ///
  /// Fetches all available categories from the API.
  /// Returns a [CategoryResponse] with categories data.
  static Future<CategoryResponse> getAllCategories() async {
    try {
      print('🔄 Fetching categories from API: ${ApiConfig.categoryUrl}');
      
      // Make the HTTP GET request
      final response = await http
          .get(
            Uri.parse(ApiConfig.categoryUrl),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.requestTimeout);

      print('📡 Category API Response Status: ${response.statusCode}');
      print('📡 Category API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final categoryResponse = CategoryResponse.fromJson(jsonData);
        
        print('✅ Successfully parsed ${categoryResponse.categories.length} categories');
        return categoryResponse;
      } else {
        print('❌ Category API failed with status: ${response.statusCode}');
        return CategoryResponse.error(
          'Failed to load categories. Server returned ${response.statusCode}',
        );
      }
    } on SocketException {
      print('❌ Category API: No internet connection');
      return CategoryResponse.error(
        'No internet connection. Please check your network and try again.',
      );
    } on http.ClientException catch (e) {
      print('❌ Category API: Client error - $e');
      return CategoryResponse.error(
        'Network error occurred. Please try again.',
      );
    } on FormatException catch (e) {
      print('❌ Category API: JSON parsing error - $e');
      return CategoryResponse.error(
        'Invalid response format from server.',
      );
    } catch (e) {
      print('❌ Category API: Unexpected error - $e');
      return CategoryResponse.error(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Get category names only
  ///
  /// Convenience method to get just the category names as a list of strings.
  /// This is useful for filter dropdowns and similar UI components.
  static Future<List<String>> getCategoryNames() async {
    try {
      final response = await getAllCategories();
      if (response.success) {
        return response.categories.map((category) => category.name).toList();
      } else {
        print('❌ Failed to get category names: ${response.message}');
        return [];
      }
    } catch (e) {
      print('❌ Error getting category names: $e');
      return [];
    }
  }
}
