import 'package:equatable/equatable.dart';

/// Order item for API request
class OrderItem extends Equatable {
  final String productId;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }

  @override
  List<Object?> get props => [productId, quantity, unitPrice];
}

/// Order request model for checkout API
class OrderRequest extends Equatable {
  final List<OrderItem> items;
  final int customerId;
  final double subtotal;
  final double discount;
  final double totalAmount;

  const OrderRequest({
    required this.items,
    required this.customerId,
    required this.subtotal,
    required this.discount,
    required this.totalAmount,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'customer_id': customerId,
      'subtotal': subtotal,
      'discount': discount,
      'total_amount': totalAmount,
    };
  }

  @override
  List<Object?> get props =>
      [items, customerId, subtotal, discount, totalAmount];
}

/// Checkout order data from API response
class CheckoutOrderData extends Equatable {
  final String orderId;
  final String orderStatus;
  final String estimatedDelivery;
  final double totalAmount;
  final String paymentStatus;

  const CheckoutOrderData({
    required this.orderId,
    required this.orderStatus,
    required this.estimatedDelivery,
    required this.totalAmount,
    required this.paymentStatus,
  });

  /// Create from JSON response
  factory CheckoutOrderData.fromJson(Map<String, dynamic> json) {
    return CheckoutOrderData(
      orderId: json['order_id'] ?? '',
      orderStatus: json['order_status'] ?? '',
      estimatedDelivery: json['estimated_delivery'] ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['payment_status'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        orderId,
        orderStatus,
        estimatedDelivery,
        totalAmount,
        paymentStatus,
      ];
}

/// Order API response model
class OrderResponse extends Equatable {
  final bool success;
  final String message;
  final int statusCode;
  final CheckoutOrderData? data;

  const OrderResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    this.data,
  });

  /// Create success response
  factory OrderResponse.success({
    required String message,
    required CheckoutOrderData data,
    int statusCode = 200,
  }) {
    return OrderResponse(
      success: true,
      message: message,
      statusCode: statusCode,
      data: data,
    );
  }

  /// Create error response
  factory OrderResponse.error({
    required String message,
    int statusCode = 400,
  }) {
    return OrderResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }

  @override
  List<Object?> get props => [success, message, statusCode, data];
}
