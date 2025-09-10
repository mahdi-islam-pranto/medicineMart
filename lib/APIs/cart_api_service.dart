import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../models/cart_list_models.dart';

/// Cart API Service
///
/// This service handles all cart-related API calls including
/// adding products to cart, updating quantities, and removing items.
class CartApiService {
  /// Add product to cart or update quantity
  ///
  /// Takes product_id, customer_id, and quantity.
  /// If quantity is 0, it effectively removes the item from cart.
  /// Returns a [CartApiResponse] with success/failure status.
  static Future<CartApiResponse> addToCart({
    required int productId,
    required int customerId,
    required int quantity,
  }) async {
    try {
      print(
          '🛒 Adding to cart - Product: $productId, Customer: $customerId, Quantity: $quantity');

      // Prepare the request body according to API specification
      final requestBody = {
        'product_id': productId,
        'customer_id': customerId,
        'quantity': quantity,
      };

      print('🔄 Making API call to: ${ApiConfig.addToCartUrl}');
      print('📦 Request body: ${json.encode(requestBody)}');

      // Make the HTTP POST request
      final response = await http
          .post(
            Uri.parse(ApiConfig.addToCartUrl),
            headers: ApiConfig.headers,
            body: json.encode(requestBody),
          )
          .timeout(ApiConfig.requestTimeout);

      print('📡 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      // Parse the response
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Success response
        return CartApiResponse(
          success: true,
          message:
              responseData['message'] ?? 'Product added to cart successfully',
          statusCode: responseData['status'] ?? 200,
        );
      } else {
        // Error response
        return CartApiResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to add product to cart',
          statusCode: responseData['status'] ?? response.statusCode,
        );
      }
    } on SocketException {
      return const CartApiResponse(
        success: false,
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } on HttpException {
      return const CartApiResponse(
        success: false,
        message: 'Server error. Please try again later.',
        statusCode: 500,
      );
    } on FormatException {
      return const CartApiResponse(
        success: false,
        message: 'Invalid response from server. Please try again.',
        statusCode: 0,
      );
    } catch (e) {
      print('❌ Cart API Error: $e');
      return const CartApiResponse(
        success: false,
        message: 'Failed to add product to cart. Please try again.',
        statusCode: 0,
      );
    }
  }

  /// Update product quantity in cart
  ///
  /// Convenience method that calls addToCart with new quantity.
  static Future<CartApiResponse> updateQuantity({
    required int productId,
    required int customerId,
    required int quantity,
  }) async {
    return addToCart(
      productId: productId,
      customerId: customerId,
      quantity: quantity,
    );
  }

  /// Remove product from cart
  ///
  /// Convenience method that calls addToCart with quantity 0.
  static Future<CartApiResponse> removeFromCart({
    required int productId,
    required int customerId,
  }) async {
    return addToCart(
      productId: productId,
      customerId: customerId,
      quantity: 0,
    );
  }

  /// Get cart items list
  ///
  /// Fetches all items in the cart for a specific customer.
  /// Returns a [CartListResponse] with cart items and summary.
  static Future<CartListResponse> getCartItems({
    required int customerId,
  }) async {
    try {
      print('🛒 Fetching cart items for customer: $customerId');

      // Prepare the request body according to API specification
      final requestBody = {
        'customer_id': customerId.toString(),
      };

      print('🔄 Making API call to: ${ApiConfig.cartListUrl}');
      print('📦 Request body: ${json.encode(requestBody)}');

      // Make the HTTP POST request
      final response = await http
          .post(
            Uri.parse(ApiConfig.cartListUrl),
            headers: ApiConfig.headers,
            body: json.encode(requestBody),
          )
          .timeout(ApiConfig.requestTimeout);

      print('📡 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      // Parse the response
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Success response
        return CartListResponse.fromJson(responseData);
      } else {
        // Error response
        return CartListResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to load cart items',
        );
      }
    } on SocketException {
      return const CartListResponse(
        success: false,
        message: 'No internet connection. Please check your network.',
      );
    } on HttpException {
      return const CartListResponse(
        success: false,
        message: 'Server error. Please try again later.',
      );
    } on FormatException {
      return const CartListResponse(
        success: false,
        message: 'Invalid response from server. Please try again.',
      );
    } catch (e) {
      print('❌ Cart List API Error: $e');
      return const CartListResponse(
        success: false,
        message: 'Failed to load cart items. Please try again.',
      );
    }
  }
}

/// Response model for cart API operations
class CartApiResponse {
  final bool success;
  final String message;
  final int statusCode;

  const CartApiResponse({
    required this.success,
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'CartApiResponse(success: $success, message: $message, statusCode: $statusCode)';
  }
}
