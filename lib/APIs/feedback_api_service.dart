import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/feedback_models.dart';
import 'api_config.dart';

/// Feedback API Service
///
/// This service handles all feedback-related API calls including
/// submitting user feedback with proper error handling.
class FeedbackApiService {
  /// Submit feedback
  ///
  /// Takes a [FeedbackRequest] and sends it to the feedback endpoint.
  /// Returns a [FeedbackResponse] with success/failure status and feedback data.
  static Future<FeedbackResponse> submitFeedback(FeedbackRequest request) async {
    try {
      print('📝 Submitting feedback for customer: ${request.customerId}');
      print('⭐ Rating: ${request.overallRating}, Category: ${request.category}');
      
      // Prepare the request body according to API specification
      final requestBody = request.toJson();
      
      print('🔄 Making API call to: ${ApiConfig.feedbackUrl}');
      print('📦 Request body: ${json.encode(requestBody)}');

      // Make the HTTP POST request
      final response = await http
          .post(
            Uri.parse(ApiConfig.feedbackUrl),
            headers: ApiConfig.headers,
            body: json.encode(requestBody),
          )
          .timeout(ApiConfig.requestTimeout);

      print('📡 Feedback API Response Status: ${response.statusCode}');
      print('📄 Feedback API Response Body: ${response.body}');
      
      // Parse the response
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Request successful
        final feedbackResponse = FeedbackResponse.fromJson(responseData);
        print('✅ Feedback submitted successfully with ID: ${feedbackResponse.data?.id}');
        return feedbackResponse;
      } else {
        // Request failed
        final errorMessage = responseData['message'] ??
            responseData['error'] ??
            'Failed to submit feedback. Please try again.';
        print('❌ Feedback API Error: $errorMessage');
        return FeedbackResponse.error(
          status: response.statusCode,
          message: errorMessage,
        );
      }
    } on SocketException catch (e) {
      print('🌐 Feedback API Network Error: $e');
      return FeedbackResponse.error(
        message: 'No internet connection. Please check your network and try again.',
      );
    } on http.ClientException catch (e) {
      print('🔌 Feedback API Client Error: $e');
      return FeedbackResponse.error(
        message: 'Network error. Please try again.',
      );
    } on FormatException catch (e) {
      print('📝 Feedback API Format Error: $e');
      return FeedbackResponse.error(
        message: 'Invalid response from server. Please try again.',
      );
    } catch (e) {
      print('💥 Feedback API Unknown Error: $e');
      return FeedbackResponse.error(
        message: 'Failed to submit feedback. Please try again.',
      );
    }
  }
}
