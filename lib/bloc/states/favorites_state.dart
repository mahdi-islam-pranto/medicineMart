import 'package:equatable/equatable.dart';
import '../../models/models.dart';

/// Base state for favorites management
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial state when favorites cubit is first created
class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// State when favorites are being loaded
class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

/// State when favorites are successfully loaded
class FavoritesLoaded extends FavoritesState {
  final List<FavoriteItem> items;
  final bool isUpdating;

  const FavoritesLoaded({
    required this.items,
    this.isUpdating = false,
  });

  /// Get total number of favorite items
  int get totalItems => items.length;

  /// Check if favorites is empty
  bool get isEmpty => items.isEmpty;

  /// Check if favorites has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get favorite item by medicine ID
  FavoriteItem? getItemById(String medicineId) {
    try {
      return items.firstWhere((item) => item.id == medicineId);
    } catch (e) {
      return null;
    }
  }

  /// Check if a medicine is in favorites
  bool isFavorite(String medicineId) {
    return items.any((item) => item.id == medicineId);
  }

  /// Get favorites sorted by date (newest first)
  List<FavoriteItem> get sortedByDate {
    final sortedItems = List<FavoriteItem>.from(items);
    sortedItems.sort((a, b) => b.addedDate.compareTo(a.addedDate));
    return sortedItems;
  }

  /// Get favorites sorted by name
  List<FavoriteItem> get sortedByName {
    final sortedItems = List<FavoriteItem>.from(items);
    sortedItems.sort((a, b) => a.name.compareTo(b.name));
    return sortedItems;
  }

  /// Get favorites sorted by brand
  List<FavoriteItem> get sortedByBrand {
    final sortedItems = List<FavoriteItem>.from(items);
    sortedItems.sort((a, b) => a.brand.compareTo(b.brand));
    return sortedItems;
  }

  /// Get total savings from all favorite items
  double get totalSavings {
    return items.fold(0.0, (sum, item) => sum + item.discountAmount);
  }

  /// Create a copy of this state with updated fields
  FavoritesLoaded copyWith({
    List<FavoriteItem>? items,
    bool? isUpdating,
  }) {
    return FavoritesLoaded(
      items: items ?? this.items,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [items, isUpdating];
}

/// State when there's an error with favorites operations
class FavoritesError extends FavoritesState {
  final String message;
  final String? errorCode;

  const FavoritesError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

/// State when favorites operation is successful (for showing feedback)
class FavoritesOperationSuccess extends FavoritesState {
  final String message;
  final FavoritesOperationType operationType;
  final List<FavoriteItem> items;
  final FavoriteItem? affectedItem;

  const FavoritesOperationSuccess({
    required this.message,
    required this.operationType,
    required this.items,
    this.affectedItem,
  });

  @override
  List<Object?> get props => [message, operationType, items, affectedItem];
}

/// Types of favorites operations
enum FavoritesOperationType {
  add,
  remove,
  clear,
}
