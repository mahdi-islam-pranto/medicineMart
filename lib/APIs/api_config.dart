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

  // Product endpoints
  static const String productsSearchEndpoint = 'products/search';

  // Brand endpoints
  static const String brandEndpoint = 'brand';

  // Cart endpoints
  static const String addToCartEndpoint = 'product/add/to/cart';
  static const String cartListEndpoint = 'product/add/to/cart/list';

  // Order endpoints
  static const String createOrderEndpoint = 'invoice/create';
  static const String orderListEndpoint = 'order/list';

  // FAQ endpoints
  static const String faqEndpoint = 'faq';

  // Full URLs
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get productsSearchUrl => '$baseUrl$productsSearchEndpoint';
  static String get brandUrl => '$baseUrl$brandEndpoint';
  static String get addToCartUrl => '$baseUrl$addToCartEndpoint';
  static String get cartListUrl => '$baseUrl$cartListEndpoint';
  static String get createOrderUrl => '$baseUrl$createOrderEndpoint';
  static String get orderListUrl => '$baseUrl$orderListEndpoint';
  static String get faqUrl => '$baseUrl$faqEndpoint';

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
