import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/medicine.dart';
import '../../widgets/medicine_card.dart';
import '../../APIs/product_api_service.dart';

/// TrendingProductsPage - Display popular and trending medicines
///
/// This page provides:
/// - Grid/List view of trending products
/// - Sorting and filtering options
/// - Add to cart functionality
/// - Search within trending products
/// - Modern UI design matching app theme
class TrendingProductsPage extends StatefulWidget {
  const TrendingProductsPage({super.key});

  @override
  State<TrendingProductsPage> createState() => _TrendingProductsPageState();
}

class _TrendingProductsPageState extends State<TrendingProductsPage> {
  bool _isGridView = true;
  String _sortBy = 'popularity';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text(
          'Trending Products',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'popularity',
                child: Text('Sort by Popularity'),
              ),
              const PopupMenuItem(
                value: 'price_low',
                child: Text('Price: Low to High'),
              ),
              const PopupMenuItem(
                value: 'price_high',
                child: Text('Price: High to Low'),
              ),
              const PopupMenuItem(
                value: 'name',
                child: Text('Name A-Z'),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search trending products...',
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        icon: const Icon(Icons.clear,
                            color: AppColors.textSecondary),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Trending stats header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                FutureBuilder<List<Medicine>>(
                  future: _getFilteredProducts(),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.length ?? 0;
                    return Text(
                      '$count Trending Products',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'HOT',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Products list/grid
          Expanded(
            child: _isGridView ? _buildGridView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return FutureBuilder<List<Medicine>>(
      future: _getFilteredProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading products: ${snapshot.error}'),
          );
        }

        final products = snapshot.data ?? [];

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildTrendingProductCard(product, isGrid: true);
          },
        );
      },
    );
  }

  Widget _buildListView() {
    return FutureBuilder<List<Medicine>>(
      future: _getFilteredProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading products: ${snapshot.error}'),
          );
        }

        final products = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTrendingProductCard(product, isGrid: false),
            );
          },
        );
      },
    );
  }

  Widget _buildTrendingProductCard(Medicine product, {required bool isGrid}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: isGrid ? _buildGridCard(product) : _buildListCard(product),
    );
  }

  Widget _buildGridCard(Medicine product) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with trending badge
          Stack(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.medication,
                  size: 40,
                  color: AppColors.textSecondary,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'HOT',
                    style: TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Product name
          Text(
            product.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Brand
          Text(
            product.brand,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),

          const Spacer(),

          // Price and add to cart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.discountPrice != null)
                    Text(
                      '৳${product.regularPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    '৳${product.effectivePrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _addToCart(product),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.add_shopping_cart,
                    color: AppColors.textOnPrimary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(Medicine product) {
    return MedicineCard(
      medicine: product,
      isFavorite: false,
      cartQuantity: 0,
      onFavoriteToggle: (medicine) {
        // Handle favorite toggle
      },
      onAddToCart: (medicine, quantity) {
        _addToCart(medicine);
      },
    );
  }

  Future<List<Medicine>> _getFilteredProducts() async {
    List<Medicine> products = await _getTrendingProducts();

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      products = products
          .where((product) =>
              product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              product.brand.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Sort products
    switch (_sortBy) {
      case 'price_low':
        products.sort((a, b) => a.effectivePrice.compareTo(b.effectivePrice));
        break;
      case 'price_high':
        products.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));
        break;
      case 'name':
        products.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'popularity':
      default:
        // Keep original order (most popular first)
        break;
    }

    return products;
  }

  Future<List<Medicine>> _getTrendingProducts() async {
    try {
      // Get products with high discounts as trending
      final response = await ProductApiService.getAllProducts(limit: 20);

      if (response.success && response.data != null) {
        final products = response.data!.products;
        // Filter products with discounts as trending
        final trendingProducts = products
            .where((product) =>
                product.discountPrice != null && product.discountPrice! > 0)
            .toList();

        // If we have trending products, return them, otherwise return all products
        return trendingProducts.isNotEmpty ? trendingProducts : products;
      } else {
        // Fallback to mock data if API fails
        return _getMockTrendingProducts();
      }
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockTrendingProducts();
    }
  }

  List<Medicine> _getMockTrendingProducts() {
    // Mock trending products data as fallback
    return [
      const Medicine(
        id: 't1',
        name: 'Paracetamol 500mg',
        quantity: 'Box',
        brand: 'Square',
        regularPrice: 120.0,
        discountPrice: 100.0,
        description: 'Pain relief and fever reducer',
        quantityOptions: [1, 2, 3, 5, 10],
      ),
      const Medicine(
        id: 't2',
        name: 'Vitamin D3 1000 IU',
        quantity: 'Bottle',
        brand: 'Beximco',
        regularPrice: 350.0,
        description: 'Bone health supplement',
        quantityOptions: [1, 2, 3, 5],
      ),
      // Add more trending products...
    ];
  }

  void _addToCart(Medicine product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
