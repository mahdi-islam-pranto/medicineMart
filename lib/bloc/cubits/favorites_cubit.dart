import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/favorites_state.dart';
import '../../models/models.dart';

/// Cubit for managing favorite medicines
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesInitial());

  /// Load favorites data
  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());
    
    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Load sample favorites data - In a real app, this would come from local storage or API
      final favoriteItems = _getSampleFavoriteItems();
      
      emit(FavoritesLoaded(items: favoriteItems));
    } catch (e) {
      emit(FavoritesError(message: 'Failed to load favorites: ${e.toString()}'));
    }
  }

  /// Add medicine to favorites
  void addToFavorites(Medicine medicine) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      emit(currentState.copyWith(isUpdating: true));
      
      try {
        final updatedItems = List<FavoriteItem>.from(currentState.items);
        
        // Check if already in favorites
        if (!updatedItems.any((item) => item.id == medicine.id)) {
          final newFavorite = FavoriteItem.fromMedicine(medicine);
          updatedItems.add(newFavorite);
          
          emit(FavoritesOperationSuccess(
            message: '${medicine.name} added to favorites',
            operationType: FavoritesOperationType.add,
            items: updatedItems,
            affectedItem: newFavorite,
          ));
          
          // Return to loaded state
          emit(FavoritesLoaded(items: updatedItems));
        }
      } catch (e) {
        emit(FavoritesError(message: 'Failed to add to favorites: ${e.toString()}'));
      }
    }
  }

  /// Remove medicine from favorites
  void removeFromFavorites(String medicineId) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      emit(currentState.copyWith(isUpdating: true));
      
      try {
        final updatedItems = List<FavoriteItem>.from(currentState.items);
        final itemIndex = updatedItems.indexWhere((item) => item.id == medicineId);
        
        if (itemIndex != -1) {
          final removedItem = updatedItems[itemIndex];
          updatedItems.removeAt(itemIndex);
          
          emit(FavoritesOperationSuccess(
            message: '${removedItem.name} removed from favorites',
            operationType: FavoritesOperationType.remove,
            items: updatedItems,
            affectedItem: removedItem,
          ));
          
          // Return to loaded state
          emit(FavoritesLoaded(items: updatedItems));
        }
      } catch (e) {
        emit(FavoritesError(message: 'Failed to remove from favorites: ${e.toString()}'));
      }
    }
  }

  /// Toggle favorite status of a medicine
  void toggleFavorite(Medicine medicine) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      if (currentState.isFavorite(medicine.id)) {
        removeFromFavorites(medicine.id);
      } else {
        addToFavorites(medicine);
      }
    }
  }

  /// Clear all favorites
  void clearAllFavorites() {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      emit(currentState.copyWith(isUpdating: true));
      
      try {
        emit(const FavoritesOperationSuccess(
          message: 'All favorites cleared',
          operationType: FavoritesOperationType.clear,
          items: [],
        ));
        
        // Return to loaded state with empty favorites
        emit(const FavoritesLoaded(items: []));
      } catch (e) {
        emit(FavoritesError(message: 'Failed to clear favorites: ${e.toString()}'));
      }
    }
  }

  /// Check if a medicine is in favorites
  bool isFavorite(String medicineId) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      return currentState.isFavorite(medicineId);
    }
    return false;
  }

  /// Get total number of favorites
  int get totalFavorites {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      return currentState.totalItems;
    }
    return 0;
  }

  /// Get sample favorite items
  List<FavoriteItem> _getSampleFavoriteItems() {
    return [
      FavoriteItem(
        id: '1',
        name: 'Tablet- Acipro',
        quantity: 'Box',
        brand: 'Square',
        price: 410.00,
        originalPrice: 500.00,
        imageUrl: 'https://via.placeholder.com/80x80/E3F2FD/1976D2?text=ACIPRO',
        addedDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      FavoriteItem(
        id: '3',
        name: 'Syrup- Asthalin',
        quantity: '100ml',
        brand: 'Renata',
        price: 230.00,
        originalPrice: 360.00,
        imageUrl: 'https://via.placeholder.com/80x80/E8F5E8/4CAF50?text=SYRUP',
        addedDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      FavoriteItem(
        id: '4',
        name: 'Capsule- Amoxicillin',
        quantity: '500ml',
        brand: 'Beximco',
        price: 410.00,
        originalPrice: 600.00,
        imageUrl: 'https://via.placeholder.com/80x80/FFF8E1/FFC107?text=CAPS',
        addedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      FavoriteItem(
        id: '6',
        name: 'Syrup- Reneta-B',
        quantity: '250ml',
        brand: 'Renata',
        price: 500.00,
        originalPrice: 630.00,
        imageUrl: 'https://via.placeholder.com/80x80/FCE4EC/E91E63?text=SYRUP',
        addedDate: DateTime.now().subtract(const Duration(days: 7)),
      ),
      FavoriteItem(
        id: '7',
        name: 'Tablet- Vitamin D3',
        quantity: '1000 IU',
        brand: 'HealthKart',
        price: 990.00,
        originalPrice: 1250.00,
        imageUrl: 'https://via.placeholder.com/80x80/FFF9C4/F9A825?text=VIT',
        addedDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
