import 'package:equatable/equatable.dart';

/// Product filter model for managing filter state in explore products
class ProductFilter extends Equatable {
  final String? searchQuery;
  final String? selectedBrandId;
  final String? selectedCategoryId;
  final SortOption sortOption;
  final ProductCategory productCategory;

  const ProductFilter({
    this.searchQuery,
    this.selectedBrandId,
    this.selectedCategoryId,
    this.sortOption = SortOption.nameAtoZ,
    this.productCategory = ProductCategory.all,
  });

  /// Create a copy with updated fields
  ProductFilter copyWith({
    String? searchQuery,
    String? selectedBrandId,
    String? selectedCategoryId,
    SortOption? sortOption,
    ProductCategory? productCategory,
    bool clearBrand = false,
    bool clearCategory = false,
  }) {
    return ProductFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBrandId:
          clearBrand ? null : (selectedBrandId ?? this.selectedBrandId),
      selectedCategoryId: clearCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
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
        selectedBrandId?.isNotEmpty == true ||
        selectedCategoryId?.isNotEmpty == true ||
        sortOption != SortOption.nameAtoZ ||
        productCategory != ProductCategory.all;
  }

  /// Get filter count for display
  int get activeFilterCount {
    int count = 0;
    if (searchQuery?.isNotEmpty == true) count++;
    if (selectedBrandId?.isNotEmpty == true) count++;
    if (selectedCategoryId?.isNotEmpty == true) count++;
    if (sortOption != SortOption.nameAtoZ) count++;
    if (productCategory != ProductCategory.all) count++;
    return count;
  }

  @override
  List<Object?> get props => [
        searchQuery,
        selectedBrandId,
        selectedCategoryId,
        sortOption,
        productCategory,
      ];

  @override
  String toString() {
    return 'ProductFilter(searchQuery: $searchQuery, selectedBrandId: $selectedBrandId, selectedCategoryId: $selectedCategoryId, sortOption: $sortOption, productCategory: $productCategory)';
  }
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
