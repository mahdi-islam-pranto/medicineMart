import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/app_settings_models.dart';
import 'api_config.dart';

/// App Settings API Service
///
/// This service handles fetching app settings from the API.
/// App settings include app name, contact info, version, and other configurable data.
class AppSettingsApiService {
  /// Get app settings
  ///
  /// Fetches app settings from the API.
  /// Returns an [AppSettingsResponse] with settings data.
  static Future<AppSettingsResponse> getAppSettings() async {
    try {
      print('🔄 Fetching app settings from API: ${ApiConfig.appSettingsUrl}');

      // Make the HTTP GET request
      final response = await http
          .get(
            Uri.parse(ApiConfig.appSettingsUrl),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.requestTimeout);

      print('📡 App Settings API Response Status: ${response.statusCode}');
      print('📡 App Settings API Response Body: ${response.body}');

      // Parse the response
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Success - parse the app settings response
        final settingsResponse = AppSettingsResponse.fromJson(responseData);
        
        if (settingsResponse.success && settingsResponse.data != null) {
          print('✅ App settings fetched successfully');
          print('📱 App Name: ${settingsResponse.data!.appName}');
          print('📧 Email: ${settingsResponse.data!.email}');
          print('📞 Phone: ${settingsResponse.data!.number}');
          print('🔢 Version: ${settingsResponse.data!.appVersion}');
          return settingsResponse;
        } else {
          print('❌ App settings API returned error: ${settingsResponse.message}');
          return AppSettingsResponse.error(
            settingsResponse.error ?? 'Failed to fetch app settings'
          );
        }
      } else {
        // HTTP error
        final errorMessage = responseData['message'] ?? 
                           responseData['error'] ?? 
                           'Failed to fetch app settings';
        print('❌ App Settings API HTTP Error: $errorMessage');
        return AppSettingsResponse.error(errorMessage);
      }
    } on SocketException {
      print('❌ App Settings API: No internet connection');
      return AppSettingsResponse.error(
        'No internet connection. Please check your network and try again.'
      );
    } on http.ClientException {
      print('❌ App Settings API: Network error');
      return AppSettingsResponse.error('Network error. Please try again.');
    } on FormatException catch (e) {
      print('❌ App Settings API: Invalid JSON response - $e');
      return AppSettingsResponse.error(
        'Invalid response from server. Please try again.'
      );
    } catch (e) {
      print('❌ App Settings API: Unexpected error - $e');
      return AppSettingsResponse.error('Failed to fetch app settings. Please try again.');
    }
  }
}
