import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/app_drawer.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/medicine_card.dart';
import '../screens/explore_products_page.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import '../bloc/bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Enhanced app bar with proper theming and professional design
      appBar: _buildAppBar(context),
      // Modern, production-grade drawer
      drawer: const AppDrawer(),
      body: BlocBuilder<MedicineCubit, MedicineState>(
        builder: (context, medicineState) {
          return RefreshIndicator(
            onRefresh: () => context.read<MedicineCubit>().refreshMedicines(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner carousel section
                  const BannerCarousel(),

                  const SizedBox(height: 16),

                  if (medicineState is MedicineLoaded) ...[
                    // Brand filters section
                    _buildBrandFiltersSection(context, medicineState),

                    const SizedBox(height: 16),

                    // Quick access section
                    _buildQuickAccessSection(context),

                    const SizedBox(height: 16),

                    // Featured medicines section
                    _buildFeaturedMedicinesSection(context, medicineState),
                  ] else if (medicineState is MedicineLoading) ...[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ] else if (medicineState is MedicineError) ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline,
                                size: 64, color: AppColors.error),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading medicines',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(medicineState.message),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<MedicineCubit>().loadMedicines(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24), // Bottom padding
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Health & Medicine',
        style: TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu,
            color: AppColors.textOnPrimary,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        // Notification icon
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifications feature coming soon!'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textOnPrimary,
          ),
        ),

        // Profile avatar
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile feature coming soon!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.textOnPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person_outline,
                color: AppColors.textOnPrimary,
                size: 20,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12), // Right padding
      ],
    );
  }

  /// Builds brand filters section with see all option
  Widget _buildBrandFiltersSection(BuildContext context, MedicineLoaded state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Menufacturers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => _navigateToExploreProducts(context),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Brand filters (show top 5 brands)
          if (state.brands.isNotEmpty) ...[
            SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.brands.length > 5 ? 5 : state.brands.length,
                itemBuilder: (context, index) {
                  final brand = state.brands[index];
                  final isSelected = state.selectedBrand == brand;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(brand),
                      selected: isSelected,
                      onSelected: (selected) {
                        // Navigate to explore products with brand filter
                        _navigateToExploreProducts(context,
                            selectedBrand: brand);
                      },
                      backgroundColor: AppColors.surfaceVariant,
                      selectedColor: AppColors.primary.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.borderMedium,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds quick access section with special offers and trending
  Widget _buildQuickAccessSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Special Offers
          Expanded(
            child: _buildQuickAccessCard(
              title: 'Special Offers',
              subtitle: 'Up to 50% OFF',
              icon: Icons.local_offer,
              color: AppColors.secondary,
              onTap: () => _navigateToExploreProducts(context,
                  productCategory: 'specialOffer'),
            ),
          ),

          const SizedBox(width: 12),

          // Trending Products
          Expanded(
            child: _buildQuickAccessCard(
              title: 'Trending',
              subtitle: 'Popular medicines',
              icon: Icons.trending_up,
              color: AppColors.accentDark,
              onTap: () => _navigateToExploreProducts(context,
                  productCategory: 'trending'),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual quick access card
  Widget _buildQuickAccessCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds featured medicines section with limited items and "View All" button
  Widget _buildFeaturedMedicinesSection(
      BuildContext context, MedicineLoaded state) {
    // Show only first 3-4 medicines as featured
    final featuredMedicines = state.medicines.take(4).toList();

    return Column(
      children: [
        // Section header
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Selling Medicines',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => _navigateToExploreProducts(context),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Featured medicines list
        BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, favoritesState) {
            return BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                final favorites = <String, bool>{};
                final cartItems = <String, int>{};

                if (favoritesState is FavoritesLoaded) {
                  for (final item in favoritesState.items) {
                    favorites[item.id] = true;
                  }
                }

                if (cartState is CartLoaded) {
                  for (final item in cartState.items) {
                    cartItems[item.id] = item.cartQuantity;
                  }
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: featuredMedicines.length,
                  itemBuilder: (context, index) {
                    final medicine = featuredMedicines[index];
                    return MedicineCard(
                      medicine: medicine,
                      isFavorite: favorites[medicine.id] ?? false,
                      cartQuantity: cartItems[medicine.id] ?? 0,
                      onFavoriteToggle: (medicine) => context
                          .read<FavoritesCubit>()
                          .toggleFavorite(medicine),
                      onAddToCart: (medicine, quantity) => context
                          .read<CartCubit>()
                          .addToCart(medicine, quantity),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// Navigate to explore products page with optional filters
  void _navigateToExploreProducts(
    BuildContext context, {
    String? searchQuery,
    String? selectedBrand,
    String? productCategory,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) {
            final cubit = ExploreProductsCubit();
            // Load products first
            cubit.loadProducts().then((_) {
              // Apply filters after products are loaded
              if (searchQuery != null && searchQuery.isNotEmpty) {
                cubit.updateSearchText(searchQuery);
              }
              if (selectedBrand != null) {
                final currentState = cubit.state;
                if (currentState is ExploreProductsLoaded) {
                  final newFilter = currentState.currentFilter.copyWith(
                    selectedBrands: [selectedBrand],
                  );
                  cubit.applyFilter(newFilter);
                }
              }
              if (productCategory != null) {
                ProductCategory category;
                switch (productCategory) {
                  case 'specialOffer':
                    category = ProductCategory.specialOffer;
                    break;
                  case 'trending':
                    category = ProductCategory.trending;
                    break;
                  case 'newProduct':
                    category = ProductCategory.newProduct;
                    break;
                  default:
                    category = ProductCategory.all;
                }
                cubit.updateProductCategory(category);
              }
            });
            return cubit;
          },
          child: const ExploreProductsPage(),
        ),
      ),
    );
  }
}
