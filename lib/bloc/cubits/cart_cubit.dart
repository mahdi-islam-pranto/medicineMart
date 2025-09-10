import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/cart_state.dart';
import '../../models/models.dart';
import '../../APIs/cart_api_service.dart';

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

        emit(CartLoaded(items: cartItems));
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
          // Update local cart state on successful API call
          final updatedItems = List<CartItem>.from(currentState.items);
          final existingItemIndex =
              updatedItems.indexWhere((item) => item.id == medicine.id);

          if (existingItemIndex != -1) {
            if (quantity > 0) {
              // Update existing item quantity
              final existingItem = updatedItems[existingItemIndex];
              updatedItems[existingItemIndex] = existingItem.copyWith(
                cartQuantity: quantity,
              );
            } else {
              // Remove item if quantity is 0
              updatedItems.removeAt(existingItemIndex);
            }
          } else if (quantity > 0) {
            // Add new item to cart
            final newItem = CartItem.fromMedicine(medicine, quantity);
            updatedItems.add(newItem);
          }

          emit(CartOperationSuccess(
            message: apiResponse.message,
            operationType: existingItemIndex != -1
                ? (quantity > 0
                    ? CartOperationType.update
                    : CartOperationType.remove)
                : CartOperationType.add,
            items: updatedItems,
          ));

          // Return to loaded state
          emit(CartLoaded(items: updatedItems));
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
          // Update local cart state on successful API call
          final updatedItems = List<CartItem>.from(currentState.items);
          final itemIndex =
              updatedItems.indexWhere((item) => item.id == medicineId);

          if (itemIndex != -1) {
            if (quantity > 0) {
              // Update quantity
              updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
                cartQuantity: quantity,
              );
            } else {
              // Remove item if quantity is 0
              updatedItems.removeAt(itemIndex);
            }

            emit(CartLoaded(items: updatedItems));
          }
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
          // Update local cart state on successful API call
          final updatedItems = List<CartItem>.from(currentState.items);
          final itemIndex =
              updatedItems.indexWhere((item) => item.id == medicineId);

          if (itemIndex != -1) {
            final removedItem = updatedItems[itemIndex];
            updatedItems.removeAt(itemIndex);

            emit(CartOperationSuccess(
              message: '${removedItem.name} removed from cart',
              operationType: CartOperationType.remove,
              items: updatedItems,
            ));

            // Return to loaded state
            emit(CartLoaded(items: updatedItems));
          }
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
}
