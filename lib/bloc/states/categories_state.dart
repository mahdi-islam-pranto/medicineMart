import 'package:equatable/equatable.dart';
import '../../models/models.dart';

/// Base state for categories management
abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

/// Initial state when categories cubit is first created
class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

/// State when categories are being loaded
class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

/// State when categories are successfully loaded
class CategoriesLoaded extends CategoriesState {
  final List<MedicineCategory> categories;
  final String searchQuery;

  const CategoriesLoaded({
    required this.categories,
    this.searchQuery = '',
  });

  /// Get filtered categories based on search query
  List<MedicineCategory> get filteredCategories {
    if (searchQuery.isEmpty) return categories;

    return categories.where((category) {
      final query = searchQuery.toLowerCase();
      return category.name.toLowerCase().contains(query) ||
          category.description.toLowerCase().contains(query);
    }).toList();
  }

  /// Check if search is active
  bool get hasActiveSearch => searchQuery.isNotEmpty;

  /// Get total number of medicines across all categories
  int get totalMedicineCount {
    return categories.fold(0, (sum, category) => sum + category.itemCount);
  }

  /// Create a copy of this state with updated fields
  CategoriesLoaded copyWith({
    List<MedicineCategory>? categories,
    String? searchQuery,
  }) {
    return CategoriesLoaded(
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [categories, searchQuery];
}

/// State when there's an error loading categories
class CategoriesError extends CategoriesState {
  final String message;
  final String? errorCode;

  const CategoriesError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}
