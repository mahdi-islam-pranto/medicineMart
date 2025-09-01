import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/brand_models.dart';
import 'api_config.dart';

/// Brand API Service
///
/// This service handles all brand-related API calls including
/// fetching all available brands/companies with proper error handling.
class BrandApiService {
  /// Get all brands/companies
  ///
  /// Fetches all available brands from the API.
  /// Returns a [BrandResponse] with brands data.
  static Future<BrandResponse> getAllBrands() async {
    try {
      print('🔄 Fetching brands from API: ${ApiConfig.brandUrl}');
      
      // Make the HTTP GET request
      final response = await http
          .get(
            Uri.parse(ApiConfig.brandUrl),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.requestTimeout);

      print('📡 Brand API Response Status: ${response.statusCode}');
      
      // Parse the response
      final responseData = json.decode(response.body);
      print('📊 Brand API Response Data: $responseData');

      if (response.statusCode == 200) {
        // Request successful
        final brandResponse = BrandResponse.fromJson(responseData);
        print('✅ Successfully fetched ${brandResponse.data.length} brands');
        return brandResponse;
      } else {
        // Request failed
        final errorMessage = responseData['message'] ??
            responseData['error'] ??
            'Failed to load brands. Please try again.';
        print('❌ Brand API Error: $errorMessage');
        return BrandResponse(
          status: response.statusCode.toString(),
          message: errorMessage,
          data: const [],
        );
      }
    } on SocketException catch (e) {
      print('🌐 Brand API Network Error: $e');
      return const BrandResponse(
        status: 'error',
        message: 'No internet connection. Please check your network and try again.',
        data: [],
      );
    } on http.ClientException catch (e) {
      print('🔌 Brand API Client Error: $e');
      return const BrandResponse(
        status: 'error',
        message: 'Network error. Please try again.',
        data: [],
      );
    } on FormatException catch (e) {
      print('📝 Brand API Format Error: $e');
      return const BrandResponse(
        status: 'error',
        message: 'Invalid response from server. Please try again.',
        data: [],
      );
    } catch (e) {
      print('💥 Brand API Unknown Error: $e');
      return const BrandResponse(
        status: 'error',
        message: 'Failed to load brands. Please try again.',
        data: [],
      );
    }
  }

  /// Get brand names only
  ///
  /// Convenience method to get just the brand names as a list of strings.
  static Future<List<String>> getBrandNames() async {
    final response = await getAllBrands();
    if (response.isSuccess) {
      return response.data.map((brand) => brand.name).toList();
    }
    return [];
  }
}
