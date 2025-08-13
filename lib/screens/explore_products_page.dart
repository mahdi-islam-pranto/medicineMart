import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import '../bloc/bloc.dart';
import '../widgets/medicine_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/sort_bottom_sheet.dart';

/// Explore Products Page - A comprehensive product browsing experience
///
/// This page provides:
/// - Search functionality with real-time filtering
/// - Category tabs (All, Trending, Special Offer, New Product)
/// - Filter and sort options
/// - Modern product grid layout
/// - Professional design matching app theme
class ExploreProductsPage extends StatefulWidget {
  const ExploreProductsPage({super.key});

  @override
  State<ExploreProductsPage> createState() => _ExploreProductsPageState();
}

class _ExploreProductsPageState extends State<ExploreProductsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Load products when page initializes
    context.read<ExploreProductsCubit>().loadProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: BlocBuilder<ExploreProductsCubit, ExploreProductsState>(
        builder: (context, state) {
          if (state is ExploreProductsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ExploreProductsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading products',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExploreProductsCubit>().loadProducts();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ExploreProductsLoaded) {
            return Column(
              children: [
                // Search bar
                _buildSearchBar(state),
                
                // Category tabs
                _buildCategoryTabs(state),
                
                // Filter and sort bar
                _buildFilterSortBar(state),
                
                // Products list
                Expanded(
                  child: _buildProductsList(state),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      title: const Text(
        'Explore Products',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Show search functionality
            _searchController.clear();
            context.read<ExploreProductsCubit>().updateSearchQuery('');
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ExploreProductsLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search medicines, brands...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    context.read<ExploreProductsCubit>().updateSearchQuery('');
                  },
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderMedium),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderMedium),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.surface,
        ),
        onChanged: (value) {
          context.read<ExploreProductsCubit>().updateSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildCategoryTabs(ExploreProductsLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ProductCategory.values.map((category) {
                  final isSelected = state.currentFilter.productCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category.displayName),
                      selected: isSelected,
                      onSelected: (selected) {
                        context.read<ExploreProductsCubit>().updateProductCategory(category);
                      },
                      backgroundColor: AppColors.surfaceVariant,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.borderMedium,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSortBar(ExploreProductsLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Filter button
          InkWell(
            onTap: () => _showFilterBottomSheet(state),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderMedium),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.tune, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  if (state.currentFilter.hasActiveFilters)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${state.currentFilter.activeFilterCount}',
                        style: const TextStyle(
                          color: AppColors.textOnPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Sort button
          InkWell(
            onTap: () => _showSortBottomSheet(state),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderMedium),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sort, size: 18, color: AppColors.textSecondary),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(ExploreProductsLoaded state) {
    if (state.filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: state.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = state.filteredProducts[index];
        return MedicineCard(
          medicine: product,
          isFavorite: state.favorites[product.id] ?? false,
          cartQuantity: state.cartItems[product.id] ?? 0,
          onFavoriteToggle: (medicine) {
            context.read<ExploreProductsCubit>().toggleFavorite(medicine);
          },
          onAddToCart: (medicine, quantity) {
            context.read<ExploreProductsCubit>().addToCart(medicine, quantity);
          },
        );
      },
    );
  }

  void _showFilterBottomSheet(ExploreProductsLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilter: state.currentFilter,
        availableBrands: state.availableBrands,
        availableCategories: state.availableCategories,
        onApplyFilter: (filter) {
          context.read<ExploreProductsCubit>().applyFilter(filter);
        },
      ),
    );
  }

  void _showSortBottomSheet(ExploreProductsLoaded state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheet(
        currentSortOption: state.currentFilter.sortOption,
        onApplySort: (sortOption) {
          final newFilter = state.currentFilter.copyWith(sortOption: sortOption);
          context.read<ExploreProductsCubit>().applyFilter(newFilter);
        },
      ),
    );
  }
}
