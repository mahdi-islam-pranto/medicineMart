import 'package:equatable/equatable.dart';

/// Order list request model
class OrderListRequest extends Equatable {
  final int customerId;
  final String
      status; // 'all', '1' (pending), '2' (confirmed), '3' (delivered), '4' (cancelled)
  final int page;
  final int limit;

  const OrderListRequest({
    required this.customerId,
    required this.status,
    this.page = 1,
    this.limit = 20,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'status': status,
      'pagination.page': page,
      'pagination.limit': limit,
    };
  }

  @override
  List<Object?> get props => [customerId, status, page, limit];
}

/// Order item from API response
class OrderItemData extends Equatable {
  final int productId;
  final String name;
  final int qty;
  final String price;
  final String imageUrl;

  const OrderItemData({
    required this.productId,
    required this.name,
    required this.qty,
    required this.price,
    required this.imageUrl,
  });

  /// Create from JSON response
  factory OrderItemData.fromJson(Map<String, dynamic> json) {
    return OrderItemData(
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      qty: json['qty'] ?? 0,
      price: json['price']?.toString() ?? '0',
      imageUrl: json['image_url'] ?? '',
    );
  }

  /// Get price as double
  double get priceAsDouble => double.tryParse(price) ?? 0.0;

  @override
  List<Object?> get props => [productId, name, qty, price, imageUrl];
}

/// Order data from API response
class OrderData extends Equatable {
  final int id;
  final String orderNumber;
  final String status;
  final String total;
  final String? paymentStatus;
  final String estimatedDelivery;
  final String createdAt;
  final List<OrderItemData> items;

  const OrderData({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.total,
    this.paymentStatus,
    required this.estimatedDelivery,
    required this.createdAt,
    required this.items,
  });

  /// Create from JSON response
  factory OrderData.fromJson(Map<String, dynamic> json) {
    // Parse status - can be either String or Map
    String statusValue = '';
    final statusField = json['status'];
    if (statusField is String) {
      statusValue = statusField;
    } else if (statusField is Map) {
      // If status is a Map like {"1":"Pending","2":"Delivered","3":"Cancelled"}
      // We can't determine the actual status, so we'll use empty string
      // The API should provide the actual status as a string
      statusValue = '';
    }

    return OrderData(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      status: statusValue,
      total: json['total']?.toString() ?? '0',
      paymentStatus: json['payment_status'],
      estimatedDelivery: json['estimated_delivery'] ?? '',
      createdAt: json['created_at'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemData.fromJson(item))
              .toList() ??
          [],
    );
  }

  /// Get total as double
  double get totalAsDouble => double.tryParse(total) ?? 0.0;

  /// Get formatted status for display
  String get displayStatus {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        status,
        total,
        paymentStatus,
        estimatedDelivery,
        createdAt,
        items,
      ];
}

/// Pagination data from API response
class OrderPagination extends Equatable {
  final int currentPage;
  final int totalPages;
  final int totalOrders;
  final int perPage;
  final bool hasNext;
  final bool hasPrevious;

  const OrderPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalOrders,
    required this.perPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  /// Create from JSON response
  factory OrderPagination.fromJson(Map<String, dynamic> json) {
    return OrderPagination(
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalOrders: json['total_orders'] ?? 0,
      perPage: json['per_page'] ?? 20,
      hasNext: json['has_next'] ?? false,
      hasPrevious: json['has_previous'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        totalPages,
        totalOrders,
        perPage,
        hasNext,
        hasPrevious,
      ];
}

/// Order summary from API response
class OrderSummary extends Equatable {
  final int totalOrders;
  final int pendingOrders;
  final int confirmedOrders;
  final int deliveredOrders;
  final int cancelledOrders;

  const OrderSummary({
    required this.totalOrders,
    required this.pendingOrders,
    required this.confirmedOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
  });

  /// Create from JSON response
  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      totalOrders: json['total_orders'] ?? 0,
      pendingOrders: json['pending_orders'] ?? 0,
      confirmedOrders: json['confirmed_orders'] ?? 0,
      deliveredOrders: json['delivered_orders'] ?? 0,
      cancelledOrders: json['cancelled_orders'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        totalOrders,
        pendingOrders,
        confirmedOrders,
        deliveredOrders,
        cancelledOrders,
      ];
}

/// Order list data from API response
class OrderListData extends Equatable {
  final List<OrderData> orders;
  final OrderPagination pagination;
  final OrderSummary summary;

  const OrderListData({
    required this.orders,
    required this.pagination,
    required this.summary,
  });

  /// Create from JSON response
  factory OrderListData.fromJson(Map<String, dynamic> json) {
    return OrderListData(
      orders: (json['orders'] as List<dynamic>?)
              ?.map((order) => OrderData.fromJson(order))
              .toList() ??
          [],
      pagination: OrderPagination.fromJson(json['pagination'] ?? {}),
      summary: OrderSummary.fromJson(json['summary'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [orders, pagination, summary];
}

/// Order list API response model
class OrderListResponse extends Equatable {
  final bool success;
  final String message;
  final int statusCode;
  final OrderListData? data;

  const OrderListResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    this.data,
  });

  /// Create success response
  factory OrderListResponse.success({
    required String message,
    required OrderListData data,
    int statusCode = 200,
  }) {
    return OrderListResponse(
      success: true,
      message: message,
      statusCode: statusCode,
      data: data,
    );
  }

  /// Create error response
  factory OrderListResponse.error({
    required String message,
    int statusCode = 400,
  }) {
    return OrderListResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }

  @override
  List<Object?> get props => [success, message, statusCode, data];
}
