import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';

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

  const ExploreProductsLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required this.availableBrands,
    required this.availableCategories,
    required this.currentFilter,
    this.favorites = const {},
    this.cartItems = const {},
  });

  ExploreProductsLoaded copyWith({
    List<Medicine>? allProducts,
    List<Medicine>? filteredProducts,
    List<String>? availableBrands,
    List<String>? availableCategories,
    ProductFilter? currentFilter,
    Map<String, bool>? favorites,
    Map<String, int>? cartItems,
  }) {
    return ExploreProductsLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      availableBrands: availableBrands ?? this.availableBrands,
      availableCategories: availableCategories ?? this.availableCategories,
      currentFilter: currentFilter ?? this.currentFilter,
      favorites: favorites ?? this.favorites,
      cartItems: cartItems ?? this.cartItems,
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
  ExploreProductsCubit() : super(const ExploreProductsInitial());

  /// Load all products
  Future<void> loadProducts() async {
    emit(const ExploreProductsLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get sample products (using same data as medicine cubit for consistency)
      final products = _getSampleProducts();
      final brands = _extractBrands(products);
      final categories = _extractCategories(products);
      const initialFilter = ProductFilter();

      final filteredProducts = _applyFilters(products, initialFilter);

      emit(ExploreProductsLoaded(
        allProducts: products,
        filteredProducts: filteredProducts,
        availableBrands: brands,
        availableCategories: categories,
        currentFilter: initialFilter,
      ));
    } catch (e) {
      emit(ExploreProductsError(
          message: 'Failed to load products: ${e.toString()}'));
    }
  }

  /// Apply filters and update state
  void applyFilter(ProductFilter filter) {
    final currentState = state;
    if (currentState is ExploreProductsLoaded) {
      final filteredProducts = _applyFilters(currentState.allProducts, filter);
      emit(currentState.copyWith(
        filteredProducts: filteredProducts,
        currentFilter: filter,
      ));
    }
  }

  /// Update search query
  void updateSearchQuery(String query) {
    final currentState = state;
    if (currentState is ExploreProductsLoaded) {
      final newFilter = currentState.currentFilter.copyWith(searchQuery: query);
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

  /// Add to cart
  void addToCart(Medicine product, int quantity) {
    final currentState = state;
    if (currentState is ExploreProductsLoaded) {
      final newCartItems = Map<String, int>.from(currentState.cartItems);
      newCartItems[product.id] = (newCartItems[product.id] ?? 0) + quantity;
      emit(currentState.copyWith(cartItems: newCartItems));
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

  /// Apply product category filter (All, Trending, Special Offer, New Product)
  List<Medicine> _applyProductCategoryFilter(
      List<Medicine> products, ProductCategory category) {
    switch (category) {
      case ProductCategory.all:
        return products;
      case ProductCategory.trending:
        // For demo, return products with high discount or popular brands
        return products
            .where((p) => p.discountPercentage > 20 || p.brand == 'Square')
            .toList();
      case ProductCategory.specialOffer:
        // Return products with discounts
        return products.where((p) => p.hasDiscount).toList();
      case ProductCategory.newProduct:
        // For demo, return last few products as "new"
        return products.length > 3
            ? products.sublist(products.length - 3)
            : products;
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

  /// Get sample products (extended from medicine cubit)
  List<Medicine> _getSampleProducts() {
    return [
      const Medicine(
        id: '1',
        name: '3 F 500 (20 Pcs) 500 mg',
        quantity: 'Strip',
        brand: 'Levofloxacin Hemihydrate Edruc Ltd.',
        regularPrice: 320.00,
        discountPrice: 154.22,
        imageUrl:
            'https://via.placeholder.com/150x150/E3F2FD/1976D2?text=3F500',
        description: 'Tablet - Levofloxacin Hemihydrate',
        requiresPrescription: false,
        quantityOptions: [1, 2, 3, 5, 10, 15, 20],
      ),
      const Medicine(
        id: '2',
        name: '3-C 200 (3 C 200) (12 Pcs) 200 mg',
        quantity: 'Strip',
        brand: 'Cefixime Trihydrate Edruc Ltd.',
        regularPrice: 420.00,
        discountPrice: 203.98,
        imageUrl:
            'https://via.placeholder.com/150x150/FFF3E0/F57C00?text=3C200',
        description: 'Capsule - Cefixime Trihydrate',
        requiresPrescription: true,
        quantityOptions: [1, 2, 3, 5, 10],
      ),
      const Medicine(
        id: '3',
        name: '3rd cef 200 (12 pcs) 200mg',
        quantity: 'Strip',
        brand: 'Cefixime Medimet Pharmaceuticals LTD.',
        regularPrice: 324.00,
        discountPrice: 159.2,
        imageUrl:
            'https://via.placeholder.com/150x150/E8F5E8/4CAF50?text=3RDCEF',
        description: 'Tablet - Cefixime',
        requiresPrescription: false,
        quantityOptions: [1, 2, 3, 5, 10, 15],
      ),
      const Medicine(
        id: '4',
        name: 'A B1 100 (100 Pcs) 100 mg',
        quantity: 'Bottle',
        brand: 'Thiamine Hydrochloride Acme Laboratories LTD.',
        regularPrice: 250.00,
        discountPrice: 215.00,
        imageUrl: 'https://via.placeholder.com/150x150/FFF8E1/FFC107?text=AB1',
        description: 'Tablet - Thiamine Hydrochloride',
        requiresPrescription: false,
        quantityOptions: [1, 2, 3, 6, 12],
      ),
      // Add more sample products for better demo
      const Medicine(
        id: '5',
        name: 'Tablet- Napa',
        quantity: 'Box',
        brand: 'Square',
        regularPrice: 50.00,
        imageUrl: 'https://via.placeholder.com/150x150/E1F5FE/0277BD?text=NAPA',
        description: 'Paracetamol for pain and fever',
        requiresPrescription: false,
        quantityOptions: [1, 3, 5, 10, 20, 30, 50],
      ),
      const Medicine(
        id: '6',
        name: 'Syrup- Reneta-B',
        quantity: 'Bottle',
        brand: 'Renata',
        regularPrice: 630.00,
        discountPrice: 500.00,
        imageUrl:
            'https://via.placeholder.com/150x150/FCE4EC/E91E63?text=SYRUP',
        description: 'Vitamin B complex syrup',
        requiresPrescription: false,
        quantityOptions: [1, 2, 3, 4, 5],
      ),
      const Medicine(
        id: '7',
        name: 'Tablet- Vitamin D3',
        quantity: '1000 IU',
        brand: 'HealthKart',
        regularPrice: 1250.00,
        discountPrice: 990.00,
        imageUrl: 'https://via.placeholder.com/150x150/FFF9C4/F9A825?text=VIT',
        description: 'Vitamin D3 supplement',
        requiresPrescription: false,
      ),
      const Medicine(
        id: '8',
        name: 'Tablet- Ace',
        quantity: 'Box',
        brand: 'Square',
        regularPrice: 410.00,
        imageUrl: 'https://via.placeholder.com/150x150/F3E5F5/8E24AA?text=ACE',
        description: 'ACE inhibitor for blood pressure',
        requiresPrescription: true,
      ),
    ];
  }

  /// Extract unique brands from products list
  List<String> _extractBrands(List<Medicine> products) {
    final brands = products.map((product) => product.brand).toSet().toList();
    brands.sort();
    return brands;
  }

  /// Extract unique categories from products list
  List<String> _extractCategories(List<Medicine> products) {
    // For demo purposes, create categories based on product types
    final categories = <String>{'Tablet', 'Capsule', 'Syrup', 'Injection'};
    return categories.toList()..sort();
  }
}
