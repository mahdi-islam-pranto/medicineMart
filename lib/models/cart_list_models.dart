import 'package:equatable/equatable.dart';

/// Response model for cart list API
class CartListResponse extends Equatable {
  final bool success;
  final String message;
  final CartListData? data;

  const CartListResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CartListResponse.fromJson(Map<String, dynamic> json) {
    return CartListResponse(
      success: json['status'] == '200' || json['status'] == 200,
      message: json['message'] ?? '',
      data: json['data'] != null ? CartListData.fromJson(json['data']) : null,
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}

/// Cart list data containing items and summary
class CartListData extends Equatable {
  final List<CartItemData> items;
  final CartSummary summary;

  const CartListData({
    required this.items,
    required this.summary,
  });

  factory CartListData.fromJson(Map<String, dynamic> json) {
    return CartListData(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItemData.fromJson(item))
              .toList() ??
          [],
      summary: CartSummary.fromJson(json['summary'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [items, summary];
}

/// Individual cart item from API
class CartItemData extends Equatable {
  final int cartItemId;
  final int productId;
  final String productName;
  final String brand;
  final double mrpPriceSingle;
  final double salePriceSingle;
  final String discountPercentage;
  final int cartQuantity;
  final double mrpPrice;
  final double salePrice;
  final String? imageUrl;

  const CartItemData({
    required this.cartItemId,
    required this.productId,
    required this.productName,
    required this.brand,
    required this.mrpPriceSingle,
    required this.salePriceSingle,
    required this.discountPercentage,
    required this.cartQuantity,
    required this.mrpPrice,
    required this.salePrice,
    this.imageUrl,
  });

  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
      cartItemId: json['cart_item_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      brand: json['brand'] ?? '',
      mrpPriceSingle: (json['mrp_price_single'] as num?)?.toDouble() ?? 0.0,
      salePriceSingle: (json['sale_price_single'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: json['discount_percentage'] ?? '0%',
      cartQuantity: json['cart_quantity'] ?? 0,
      mrpPrice: (json['mrp_price'] as num?)?.toDouble() ?? 0.0,
      salePrice: (json['sale_price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'],
    );
  }

  /// Check if item has discount
  bool get hasDiscount => salePriceSingle < mrpPriceSingle;

  /// Get discount amount per item
  double get discountAmount => mrpPriceSingle - salePriceSingle;

  /// Get total discount for this item
  double get totalDiscount => mrpPrice - salePrice;

  @override
  List<Object?> get props => [
        cartItemId,
        productId,
        productName,
        brand,
        mrpPriceSingle,
        salePriceSingle,
        discountPercentage,
        cartQuantity,
        mrpPrice,
        salePrice,
        imageUrl,
      ];
}

/// Cart summary with totals
class CartSummary extends Equatable {
  final int totalItems;
  final double subtotal;
  final double discount;
  final double totalAmount;

  const CartSummary({
    required this.totalItems,
    required this.subtotal,
    required this.discount,
    required this.totalAmount,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) {
    return CartSummary(
      totalItems: json['total_items'] ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Get discount percentage
  double get discountPercentage {
    if (subtotal + discount == 0) return 0.0;
    return (discount / (subtotal + discount)) * 100;
  }

  @override
  List<Object?> get props => [totalItems, subtotal, discount, totalAmount];
}
