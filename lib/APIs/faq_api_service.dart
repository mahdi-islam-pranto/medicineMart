import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/faq_models.dart';
import 'api_config.dart';

/// FAQ API Service
///
/// This service handles all FAQ-related API calls including
/// fetching frequently asked questions with proper error handling.
class FaqApiService {
  /// Get all FAQs
  ///
  /// Fetches all frequently asked questions from the API.
  /// Returns a [FaqResponse] with FAQ data.
  static Future<FaqResponse> getAllFaqs() async {
    try {
      print('🔄 Fetching FAQs from API: ${ApiConfig.faqUrl}');

      // Make the HTTP GET request
      final response = await http
          .get(
            Uri.parse(ApiConfig.faqUrl),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.requestTimeout);

      print('📡 FAQ API Response Status: ${response.statusCode}');

      // Parse the response
      final responseData = json.decode(response.body);
      print('📊 FAQ API Response Data: $responseData');

      if (response.statusCode == 200) {
        // Request successful
        final faqResponse = FaqResponse.fromJson(responseData);
        print('✅ Successfully fetched ${faqResponse.data.length} FAQs');
        return faqResponse;
      } else {
        // Request failed
        final errorMessage = responseData['message'] ??
            responseData['error'] ??
            'Failed to load FAQs. Please try again.';
        print('❌ FAQ API Error: $errorMessage');
        return FaqResponse.error(
          status: response.statusCode.toString(),
          message: errorMessage,
        );
      }
    } on SocketException catch (e) {
      print('🌐 FAQ API Network Error: $e');
      return FaqResponse.error(
        message:
            'No internet connection. Please check your network and try again.',
      );
    } on http.ClientException catch (e) {
      print('🔌 FAQ API Client Error: $e');
      return FaqResponse.error(
        message: 'Network error. Please try again.',
      );
    } on FormatException catch (e) {
      print('📝 FAQ API Format Error: $e');
      return FaqResponse.error(
        message: 'Invalid response from server. Please try again.',
      );
    } catch (e) {
      print('💥 FAQ API Unknown Error: $e');
      return FaqResponse.error(
        message: 'Failed to load FAQs. Please try again.',
      );
    }
  }
}
