import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// FavoritesPage - User's favorite medicines
///
/// This page provides:
/// - List of favorited medicines
/// - Quick add to cart functionality
/// - Remove from favorites option
/// - Empty favorites state
/// - Modern design matching app theme
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // Sample favorite items
  List<FavoriteItem> _favoriteItems = [
    FavoriteItem(
      id: '1',
      name: 'Tablet- Acipro',
      quantity: 'Box',
      brand: 'Square',
      price: 410.00,
      originalPrice: 500.00,
      imageUrl: 'https://via.placeholder.com/80x80/E3F2FD/1976D2?text=ACIPRO',
      addedDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    FavoriteItem(
      id: '2',
      name: 'Syrup- Asthalin',
      quantity: '100ml',
      brand: 'Renata',
      price: 230.00,
      originalPrice: 360.00,
      imageUrl: 'https://via.placeholder.com/80x80/E8F5E8/4CAF50?text=SYRUP',
      addedDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    FavoriteItem(
      id: '3',
      name: 'Capsule- Amoxicillin',
      quantity: '500ml',
      brand: 'Beximco',
      price: 410.00,
      originalPrice: 600.00,
      imageUrl: 'https://via.placeholder.com/80x80/FFF8E1/FFC107?text=CAPS',
      addedDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    FavoriteItem(
      id: '4',
      name: 'Syrup- Reneta-B',
      quantity: '250ml',
      brand: 'Renata',
      price: 500.00,
      originalPrice: 630.00,
      imageUrl: 'https://via.placeholder.com/80x80/FCE4EC/E91E63?text=SYRUP',
      addedDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
    FavoriteItem(
      id: '5',
      name: 'Tablet- Vitamin D3',
      quantity: '1000 IU',
      brand: 'HealthKart',
      price: 990.00,
      originalPrice: 1250.00,
      imageUrl: 'https://via.placeholder.com/80x80/FFF9C4/F9A825?text=VIT',
      addedDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _favoriteItems.isEmpty
          ? _buildEmptyFavorites()
          : _buildFavoritesContent(),
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'My Favorites (${_favoriteItems.length})',
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        if (_favoriteItems.isNotEmpty)
          IconButton(
            onPressed: _clearAllFavorites,
            icon: const Icon(
              Icons.clear_all,
              color: AppColors.textOnPrimary,
            ),
          ),
      ],
    );
  }

  /// Builds the favorites content
  Widget _buildFavoritesContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favoriteItems.length,
      itemBuilder: (context, index) {
        final item = _favoriteItems[index];
        return _buildFavoriteItemCard(item, index);
      },
    );
  }

  /// Builds individual favorite item card
  Widget _buildFavoriteItemCard(FavoriteItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.medication,
                      color: AppColors.textSecondary,
                      size: 28,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.name} (${item.quantity})',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  Text(
                    item.brand.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Price
                  Row(
                    children: [
                      if (item.originalPrice > item.price)
                        Text(
                          '৳ ${item.originalPrice.toStringAsFixed(item.originalPrice.truncateToDouble() == item.originalPrice ? 0 : 2)}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      if (item.originalPrice > item.price)
                        const SizedBox(width: 8),
                      Text(
                        '৳ ${item.price.toStringAsFixed(item.price.truncateToDouble() == item.price ? 0 : 2)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Added date
                  Text(
                    'Added ${_getTimeAgo(item.addedDate)}',
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Column(
              children: [
                // Remove from favorites
                GestureDetector(
                  onTap: () => _removeFromFavorites(index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: AppColors.error,
                      size: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Add to cart
                GestureDetector(
                  onTap: () => _addToCart(item),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowLight,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.textOnPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds empty favorites state
  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_outline,
              size: 64,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No favorites yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start adding medicines to your favorites',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Removes item from favorites
  void _removeFromFavorites(int index) {
    final item = _favoriteItems[index];
    setState(() {
      _favoriteItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed from favorites'),
        backgroundColor: AppColors.error,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.textOnPrimary,
          onPressed: () {
            setState(() {
              _favoriteItems.insert(index, item);
            });
          },
        ),
      ),
    );
  }

  /// Adds item to cart
  void _addToCart(FavoriteItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  /// Clears all favorites
  void _clearAllFavorites() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _favoriteItems.clear();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  /// Gets time ago string
  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Today';
    }
  }
}

/// Favorite item data model
class FavoriteItem {
  final String id;
  final String name;
  final String quantity;
  final String brand;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final DateTime addedDate;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.addedDate,
  });
}
