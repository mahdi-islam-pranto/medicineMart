import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/favorites_state.dart';
import '../../models/models.dart';
import '../../services/favorites_storage_service.dart';

/// Cubit for managing favorite medicines
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesInitial());

  /// Load favorites data from SharedPreferences
  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());

    try {
      // Load favorites from SharedPreferences
      final favoriteItems = await FavoritesStorageService.loadFavorites();

      emit(FavoritesLoaded(items: favoriteItems));
    } catch (e) {
      emit(
          FavoritesError(message: 'Failed to load favorites: ${e.toString()}'));
    }
  }

  /// Add medicine to favorites with SharedPreferences storage
  Future<void> addToFavorites(Medicine medicine) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        // Check if already in favorites
        if (!currentState.isFavorite(medicine.id)) {
          final newFavorite = FavoriteItem.fromMedicine(medicine);

          // Save to SharedPreferences
          final success =
              await FavoritesStorageService.addFavorite(newFavorite);

          if (success) {
            final updatedItems = List<FavoriteItem>.from(currentState.items);
            updatedItems.add(newFavorite);

            emit(FavoritesOperationSuccess(
              message: '${medicine.name} added to favorites',
              operationType: FavoritesOperationType.add,
              items: updatedItems,
              affectedItem: newFavorite,
            ));

            // Return to loaded state
            emit(FavoritesLoaded(items: updatedItems));
          } else {
            emit(const FavoritesError(
                message: 'Failed to save favorite to storage'));
            emit(currentState.copyWith(isUpdating: false));
          }
        } else {
          // Already in favorites
          emit(currentState.copyWith(isUpdating: false));
        }
      } catch (e) {
        emit(FavoritesError(
            message: 'Failed to add to favorites: ${e.toString()}'));
        emit(currentState.copyWith(isUpdating: false));
      }
    }
  }

  /// Remove medicine from favorites with SharedPreferences storage
  Future<void> removeFromFavorites(String medicineId) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        final updatedItems = List<FavoriteItem>.from(currentState.items);
        final itemIndex =
            updatedItems.indexWhere((item) => item.id == medicineId);

        if (itemIndex != -1) {
          final removedItem = updatedItems[itemIndex];

          // Remove from SharedPreferences
          final success =
              await FavoritesStorageService.removeFavorite(medicineId);

          if (success) {
            updatedItems.removeAt(itemIndex);

            emit(FavoritesOperationSuccess(
              message: '${removedItem.name} removed from favorites',
              operationType: FavoritesOperationType.remove,
              items: updatedItems,
              affectedItem: removedItem,
            ));

            // Return to loaded state
            emit(FavoritesLoaded(items: updatedItems));
          } else {
            emit(const FavoritesError(
                message: 'Failed to remove favorite from storage'));
            emit(currentState.copyWith(isUpdating: false));
          }
        } else {
          // Item not found
          emit(currentState.copyWith(isUpdating: false));
        }
      } catch (e) {
        emit(FavoritesError(
            message: 'Failed to remove from favorites: ${e.toString()}'));
        emit(currentState.copyWith(isUpdating: false));
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

  /// Clear all favorites with SharedPreferences storage
  Future<void> clearAllFavorites() async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        // Clear from SharedPreferences
        final success = await FavoritesStorageService.clearAllFavorites();

        if (success) {
          emit(const FavoritesOperationSuccess(
            message: 'All favorites cleared',
            operationType: FavoritesOperationType.clear,
            items: [],
          ));

          // Return to loaded state with empty favorites
          emit(const FavoritesLoaded(items: []));
        } else {
          emit(const FavoritesError(
              message: 'Failed to clear favorites from storage'));
          emit(currentState.copyWith(isUpdating: false));
        }
      } catch (e) {
        emit(FavoritesError(
            message: 'Failed to clear favorites: ${e.toString()}'));
        emit(currentState.copyWith(isUpdating: false));
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
}
