import 'package:equatable/equatable.dart';
import 'medicine.dart';

/// Product search request model for API calls
class ProductSearchRequest extends Equatable {
  final String searchQuery;
  final String selectedBrands;
  final String selectedCategories;
  final String productType;
  final String sortOption;
  final PriceRange priceRange;
  final Pagination pagination;

  const ProductSearchRequest({
    this.searchQuery = '',
    this.selectedBrands = '',
    this.selectedCategories = '',
    this.productType = '',
    this.sortOption = '',
    this.priceRange = const PriceRange(),
    this.pagination = const Pagination(),
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'searchQuery': searchQuery,
      'selectedBrands': selectedBrands,
      'selectedCategories': selectedCategories,
      'productType': productType,
      'sortOption': sortOption,
      'priceRange': priceRange.toJson(),
      'pagination': pagination.toJson(),
    };
  }

  /// Create copy with updated fields
  ProductSearchRequest copyWith({
    String? searchQuery,
    String? selectedBrands,
    String? selectedCategories,
    String? productType,
    String? sortOption,
    PriceRange? priceRange,
    Pagination? pagination,
  }) {
    return ProductSearchRequest(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBrands: selectedBrands ?? this.selectedBrands,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      productType: productType ?? this.productType,
      sortOption: sortOption ?? this.sortOption,
      priceRange: priceRange ?? this.priceRange,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [
        searchQuery,
        selectedBrands,
        selectedCategories,
        productType,
        sortOption,
        priceRange,
        pagination,
      ];
}

/// Price range model for filtering
class PriceRange extends Equatable {
  final int min;
  final int max;

  const PriceRange({
    this.min = 0,
    this.max = 100000000,
  });

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: json['min'] as int? ?? 0,
      max: json['max'] as int? ?? 100000000,
    );
  }

  @override
  List<Object?> get props => [min, max];
}

/// Pagination model for API requests
class Pagination extends Equatable {
  final int page;
  final int limit;

  const Pagination({
    this.page = 1,
    this.limit = 40,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
    };
  }

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 40,
    );
  }

  @override
  List<Object?> get props => [page, limit];
}

/// Product search response model
class ProductSearchResponse extends Equatable {
  final bool success;
  final String message;
  final ProductSearchData? data;

  const ProductSearchResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProductSearchResponse.fromJson(Map<String, dynamic> json) {
    return ProductSearchResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ProductSearchData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}

/// Product search data containing products and pagination info
class ProductSearchData extends Equatable {
  final List<Medicine> products;
  final PaginationInfo pagination;
  final AppliedFilters appliedFilters;

  const ProductSearchData({
    required this.products,
    required this.pagination,
    required this.appliedFilters,
  });

  factory ProductSearchData.fromJson(Map<String, dynamic> json) {
    return ProductSearchData(
      products: (json['products'] as List<dynamic>?)
              ?.map(
                  (item) => Medicine.fromApiJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationInfo.fromJson(
          json['pagination'] as Map<String, dynamic>? ?? {}),
      appliedFilters: AppliedFilters.fromJson(
          json['appliedFilters'] as Map<String, dynamic>? ?? {}),
    );
  }

  @override
  List<Object?> get props => [products, pagination, appliedFilters];
}

/// Pagination information from API response
class PaginationInfo extends Equatable {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems: json['totalItems'] as int? ?? 0,
      itemsPerPage: json['itemsPerPage'] as int? ?? 20,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        totalPages,
        totalItems,
        itemsPerPage,
        hasNextPage,
        hasPreviousPage,
      ];
}

/// Applied filters information from API response
class AppliedFilters extends Equatable {
  final String? searchQuery;
  final String? selectedBrands;
  final String? selectedCategories;
  final String? productType;
  final String? sortOption;
  final PriceRange priceRange;
  final bool? requiresPrescription;
  final int activeFilterCount;

  const AppliedFilters({
    this.searchQuery,
    this.selectedBrands,
    this.selectedCategories,
    this.productType,
    this.sortOption,
    this.priceRange = const PriceRange(),
    this.requiresPrescription,
    this.activeFilterCount = 0,
  });

  factory AppliedFilters.fromJson(Map<String, dynamic> json) {
    return AppliedFilters(
      searchQuery: json['searchQuery'] as String?,
      selectedBrands: json['selectedBrands'] as String?,
      selectedCategories: json['selectedCategories'] as String?,
      productType: json['productType'] as String?,
      sortOption: json['sortOption'] as String?,
      priceRange: json['priceRange'] != null
          ? PriceRange.fromJson(json['priceRange'] as Map<String, dynamic>)
          : const PriceRange(),
      requiresPrescription: json['requiresPrescription'] as bool?,
      activeFilterCount: json['activeFilterCount'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        searchQuery,
        selectedBrands,
        selectedCategories,
        productType,
        sortOption,
        priceRange,
        requiresPrescription,
        activeFilterCount,
      ];
}
