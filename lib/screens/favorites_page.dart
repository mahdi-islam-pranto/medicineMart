import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../widgets/app_drawer.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import '../utils/image_preview_utils.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const AppDrawer(),
      body: BlocListener<FavoritesCubit, FavoritesState>(
        listener: (context, state) {
          if (state is FavoritesOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is FavoritesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoritesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    const Text('Error loading favorites'),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<FavoritesCubit>().loadFavorites(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is FavoritesLoaded) {
              return state.isEmpty
                  ? _buildEmptyFavorites()
                  : _buildFavoritesContent(state.items);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          final itemCount = state is FavoritesLoaded ? state.totalItems : 0;
          final hasItems = state is FavoritesLoaded && state.isNotEmpty;

          return AppBar(
            title: Text(
              'My Favorites ($itemCount)',
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
              if (hasItems)
                IconButton(
                  onPressed: _clearAllFavorites,
                  icon: const Icon(
                    Icons.clear_all,
                    color: AppColors.textOnPrimary,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Builds the favorites content
  Widget _buildFavoritesContent(List<FavoriteItem> favoriteItems) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteItems.length,
      itemBuilder: (context, index) {
        final item = favoriteItems[index];
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
            // Product image with long press preview
            GestureDetector(
              onLongPress: () => ImagePreviewUtils.showImagePreview(
                context,
                imageUrl: item.imageUrl.isNotEmpty ? item.imageUrl : null,
                medicineName: item.name,
                brand: item.brand,
                discountPercentage: item.hasDiscount
                    ? item.discountPercentage.toDouble()
                    : null,
              ),
              child: Container(
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
                  onTap: () => _removeFromFavorites(item),
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
  void _removeFromFavorites(FavoriteItem item) {
    context.read<FavoritesCubit>().removeFromFavorites(item.id);
  }

  /// Adds item to cart
  void _addToCart(FavoriteItem item) async {
    // Store context reference before async call
    final cartCubit = context.read<CartCubit>();

    // Convert FavoriteItem to Medicine for cart
    final medicine = Medicine(
      id: item.id,
      name: item.name,
      genericName: item.genericName,
      quantity: item.quantity,
      brand: item.brand,
      regularPrice: item.originalPrice,
      discountPrice: item.price < item.originalPrice ? item.price : null,
      description: '', // Description not available in FavoriteItem
      quantityOptions: const [1, 2, 3, 5, 10], // Default options
    );

    // Add to cart with default quantity of 1
    await cartCubit.addToCart(medicine, 1);

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} added to cart'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
              context.read<FavoritesCubit>().clearAllFavorites();
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
