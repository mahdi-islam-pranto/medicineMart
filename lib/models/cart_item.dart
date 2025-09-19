import 'package:equatable/equatable.dart';
import 'medicine.dart';
import 'cart_list_models.dart';

/// Cart item data model with equatable for state comparison
class CartItem extends Equatable {
  final String id;
  final String name;
  final String quantity;
  final String brand;
  final double price;
  final double originalPrice;
  final int cartQuantity;
  final String imageUrl;
  final String?
      apiDiscountPercentage; // API discount percentage (e.g., "14.97%")

  const CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.cartQuantity,
    required this.imageUrl,
    this.apiDiscountPercentage,
  });

  /// Calculate total price for this cart item
  double get totalPrice => price * cartQuantity;

  /// Calculate total original price for this cart item
  double get totalOriginalPrice => originalPrice * cartQuantity;

  /// Calculate discount amount for this cart item
  double get discountAmount => totalOriginalPrice - totalPrice;

  /// Get discount percentage (from API if available, otherwise calculated)
  String get discountPercentage {
    // Use API discount percentage if available
    if (apiDiscountPercentage != null && apiDiscountPercentage!.isNotEmpty) {
      return apiDiscountPercentage!.replaceAll('%', '');
    }

    // Fallback to calculated percentage
    if (originalPrice <= price) return '0';
    if (originalPrice <= 0) return '0'; // Prevent division by zero

    final percentage = ((originalPrice - price) / originalPrice * 100);

    // Check for invalid results (NaN, Infinity)
    if (percentage.isNaN || percentage.isInfinite) return '0';

    return percentage.toStringAsFixed(2);
  }

  /// Check if item has discount
  bool get hasDiscount {
    // Check API discount percentage first
    if (apiDiscountPercentage != null && apiDiscountPercentage!.isNotEmpty) {
      final percentageStr = apiDiscountPercentage!.replaceAll('%', '');
      final percentage = double.tryParse(percentageStr);
      return percentage != null && percentage > 0;
    }

    // Fallback to price comparison
    return price < originalPrice;
  }

  /// Create cart item from medicine
  factory CartItem.fromMedicine(Medicine medicine, int quantity) {
    return CartItem(
      id: medicine.id,
      name: medicine.name,
      quantity: medicine.quantity,
      brand: medicine.brand,
      price: medicine.effectivePrice,
      originalPrice: medicine.regularPrice,
      cartQuantity: quantity,
      imageUrl: medicine.imageUrl ?? '',
      apiDiscountPercentage: medicine.apiDiscountPercentage,
    );
  }

  /// Create cart item from API cart item data
  factory CartItem.fromCartItemData(CartItemData cartItemData) {
    return CartItem(
      id: cartItemData.productId.toString(),
      name: cartItemData.productName,
      quantity: 'Pcs', // Default unit since API doesn't provide this
      brand: cartItemData.brand,
      price: cartItemData.salePriceSingle,
      originalPrice: cartItemData.mrpPriceSingle,
      cartQuantity: cartItemData.cartQuantity,
      imageUrl: cartItemData.imageUrl ?? '',
      apiDiscountPercentage: cartItemData.discountPercentage,
    );
  }

  /// Create a copy of this cart item with updated fields
  CartItem copyWith({
    String? id,
    String? name,
    String? quantity,
    String? brand,
    double? price,
    double? originalPrice,
    int? cartQuantity,
    String? imageUrl,
    String? apiDiscountPercentage,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      cartQuantity: cartQuantity ?? this.cartQuantity,
      imageUrl: imageUrl ?? this.imageUrl,
      apiDiscountPercentage:
          apiDiscountPercentage ?? this.apiDiscountPercentage,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'brand': brand,
      'price': price,
      'originalPrice': originalPrice,
      'cartQuantity': cartQuantity,
      'imageUrl': imageUrl,
      'apiDiscountPercentage': apiDiscountPercentage,
    };
  }

  /// Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as String,
      brand: json['brand'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      cartQuantity: json['cartQuantity'] as int,
      imageUrl: json['imageUrl'] as String,
      apiDiscountPercentage: json['apiDiscountPercentage'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        quantity,
        brand,
        price,
        originalPrice,
        cartQuantity,
        imageUrl,
        apiDiscountPercentage,
      ];

  @override
  String toString() {
    return 'CartItem(id: $id, name: $name, quantity: $cartQuantity, total: $totalPrice)';
  }
}
