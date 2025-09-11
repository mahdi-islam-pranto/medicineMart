import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../models/order_list_models.dart';

/// Order List API Service
///
/// This service handles all order list related API calls including
/// fetching orders with filters and pagination.
class OrderListApiService {
  /// Get orders list
  ///
  /// Takes an [OrderListRequest] and sends it to the order list endpoint.
  /// Returns an [OrderListResponse] with orders data and pagination info.
  static Future<OrderListResponse> getOrders(OrderListRequest request) async {
    try {
      print('📋 Fetching orders for customer: ${request.customerId}');
      print('🔍 Status filter: ${request.status}');
      print('📄 Page: ${request.page}, Limit: ${request.limit}');

      // Prepare the request body according to API specification
      final requestBody = request.toJson();

      print('🔄 Making API call to: ${ApiConfig.orderListUrl}');
      print('📦 Request body: ${json.encode(requestBody)}');

      // Make the HTTP POST request
      final response = await http
          .post(
            Uri.parse(ApiConfig.orderListUrl),
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
          // Success response - parse order list data
          final orderListData = OrderListData.fromJson(responseData['data'] ?? {});
          
          return OrderListResponse.success(
            message: responseData['message'] ?? 'Orders retrieved successfully',
            data: orderListData,
            statusCode: int.tryParse(status) ?? 200,
          );
        } else {
          // API returned error status
          return OrderListResponse.error(
            message: responseData['message'] ?? 'Failed to fetch orders',
            statusCode: int.tryParse(status) ?? 400,
          );
        }
      } else {
        // HTTP error response
        return OrderListResponse.error(
          message: responseData['message'] ?? 'Failed to fetch orders',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return OrderListResponse.error(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } on http.ClientException {
      return OrderListResponse.error(
        message: 'Network error. Please try again.',
        statusCode: 0,
      );
    } on FormatException {
      return OrderListResponse.error(
        message: 'Invalid response format from server.',
        statusCode: 0,
      );
    } catch (e) {
      print('❌ Order list fetch error: $e');
      return OrderListResponse.error(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Get orders by status
  ///
  /// Convenience method to fetch orders filtered by status.
  /// Status mapping: 'all', '1' (pending), '2' (delivered), '3' (cancelled)
  static Future<OrderListResponse> getOrdersByStatus({
    required int customerId,
    required String status,
    int page = 1,
    int limit = 20,
  }) async {
    final request = OrderListRequest(
      customerId: customerId,
      status: status,
      page: page,
      limit: limit,
    );

    return getOrders(request);
  }

  /// Get all orders
  static Future<OrderListResponse> getAllOrders({
    required int customerId,
    int page = 1,
    int limit = 20,
  }) async {
    return getOrdersByStatus(
      customerId: customerId,
      status: 'all',
      page: page,
      limit: limit,
    );
  }

  /// Get pending orders
  static Future<OrderListResponse> getPendingOrders({
    required int customerId,
    int page = 1,
    int limit = 20,
  }) async {
    return getOrdersByStatus(
      customerId: customerId,
      status: '1',
      page: page,
      limit: limit,
    );
  }

  /// Get delivered orders
  static Future<OrderListResponse> getDeliveredOrders({
    required int customerId,
    int page = 1,
    int limit = 20,
  }) async {
    return getOrdersByStatus(
      customerId: customerId,
      status: '2',
      page: page,
      limit: limit,
    );
  }

  /// Get cancelled orders
  static Future<OrderListResponse> getCancelledOrders({
    required int customerId,
    int page = 1,
    int limit = 20,
  }) async {
    return getOrdersByStatus(
      customerId: customerId,
      status: '3',
      page: page,
      limit: limit,
    );
  }
}
