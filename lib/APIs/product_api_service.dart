import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'api_config.dart';

/// Product API Service
///
/// This service handles all product-related API calls including
/// product search with proper error handling and response parsing.
class ProductApiService {
  /// Search products with filters
  ///
  /// Takes a [ProductSearchRequest] and sends it to the products search endpoint.
  /// Returns a [ProductSearchResponse] with products data and pagination info.
  static Future<ProductSearchResponse> searchProducts(
      ProductSearchRequest request) async {
    try {
      // Make the HTTP POST request
      final response = await http
          .post(
            Uri.parse(ApiConfig.productsSearchUrl),
            headers: ApiConfig.headers,
            body: json.encode(request.toJson()),
          )
          .timeout(ApiConfig.requestTimeout);

      // Parse the response
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Request successful
        return ProductSearchResponse.fromJson(responseData);
      } else {
        // Request failed
        final errorMessage = responseData['message'] ??
            responseData['error'] ??
            'Failed to load products. Please try again.';
        return ProductSearchResponse(
          success: false,
          message: errorMessage,
        );
      }
    } on SocketException {
      return const ProductSearchResponse(
        success: false,
        message:
            'No internet connection. Please check your network and try again.',
      );
    } on http.ClientException {
      return const ProductSearchResponse(
        success: false,
        message: 'Network error. Please try again.',
      );
    } on FormatException {
      return const ProductSearchResponse(
        success: false,
        message: 'Invalid response from server. Please try again.',
      );
    } catch (e) {
      return const ProductSearchResponse(
        success: false,
        message: 'Failed to load products. Please try again.',
      );
    }
  }

  /// Get all products (no filters)
  ///
  /// Convenience method to get all products without any filters applied.
  static Future<ProductSearchResponse> getAllProducts({
    int page = 1,
    int limit = 40,
  }) async {
    final request = ProductSearchRequest(
      pagination: Pagination(page: page, limit: limit),
    );
    return searchProducts(request);
  }

  /// Search products by query
  ///
  /// Convenience method to search products by name or brand.
  static Future<ProductSearchResponse> searchProductsByQuery(
    String query, {
    int page = 1,
    int limit = 40,
  }) async {
    final request = ProductSearchRequest(
      searchQuery: query,
      pagination: Pagination(page: page, limit: limit),
    );
    return searchProducts(request);
  }

  /// Get products by brand
  ///
  /// Convenience method to filter products by specific brands.
  static Future<ProductSearchResponse> getProductsByBrands(
    List<String> brands, {
    int page = 1,
    int limit = 40,
  }) async {
    final request = ProductSearchRequest(
      selectedBrands: brands.join(','),
      pagination: Pagination(page: page, limit: limit),
    );
    return searchProducts(request);
  }

  /// Get products by category
  ///
  /// Convenience method to filter products by specific categories.
  static Future<ProductSearchResponse> getProductsByCategories(
    List<String> categories, {
    int page = 1,
    int limit = 20,
  }) async {
    final request = ProductSearchRequest(
      selectedCategories: categories.join(','),
      pagination: Pagination(page: page, limit: limit),
    );
    return searchProducts(request);
  }

  /// Get products by type
  ///
  /// Convenience method to filter products by product type (Tablet, Capsule, etc.).
  static Future<ProductSearchResponse> getProductsByType(
    String productType, {
    int page = 1,
    int limit = 40,
  }) async {
    final request = ProductSearchRequest(
      productType: productType,
      pagination: Pagination(page: page, limit: limit),
    );
    return searchProducts(request);
  }

  /// Get products with price range
  ///
  /// Convenience method to filter products by price range.
  static Future<ProductSearchResponse> getProductsByPriceRange(
    int minPrice,
    int maxPrice, {
    int page = 1,
    int limit = 40,
  }) async {
    final request = ProductSearchRequest(
      priceRange: PriceRange(min: minPrice, max: maxPrice),
      pagination: Pagination(page: page, limit: limit),
    );
    return searchProducts(request);
  }

  /// Get products with sorting
  ///
  /// Convenience method to get products with specific sorting applied.
  static Future<ProductSearchResponse> getProductsWithSort(
    String sortOption, {
    int page = 1,
    int limit = 40,
  }) async {
    final request = ProductSearchRequest(
      sortOption: sortOption,
      pagination: Pagination(page: page, limit: limit),
    );
    return searchProducts(request);
  }

  /// Convert local ProductFilter to API ProductSearchRequest
  ///
  /// Helper method to convert the app's ProductFilter model to API request format.
  static ProductSearchRequest convertFilterToRequest(
    ProductFilter filter, {
    int page = 1,
    int limit = 40,
  }) {
    return ProductSearchRequest(
      searchQuery: filter.searchQuery ?? '',
      selectedBrands: filter.selectedBrands.join(','),
      selectedCategories: filter.selectedCategories.join(','),
      productType: _convertProductCategoryToType(filter.productCategory),
      sortOption: _convertSortOptionToString(filter.sortOption),
      pagination: Pagination(page: page, limit: limit),
    );
  }

  /// Convert ProductCategory enum to API product type string
  static String _convertProductCategoryToType(ProductCategory category) {
    switch (category) {
      case ProductCategory.all:
        return '';
      case ProductCategory.trending:
        return 'trending';
      case ProductCategory.specialOffer:
        return 'special_offer';
      case ProductCategory.newProduct:
        return 'new_product';
    }
  }

  /// Convert SortOption enum to API sort string
  static String _convertSortOptionToString(SortOption sortOption) {
    switch (sortOption) {
      case SortOption.nameAtoZ:
        return 'name_a_to_z'; // Default case in backend
      case SortOption.nameZtoA:
        return 'name_z_to_a';
      case SortOption.priceLowToHigh:
        return 'price_low_to_high';
      case SortOption.priceHighToLow:
        return 'price_high_to_low';
      case SortOption.discountHighToLow:
        return 'discount_desc';
      case SortOption.discountLowToHigh:
        return 'discount_asc';
      case SortOption.deliveryDate1:
      case SortOption.deliveryDate2:
      case SortOption.deliveryDate3:
        return 'delivery_date';
    }
  }
}
