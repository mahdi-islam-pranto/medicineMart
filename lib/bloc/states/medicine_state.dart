import 'package:equatable/equatable.dart';
import '../../models/models.dart';

/// Base state for medicine management
abstract class MedicineState extends Equatable {
  const MedicineState();

  @override
  List<Object?> get props => [];
}

/// Initial state when medicine cubit is first created
class MedicineInitial extends MedicineState {
  const MedicineInitial();
}

/// State when medicines are being loaded
class MedicineLoading extends MedicineState {
  const MedicineLoading();
}

/// State when medicines are successfully loaded
class MedicineLoaded extends MedicineState {
  final List<Medicine> medicines;
  final List<String> brands;
  final String searchQuery;
  final String? selectedBrand;
  final String? selectedLetter;
  final bool isRefreshing;

  const MedicineLoaded({
    required this.medicines,
    required this.brands,
    this.searchQuery = '',
    this.selectedBrand,
    this.selectedLetter,
    this.isRefreshing = false,
  });

  /// Get filtered medicines based on current filters
  List<Medicine> get filteredMedicines {
    List<Medicine> filtered = medicines;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((medicine) {
        final query = searchQuery.toLowerCase();
        return medicine.name.toLowerCase().contains(query) ||
            medicine.brand.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by selected brand
    if (selectedBrand != null) {
      filtered = filtered.where((medicine) {
        return medicine.brand == selectedBrand;
      }).toList();
    }

    // Filter by selected letter
    if (selectedLetter != null) {
      filtered = filtered.where((medicine) {
        return medicine.name.toUpperCase().startsWith(selectedLetter!);
      }).toList();
    }

    return filtered;
  }

  /// Check if any filters are active
  bool get hasActiveFilters =>
      searchQuery.isNotEmpty || selectedBrand != null || selectedLetter != null;

  /// Create a copy of this state with updated fields
  MedicineLoaded copyWith({
    List<Medicine>? medicines,
    List<String>? brands,
    String? searchQuery,
    String? selectedBrand,
    String? selectedLetter,
    bool? isRefreshing,
    bool clearBrand = false,
    bool clearLetter = false,
  }) {
    return MedicineLoaded(
      medicines: medicines ?? this.medicines,
      brands: brands ?? this.brands,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBrand: clearBrand ? null : (selectedBrand ?? this.selectedBrand),
      selectedLetter: clearLetter ? null : (selectedLetter ?? this.selectedLetter),
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
        medicines,
        brands,
        searchQuery,
        selectedBrand,
        selectedLetter,
        isRefreshing,
      ];
}

/// State when there's an error loading medicines
class MedicineError extends MedicineState {
  final String message;
  final String? errorCode;

  const MedicineError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}
