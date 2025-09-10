import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';
import '../../APIs/product_api_service.dart';
import '../../APIs/brand_api_service.dart';
import '../../APIs/cart_api_service.dart';

/// States for explore products
abstract class ExploreProductsState extends Equatable {
  const ExploreProductsState();

  @override
  List<Object?> get props => [];
}

class ExploreProductsInitial extends ExploreProductsState {
  const ExploreProductsInitial();
}

class ExploreProductsLoading extends ExploreProductsState {
  const ExploreProductsLoading();
}

class ExploreProductsLoaded extends ExploreProductsState {
  final List<Medicine> allProducts;
  final List<Medicine> filteredProducts;
  final List<String> availableBrands;
  final List<String> availableCategories;
  final ProductFilter currentFilter;
  final Map<String, bool> favorites;
  final Map<String, int> cartItems;
  final int currentPage;
  final bool hasMorePages;
  final bool isLoadingMore;
  final bool isSearching;
  final String searchText; // Separate from filter for UI display

  const ExploreProductsLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required this.availableBrands,
    required this.availableCategories,
    required this.currentFilter,
    this.favorites = const {},
    this.cartItems = const {},
    this.currentPage = 1,
    this.hasMorePages = true,
    this.isLoadingMore = false,
    this.isSearching = false,
    this.searchText = '',
  });

  ExploreProductsLoaded copyWith({
    List<Medicine>? allProducts,
    List<Medicine>? filteredProducts,
    List<String>? availableBrands,
    List<String>? availableCategories,
    ProductFilter? currentFilter,
    Map<String, bool>? favorites,
    Map<String, int>? cartItems,
    int? currentPage,
    bool? hasMorePages,
    bool? isLoadingMore,
    bool? isSearching,
    String? searchText,
  }) {
    return ExploreProductsLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      availableBrands: availableBrands ?? this.availableBrands,
      availableCategories: availableCategories ?? this.availableCategories,
      currentFilter: currentFilter ?? this.currentFilter,
      favorites: favorites ?? this.favorites,
      cartItems: cartItems ?? this.cartItems,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSearching: isSearching ?? this.isSearching,
      searchText: searchText ?? this.searchText,
    );
  }

  @override
  List<Object?> get props => [
        allProducts,
        filteredProducts,
        availableBrands,
        availableCategories,
        currentFilter,
        favorites,
        cartItems,
        currentPage,
        hasMorePages,
        isLoadingMore,
        isSearching,
        searchText,
      ];
}

class ExploreProductsError extends ExploreProductsState {
  final String message;

  const ExploreProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Cubit for managing explore products functionality
class ExploreProductsCubit extends Cubit<ExploreProductsState> {
  Timer? _searchDebounceTimer;

  ExploreProductsCubit() : super(const ExploreProductsInitial());

  @override
  Future<void> close() {
    _searchDebounceTimer?.cancel();
    return super.close();
  }

  /// Load initial products with pagination
  Future<void> loadProducts() async {
    emit(const ExploreProductsLoading());

    try {
      print('🔄 Loading initial products from API...');
      // Call the real API to get first page of products (40 products)
      final response =
          await ProductApiService.getAllProducts(page: 1, limit: 40);

      if (response.success && response.data != null) {
        final products = response.data!.products;
        final paginationInfo = response.data!.pagination;
        print(
            '✅ Successfully loaded ${products.length} products from API (Page 1)');

        final brands = await _loadBrandsFromAPI();
        final categories = _extractCategories(products);
        const initialFilter = ProductFilter();

        emit(ExploreProductsLoaded(
          allProducts: products,
          filteredProducts: products, // Initially show all loaded products
          availableBrands: brands,
          availableCategories: categories,
          currentFilter: initialFilter,
          currentPage: 1,
          hasMorePages: paginationInfo.currentPage < paginationInfo.totalPages,
        ));
      } else {
        // If API fails, show error - no dummy data
        print('❌ API failed to load products: ${response.message}');
        emit(ExploreProductsError(message: response.message));
      }
    } catch (e) {
      // If API fails, show error - no dummy data
      print('💥 Error loading products: $e');
      emit(const ExploreProductsError(
          message:
              'Failed to load products. Please check your internet connection and try again.'));
    }
  }

  /// Load more products for pagination
  Future<void> loadMoreProducts() async {
    final currentState = state;
    if (currentState is! ExploreProductsLoaded ||
        currentState.isLoadingMore ||
        !currentState.hasMorePages) {
      return;
    }

    // Set loading more state
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      print('🔄 Loading more products from API (Page $nextPage)...');

      // Load next page with current filter applied
      final request = ProductApiService.convertFilterToRequest(
        currentState.currentFilter,
        page: nextPage,
        limit: 40,
      );
      final response = await ProductApiService.searchProducts(request);

      if (response.success && response.data != null) {
        final newProducts = response.data!.products;
        final paginationInfo = response.data!.pagination;
        print(
            '✅ Successfully loaded ${newProducts.length} more products (Page $nextPage)');

        // Combine existing products with new products
        final updatedAllProducts = [
          ...currentState.allProducts,
          ...newProducts
        ];
        final updatedFilteredProducts = [
          ...currentState.filteredProducts,
          ...newProducts
        ];

        emit(currentState.copyWith(
          allProducts: updatedAllProducts,
          filteredProducts: updatedFilteredProducts,
          currentPage: nextPage,
          hasMorePages: paginationInfo.currentPage < paginationInfo.totalPages,
          isLoadingMore: false,
        ));
      } else {
        print('❌ Failed to load more products: ${response.message}');
        emit(currentState.copyWith(isLoadingMore: false));
      }
    } catch (e) {
      print('💥 Error loading more products: $e');
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Apply filters and update state (resets pagination)
  Future<void> applyFilter(ProductFilter filter) async {
    final currentState = state;
    if (currentState is ExploreProductsLoaded) {
      try {
        print('🔄 Applying filters: ${filter.toString()}');
        // Convert filter to API request and search (reset to page 1)
        final request = ProductApiService.convertFilterToRequest(filter,
            page: 1, limit: 40);
        final response = await ProductApiService.searchProducts(request);

        if (response.success && response.data != null) {
          final filteredProducts = response.data!.products;
          final paginationInfo = response.data!.pagination;
          print('✅ API filter returned ${filteredProducts.length} products');
          emit(currentState.copyWith(
            allProducts:
                filteredProducts, // Reset all products to filtered results
            filteredProducts: filteredProducts,
            currentFilter: filter,
            currentPage: 1, // Reset to page 1
            hasMorePages:
                paginationInfo.currentPage < paginationInfo.totalPages,
            isLoadingMore: false,
            isSearching: false, // Reset searching state
          ));
        } else {
          // If API fails, fall back to local filtering
          print('⚠️ API filter failed, applying filters locally');
          final filteredProducts =
              _applyFilters(currentState.allProducts, filter);
          emit(currentState.copyWith(
            filteredProducts: filteredProducts,
            currentFilter: filter,
            currentPage: 1, // Reset to page 1
            hasMorePages: false, // No pagination for local filtering
            isLoadingMore: false,
            isSearching: false, // Reset searching state
          ));
        }
      } catch (e) {
        // If API fails, fall back to local filtering
        print('💥 Error applying filters: $e');
        final filteredProducts =
            _applyFilters(currentState.allProducts, filter);
        emit(currentState.copyWith(
          filteredProducts: filteredProducts,
          currentFilter: filter,
          currentPage: 1, // Reset to page 1
          hasMorePages: false, // No pagination for local filtering
          isLoadingMore: false,
          isSearching: false, // Reset searching state
        ));
      }
    }
  }

  /// Update search text immediately (for UI display)
  void updateSearchText(String searchText) {
    final currentState = state;
    if (currentState is ExploreProductsLoaded) {
      emit(currentState.copyWith(searchText: searchText));

      // Cancel previous timer
      _searchDebounceTimer?.cancel();

      // Start new timer for debounced search
      _searchDebounceTimer = Timer(const Duration(milliseconds: 800), () {
        _performSearch(searchText);
      });
    }
  }

  /// Perform the actual search with API call
  Future<void> _performSearch(String query) async {
    final currentState = state;
    if (currentState is ExploreProductsLoaded) {
      // Set searching state
      emit(currentState.copyWith(isSearching: true));

      try {
        final newFilter =
            currentState.currentFilter.copyWith(searchQuery: query);
        await applyFilter(newFilter);
      } catch (e) {
        print('💥 Error performing search: $e');
        // Reset searching state on error
        emit(currentState.copyWith(isSearching: false));
      }
    }
  }

  /// Clear search immediately
  void clearSearch() {
    _searchDebounceTimer?.cancel();
    final currentState = state;
    if (currentState is ExploreProductsLoaded) {
      emit(currentState.copyWith(searchText: ''));
      final newFilter = currentState.currentFilter.copyWith(searchQuery: '');
      applyFilter(newFilter);
    }
  }

  /// Update product category filter
  void updateProductCategory(ProductCategory category) {
    final currentState = state;
    if (currentState is ExploreProductsLoaded) {
      final newFilter =
          currentState.currentFilter.copyWith(productCategory: category);
      applyFilter(newFilter);
    }
  }

  /// Clear all filters
  void clearFilters() {
    final currentState = state;
    if (currentState is ExploreProductsLoaded) {
      applyFilter(const ProductFilter());
    }
  }

  /// Toggle favorite status
  void toggleFavorite(Medicine product) {
    final currentState = state;
    if (currentState is ExploreProductsLoaded) {
      final newFavorites = Map<String, bool>.from(currentState.favorites);
      newFavorites[product.id] = !(newFavorites[product.id] ?? false);
      emit(currentState.copyWith(favorites: newFavorites));
    }
  }

  /// Add to cart with API integration
  Future<void> addToCart(Medicine product, int quantity,
      {int? customerId}) async {
    final currentState = state;
    if (currentState is ExploreProductsLoaded) {
      try {
        // Use provided customerId or default to 1 for development
        final customerIdToUse = customerId ?? 1;

        // Parse product ID to int
        final productId = int.tryParse(product.id) ?? 1;

        // Make API call
        final apiResponse = await CartApiService.addToCart(
          productId: productId,
          customerId: customerIdToUse,
          quantity: quantity,
        );

        if (apiResponse.success) {
          // Update local cart state on successful API call
          final newCartItems = Map<String, int>.from(currentState.cartItems);
          // Set the quantity instead of adding to existing quantity
          newCartItems[product.id] = quantity;
          emit(currentState.copyWith(cartItems: newCartItems));
        } else {
          // API call failed - you might want to show an error message
          print('❌ Failed to add to cart: ${apiResponse.message}');
        }
      } catch (e) {
        // Handle error - you might want to show an error message
        print('💥 Error adding to cart: $e');
      }
    }
  }

  /// Apply filters to product list
  List<Medicine> _applyFilters(List<Medicine> products, ProductFilter filter) {
    var filtered = List<Medicine>.from(products);

    // Apply search query filter
    if (filter.searchQuery?.isNotEmpty == true) {
      final query = filter.searchQuery!.toLowerCase();
      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.brand.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
      }).toList();
    }

    // Apply brand filter
    if (filter.selectedBrands.isNotEmpty) {
      filtered = filtered.where((product) {
        return filter.selectedBrands.contains(product.brand);
      }).toList();
    }

    // Apply product category filter
    filtered = _applyProductCategoryFilter(filtered, filter.productCategory);

    // Apply sorting
    filtered = _applySorting(filtered, filter.sortOption);

    return filtered;
  }

  /// Apply product category filter based on productTag from API
  List<Medicine> _applyProductCategoryFilter(
      List<Medicine> products, ProductCategory category) {
    switch (category) {
      case ProductCategory.all:
        // Show all products regardless of productTag
        return products;
      case ProductCategory.trending:
        // Filter products with productTag = "trending"
        return products.where((p) => p.productTag == 'trending').toList();
      case ProductCategory.specialOffer:
        // Filter products with productTag = "special_offer"
        return products.where((p) => p.productTag == 'special_offer').toList();
      case ProductCategory.newProduct:
        // Filter products with productTag = "top_selling"
        return products.where((p) => p.productTag == 'top_selling').toList();
    }
  }

  /// Load brands from API
  Future<List<String>> _loadBrandsFromAPI() async {
    try {
      print('🔄 Loading brands from API...');
      final brandNames = await BrandApiService.getBrandNames();
      print('✅ Successfully loaded ${brandNames.length} brands from API');
      return brandNames;
    } catch (e) {
      print('❌ Error loading brands from API: $e');
      // Return empty list if API fails
      return [];
    }
  }

  /// Apply sorting to product list
  List<Medicine> _applySorting(List<Medicine> products, SortOption sortOption) {
    final sorted = List<Medicine>.from(products);

    switch (sortOption) {
      case SortOption.nameAtoZ:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameZtoA:
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.priceLowToHigh:
        sorted.sort((a, b) => a.effectivePrice.compareTo(b.effectivePrice));
        break;
      case SortOption.priceHighToLow:
        sorted.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));
        break;
      case SortOption.discountHighToLow:
        sorted.sort(
            (a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
      case SortOption.discountLowToHigh:
        sorted.sort(
            (a, b) => a.discountPercentage.compareTo(b.discountPercentage));
        break;
      case SortOption.deliveryDate1:
      case SortOption.deliveryDate2:
      case SortOption.deliveryDate3:
        // For demo, keep original order for delivery dates
        break;
    }

    return sorted;
  }

  /// Extract unique categories from products list
  List<String> _extractCategories(List<Medicine> products) {
    // For demo purposes, create categories based on product types
    final categories = <String>{'Tablet', 'Capsule', 'Syrup', 'Injection'};
    return categories.toList()..sort();
  }
}
