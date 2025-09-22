import 'package:equatable/equatable.dart';
import '../../models/models.dart';

/// Base state for cart management
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state when cart cubit is first created
class CartInitial extends CartState {
  const CartInitial();
}

/// State when cart is being loaded
class CartLoading extends CartState {
  const CartLoading();
}

/// State when cart is successfully loaded
class CartLoaded extends CartState {
  final List<CartItem> items;
  final bool isUpdating;
  final CartSummary? apiSummary;

  const CartLoaded({
    required this.items,
    this.isUpdating = false,
    this.apiSummary,
  });

  /// Get total number of items in cart (sum of all quantities)
  int get totalItems => items.fold(0, (sum, item) => sum + item.cartQuantity);

  /// Get number of unique products in cart
  int get uniqueProductCount => items.length;

  /// Get total price of all items in cart
  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Get total original price of all items in cart
  double get totalOriginalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalOriginalPrice);

  /// Get total discount amount
  double get totalDiscount => totalOriginalPrice - totalPrice;

  /// Get total discount percentage
  int get totalDiscountPercentage {
    if (totalOriginalPrice == 0) return 0;
    return ((totalDiscount / totalOriginalPrice) * 100).round();
  }

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get cart item by medicine ID
  CartItem? getItemById(String medicineId) {
    try {
      return items.firstWhere((item) => item.id == medicineId);
    } catch (e) {
      return null;
    }
  }

  /// Get quantity of a specific medicine in cart
  int getQuantity(String medicineId) {
    final item = getItemById(medicineId);
    return item?.cartQuantity ?? 0;
  }

  /// Check if a medicine is in cart
  bool containsMedicine(String medicineId) {
    return items.any((item) => item.id == medicineId);
  }

  /// Create a copy of this state with updated fields
  CartLoaded copyWith({
    List<CartItem>? items,
    bool? isUpdating,
    CartSummary? apiSummary,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      isUpdating: isUpdating ?? this.isUpdating,
      apiSummary: apiSummary ?? this.apiSummary,
    );
  }

  @override
  List<Object?> get props => [items, isUpdating, apiSummary];
}

/// State when there's an error with cart operations
class CartError extends CartState {
  final String message;
  final String? errorCode;

  const CartError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

/// State when checkout is successful
class CartCheckoutSuccess extends CartState {
  final String message;
  final CheckoutOrderData orderData;

  const CartCheckoutSuccess({
    required this.message,
    required this.orderData,
  });

  @override
  List<Object?> get props => [message, orderData];
}

/// State when cart operation is successful (for showing feedback)
class CartOperationSuccess extends CartState {
  final String message;
  final CartOperationType operationType;
  final List<CartItem> items;

  const CartOperationSuccess({
    required this.message,
    required this.operationType,
    required this.items,
  });

  @override
  List<Object?> get props => [message, operationType, items];
}

/// Types of cart operations
enum CartOperationType {
  add,
  update,
  remove,
  clear,
}
