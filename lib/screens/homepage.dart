import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/app_drawer.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/search_widget.dart';
import '../widgets/filter_widgets.dart';
import '../widgets/medicine_list.dart';
import '../theme/app_colors.dart';
import '../bloc/bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

                  const SizedBox(height: 10),

                  if (medicineState is MedicineLoaded) ...[
                    // Brand filter section
                    FilterSection(
                      child: BrandFilter(
                        brands: medicineState.brands,
                        selectedBrand: medicineState.selectedBrand,
                        onBrandSelected: (brand) => context
                            .read<MedicineCubit>()
                            .updateBrandFilter(brand),
                      ),
                    ),

                    // Alphabet filter section
                    FilterSection(
                      showDivider: false,
                      child: AlphabetFilter(
                        selectedLetter: medicineState.selectedLetter,
                        onLetterSelected: (letter) => context
                            .read<MedicineCubit>()
                            .updateLetterFilter(letter),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Active filters display
                    ActiveFilters(
                      selectedBrand: medicineState.selectedBrand,
                      selectedLetter: medicineState.selectedLetter,
                      searchQuery: medicineState.searchQuery,
                      onBrandRemoved: (brand) =>
                          context.read<MedicineCubit>().clearBrandFilter(),
                      onLetterRemoved: (letter) =>
                          context.read<MedicineCubit>().clearLetterFilter(),
                      onSearchRemoved: (query) =>
                          context.read<MedicineCubit>().updateSearchQuery(''),
                      onClearAll: () =>
                          context.read<MedicineCubit>().clearAllFilters(),
                    ),

                    // Search section
                    SearchWidget(
                      onSearchChanged: (query) => context
                          .read<MedicineCubit>()
                          .updateSearchQuery(query),
                      initialQuery: medicineState.searchQuery,
                    ),

                    const SizedBox(height: 10),

                    // Medicine list section
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

                            return MedicineList(
                              medicines: medicineState.medicines,
                              searchQuery: medicineState.searchQuery,
                              selectedBrand: medicineState.selectedBrand,
                              selectedLetter: medicineState.selectedLetter,
                              favorites: favorites,
                              cartItems: cartItems,
                              onFavoriteToggle: (medicine) => context
                                  .read<FavoritesCubit>()
                                  .toggleFavorite(medicine),
                              onAddToCart: (medicine, quantity) => context
                                  .read<CartCubit>()
                                  .addToCart(medicine, quantity),
                              isLoading: medicineState.isRefreshing,
                            );
                          },
                        );
                      },
                    ),
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
        'Online Medicine',
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
}
