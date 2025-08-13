import 'package:equatable/equatable.dart';

/// Product filter model for managing filter state in explore products
class ProductFilter extends Equatable {
  final String? searchQuery;
  final List<String> selectedBrands;
  final List<String> selectedCategories;
  final SortOption sortOption;
  final ProductCategory productCategory;

  const ProductFilter({
    this.searchQuery,
    this.selectedBrands = const [],
    this.selectedCategories = const [],
    this.sortOption = SortOption.nameAtoZ,
    this.productCategory = ProductCategory.all,
  });

  /// Create a copy with updated fields
  ProductFilter copyWith({
    String? searchQuery,
    List<String>? selectedBrands,
    List<String>? selectedCategories,
    SortOption? sortOption,
    ProductCategory? productCategory,
  }) {
    return ProductFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBrands: selectedBrands ?? this.selectedBrands,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      sortOption: sortOption ?? this.sortOption,
      productCategory: productCategory ?? this.productCategory,
    );
  }

  /// Clear all filters
  ProductFilter clear() {
    return const ProductFilter();
  }

  /// Check if any filters are active
  bool get hasActiveFilters {
    return searchQuery?.isNotEmpty == true ||
        selectedBrands.isNotEmpty ||
        selectedCategories.isNotEmpty ||
        sortOption != SortOption.nameAtoZ ||
        productCategory != ProductCategory.all;
  }

  /// Get filter count for display
  int get activeFilterCount {
    int count = 0;
    if (searchQuery?.isNotEmpty == true) count++;
    if (selectedBrands.isNotEmpty) count++;
    if (selectedCategories.isNotEmpty) count++;
    if (sortOption != SortOption.nameAtoZ) count++;
    if (productCategory != ProductCategory.all) count++;
    return count;
  }

  @override
  List<Object?> get props => [
        searchQuery,
        selectedBrands,
        selectedCategories,
        sortOption,
        productCategory,
      ];
}

/// Product category enum for filtering
enum ProductCategory {
  all('All'),
  trending('Trending'),
  specialOffer('Special Offer'),
  newProduct('New Product');

  const ProductCategory(this.displayName);
  final String displayName;
}

/// Sort option enum for product sorting
enum SortOption {
  nameAtoZ('Name: A to Z'),
  nameZtoA('Name: Z to A'),
  priceLowToHigh('Price - Low to High'),
  priceHighToLow('Price - High to Low'),
  discountHighToLow('Discount - High to Low'),
  discountLowToHigh('Discount - Low to High'),
  deliveryDate1('14/08/2025'),
  deliveryDate2('15/08/2025'),
  deliveryDate3('17/08/2025');

  const SortOption(this.displayName);
  final String displayName;

  /// Get sort category
  SortCategory get category {
    switch (this) {
      case SortOption.priceLowToHigh:
      case SortOption.priceHighToLow:
        return SortCategory.price;
      case SortOption.discountHighToLow:
      case SortOption.discountLowToHigh:
        return SortCategory.discount;
      case SortOption.nameAtoZ:
      case SortOption.nameZtoA:
        return SortCategory.alphabet;
      case SortOption.deliveryDate1:
      case SortOption.deliveryDate2:
      case SortOption.deliveryDate3:
        return SortCategory.deliveryDate;
    }
  }
}

/// Sort category enum for grouping sort options
enum SortCategory {
  price('Sort by price'),
  discount('Sort by discount'),
  alphabet('Sort by Alphabet'),
  deliveryDate('Sort by delivery date');

  const SortCategory(this.displayName);
  final String displayName;
}

/// Filter option model for company/brand filtering
class FilterOption extends Equatable {
  final String id;
  final String name;
  final bool isSelected;

  const FilterOption({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  FilterOption copyWith({
    String? id,
    String? name,
    bool? isSelected,
  }) {
    return FilterOption(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, name, isSelected];
}
