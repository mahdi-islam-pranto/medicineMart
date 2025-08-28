/// API Configuration for Online Medicine App
///
/// This file contains all API endpoints and configuration settings.
/// You can easily modify the base URL and endpoints here as needed.
class ApiConfig {
  // Base URL for the API
  static const String baseUrl = 'http://admin.modumadicenmart.com/api/';

  // Authentication endpoints
  static const String registerEndpoint = 'customers/create';
  static const String loginEndpoint = 'app/login';

  // Full URLs
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get loginUrl => '$baseUrl$loginEndpoint';

  // Request headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Request timeout duration
  static const Duration requestTimeout = Duration(seconds: 30);

  // Device ID for login (you can generate this dynamically if needed)
  static String get deviceId =>
      'flutter_app_${DateTime.now().millisecondsSinceEpoch}';
}
