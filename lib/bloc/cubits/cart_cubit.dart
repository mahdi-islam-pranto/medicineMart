import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/cart_state.dart';
import '../../models/models.dart';
import '../../APIs/cart_api_service.dart';
import '../../APIs/order_api_service.dart';

/// Cubit for managing cart items and operations
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartInitial());

  /// Load cart data from API
  Future<void> loadCart({int? customerId}) async {
    emit(const CartLoading());

    try {
      // Use provided customerId or default to 1 for development
      final customerIdToUse = customerId ?? 1;

      // Make API call to get cart items
      final apiResponse = await CartApiService.getCartItems(
        customerId: customerIdToUse,
      );

      if (apiResponse.success && apiResponse.data != null) {
        // Convert API cart items to local CartItem models
        final cartItems = apiResponse.data!.items
            .where((item) =>
                item.cartQuantity > 0) // Only include items with quantity > 0
            .map((item) => CartItem.fromCartItemData(item))
            .toList();

        emit(CartLoaded(
          items: cartItems,
          apiSummary: apiResponse.data!.summary,
        ));
      } else {
        // API call failed or no data
        emit(CartError(message: apiResponse.message));
      }
    } catch (e) {
      emit(CartError(message: 'Failed to load cart: ${e.toString()}'));
    }
  }

  /// Add medicine to cart with API integration
  Future<void> addToCart(Medicine medicine, int quantity,
      {int? customerId}) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        // Use provided customerId or default to 1 for development
        final customerIdToUse = customerId ?? 1;

        // Parse medicine ID to int
        final productId = int.tryParse(medicine.id) ?? 1;

        // Make API call
        final apiResponse = await CartApiService.addToCart(
          productId: productId,
          customerId: customerIdToUse,
          quantity: quantity,
        );

        if (apiResponse.success) {
          // Show operation success message first
          emit(CartOperationSuccess(
            message: apiResponse.message,
            operationType:
                quantity > 0 ? CartOperationType.add : CartOperationType.remove,
            items: currentState.items, // Keep current items for now
          ));

          // Reload entire cart from API to get updated summary data
          await loadCart(customerId: customerIdToUse);
        } else {
          // API call failed
          emit(CartError(message: apiResponse.message));
          // Return to previous state
          emit(currentState.copyWith(isUpdating: false));
        }
      } catch (e) {
        emit(CartError(message: 'Failed to add item to cart: ${e.toString()}'));
        // Return to previous state
        if (currentState is CartLoaded) {
          emit(currentState.copyWith(isUpdating: false));
        }
      }
    }
  }

  /// Update item quantity in cart with API integration
  Future<void> updateQuantity(String medicineId, int quantity,
      {int? customerId}) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        // Use provided customerId or default to 1 for development
        final customerIdToUse = customerId ?? 1;

        // Parse medicine ID to int
        final productId = int.tryParse(medicineId) ?? 1;

        // Make API call
        final apiResponse = await CartApiService.updateQuantity(
          productId: productId,
          customerId: customerIdToUse,
          quantity: quantity,
        );

        if (apiResponse.success) {
          // Reload entire cart from API to get updated summary data
          await loadCart(customerId: customerIdToUse);
        } else {
          // API call failed
          emit(CartError(message: apiResponse.message));
          // Return to previous state
          emit(currentState.copyWith(isUpdating: false));
        }
      } catch (e) {
        emit(CartError(
            message: 'Failed to update item quantity: ${e.toString()}'));
        // Return to previous state
        emit(currentState.copyWith(isUpdating: false));
      }
    }
  }

  /// Remove item from cart with API integration
  Future<void> removeFromCart(String medicineId, {int? customerId}) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        // Use provided customerId or default to 1 for development
        final customerIdToUse = customerId ?? 1;

        // Parse medicine ID to int
        final productId = int.tryParse(medicineId) ?? 1;

        // Make API call to remove (quantity = 0)
        final apiResponse = await CartApiService.removeFromCart(
          productId: productId,
          customerId: customerIdToUse,
        );

        if (apiResponse.success) {
          // Find the item to show success message
          final itemIndex =
              currentState.items.indexWhere((item) => item.id == medicineId);
          final itemName =
              itemIndex != -1 ? currentState.items[itemIndex].name : 'Item';

          emit(CartOperationSuccess(
            message: '$itemName removed from cart',
            operationType: CartOperationType.remove,
            items: currentState.items, // Keep current items for now
          ));

          // Reload entire cart from API to get updated summary data
          await loadCart(customerId: customerIdToUse);
        } else {
          // API call failed
          emit(CartError(message: apiResponse.message));
          // Return to previous state
          emit(currentState.copyWith(isUpdating: false));
        }
      } catch (e) {
        emit(CartError(
            message: 'Failed to remove item from cart: ${e.toString()}'));
        // Return to previous state
        emit(currentState.copyWith(isUpdating: false));
      }
    }
  }

  /// Clear all items from cart
  void clearCart() {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        emit(const CartOperationSuccess(
          message: 'Cart cleared',
          operationType: CartOperationType.clear,
          items: [],
        ));

        // Return to loaded state with empty cart
        emit(const CartLoaded(items: []));
      } catch (e) {
        emit(CartError(message: 'Failed to clear cart: ${e.toString()}'));
      }
    }
  }

  /// Get quantity of a specific medicine in cart
  int getQuantity(String medicineId) {
    final currentState = state;
    if (currentState is CartLoaded) {
      return currentState.getQuantity(medicineId);
    }
    return 0;
  }

  /// Check if a medicine is in cart
  bool containsMedicine(String medicineId) {
    final currentState = state;
    if (currentState is CartLoaded) {
      return currentState.containsMedicine(medicineId);
    }
    return false;
  }

  /// Checkout - Create order from cart items
  Future<void> checkout({int? customerId}) async {
    final currentState = state;
    if (currentState is CartLoaded && currentState.isNotEmpty) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        // Use provided customerId or default to 1 for development
        final customerIdToUse = customerId ?? 1;

        // Use API summary values if available, otherwise calculate locally
        final subtotal =
            currentState.apiSummary?.subtotal ?? currentState.totalPrice;
        final discount = currentState.apiSummary?.discount ?? 0.0;
        final totalAmount =
            currentState.apiSummary?.totalAmount ?? (subtotal - discount);

        // Convert cart items to order items
        final orderItems = currentState.items.map((cartItem) {
          return OrderItem(
            productId: cartItem.id,
            quantity: cartItem.cartQuantity,
            unitPrice: cartItem.price,
          );
        }).toList();

        // Create order request
        final orderRequest = OrderRequest(
          items: orderItems,
          customerId: customerIdToUse,
          subtotal: subtotal,
          discount: discount,
          totalAmount: totalAmount,
        );

        // Make API call to create order
        final orderResponse = await OrderApiService.createOrder(orderRequest);

        if (orderResponse.success && orderResponse.data != null) {
          // Order created successfully
          emit(CartCheckoutSuccess(
            message: orderResponse.message,
            orderData: orderResponse.data!,
          ));

          // Clear cart after successful order
          emit(const CartLoaded(items: []));
        } else {
          // Order creation failed
          emit(CartError(message: orderResponse.message));
          // Return to previous state
          emit(currentState.copyWith(isUpdating: false));
        }
      } catch (e) {
        emit(CartError(message: 'Failed to create order: ${e.toString()}'));
        // Return to previous state
        emit(currentState.copyWith(isUpdating: false));
      }
    } else {
      emit(const CartError(message: 'Cart is empty. Add items to checkout.'));
    }
  }
}
