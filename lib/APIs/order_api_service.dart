import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../models/order_models.dart';

/// Order API Service
///
/// This service handles all order-related API calls including
/// creating orders/invoices with proper error handling and response parsing.
class OrderApiService {
  /// Create order/invoice
  ///
  /// Takes an [OrderRequest] and sends it to the invoice creation endpoint.
  /// Returns an [OrderResponse] with success/failure status and order data.
  static Future<OrderResponse> createOrder(OrderRequest request) async {
    try {
      print('📦 Creating order for customer: ${request.customerId}');
      print('🛒 Order items: ${request.items.length}');
      print('💰 Total amount: ${request.totalAmount}');

      // Prepare the request body according to API specification
      final requestBody = request.toJson();

      print('🔄 Making API call to: ${ApiConfig.createOrderUrl}');
      print('📦 Request body: ${json.encode(requestBody)}');

      // Make the HTTP POST request
      final response = await http
          .post(
            Uri.parse(ApiConfig.createOrderUrl),
            headers: ApiConfig.headers,
            body: json.encode(requestBody),
          )
          .timeout(ApiConfig.requestTimeout);

      print('📡 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      // Parse the response
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Check if the API response indicates success
        final status = responseData['status']?.toString() ?? '';
        if (status == '200') {
          // Success response - parse order data
          final orderData =
              CheckoutOrderData.fromJson(responseData['data'] ?? {});

          return OrderResponse.success(
            message: responseData['message'] ?? 'Order placed successfully',
            data: orderData,
            statusCode: int.tryParse(status) ?? 200,
          );
        } else {
          // API returned error status
          return OrderResponse.error(
            message: responseData['message'] ?? 'Failed to create order',
            statusCode: int.tryParse(status) ?? 400,
          );
        }
      } else {
        // HTTP error response
        return OrderResponse.error(
          message: responseData['message'] ?? 'Failed to create order',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return OrderResponse.error(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } on http.ClientException {
      return OrderResponse.error(
        message: 'Network error. Please try again.',
        statusCode: 0,
      );
    } on FormatException {
      return OrderResponse.error(
        message: 'Invalid response format from server.',
        statusCode: 0,
      );
    } catch (e) {
      print('❌ Order creation error: $e');
      return OrderResponse.error(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
}
