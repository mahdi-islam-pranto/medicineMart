import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/cart_state.dart';
import '../../models/models.dart';

/// Cubit for managing cart items and operations
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartInitial());

  /// Load cart data
  Future<void> loadCart() async {
    emit(const CartLoading());
    
    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Load sample cart data - In a real app, this would come from local storage or API
      final cartItems = _getSampleCartItems();
      
      emit(CartLoaded(items: cartItems));
    } catch (e) {
      emit(CartError(message: 'Failed to load cart: ${e.toString()}'));
    }
  }

  /// Add medicine to cart
  void addToCart(Medicine medicine, int quantity) {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));
      
      try {
        final updatedItems = List<CartItem>.from(currentState.items);
        final existingItemIndex = updatedItems.indexWhere((item) => item.id == medicine.id);
        
        if (existingItemIndex != -1) {
          // Update existing item quantity
          final existingItem = updatedItems[existingItemIndex];
          updatedItems[existingItemIndex] = existingItem.copyWith(
            cartQuantity: quantity,
          );
        } else {
          // Add new item to cart
          final newItem = CartItem.fromMedicine(medicine, quantity);
          updatedItems.add(newItem);
        }
        
        emit(CartOperationSuccess(
          message: quantity > 1 
              ? '${medicine.name} quantity updated in cart'
              : '${medicine.name} added to cart',
          operationType: existingItemIndex != -1 
              ? CartOperationType.update 
              : CartOperationType.add,
          items: updatedItems,
        ));
        
        // Return to loaded state
        emit(CartLoaded(items: updatedItems));
      } catch (e) {
        emit(CartError(message: 'Failed to add item to cart: ${e.toString()}'));
      }
    }
  }

  /// Update item quantity in cart
  void updateQuantity(String medicineId, int quantity) {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));
      
      try {
        final updatedItems = List<CartItem>.from(currentState.items);
        final itemIndex = updatedItems.indexWhere((item) => item.id == medicineId);
        
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
      } catch (e) {
        emit(CartError(message: 'Failed to update item quantity: ${e.toString()}'));
      }
    }
  }

  /// Remove item from cart
  void removeFromCart(String medicineId) {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));
      
      try {
        final updatedItems = List<CartItem>.from(currentState.items);
        final itemIndex = updatedItems.indexWhere((item) => item.id == medicineId);
        
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
      } catch (e) {
        emit(CartError(message: 'Failed to remove item from cart: ${e.toString()}'));
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

  /// Get sample cart items
  List<CartItem> _getSampleCartItems() {
    return [
      const CartItem(
        id: '1',
        name: 'Tablet- Acipro',
        quantity: 'Box',
        brand: 'Square',
        price: 410.00,
        originalPrice: 500.00,
        cartQuantity: 2,
        imageUrl: 'https://via.placeholder.com/80x80/E3F2FD/1976D2?text=ACIPRO',
      ),
      const CartItem(
        id: '3',
        name: 'Syrup- Asthalin',
        quantity: '100ml',
        brand: 'Renata',
        price: 230.00,
        originalPrice: 360.00,
        cartQuantity: 1,
        imageUrl: 'https://via.placeholder.com/80x80/E8F5E8/4CAF50?text=SYRUP',
      ),
      const CartItem(
        id: '4',
        name: 'Capsule- Amoxicillin',
        quantity: '500ml',
        brand: 'Beximco',
        price: 410.00,
        originalPrice: 600.00,
        cartQuantity: 1,
        imageUrl: 'https://via.placeholder.com/80x80/FFF8E1/FFC107?text=CAPS',
      ),
    ];
  }
}
