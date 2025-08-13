import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';

/// CategoriesPage - Browse medicines by categories
///
/// This page provides:
/// - Grid layout of medicine categories
/// - Search functionality within categories
/// - Popular categories section
/// - Modern card design for each category
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoriesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Error loading categories'),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CategoriesCubit>().loadCategories(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is CategoriesLoaded) {
            return Column(
              children: [
                // Search section
                _buildSearchSection(context, state),

                // Categories grid
                Expanded(
                  child: _buildCategoriesGrid(state),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Categories',
        style: TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  /// Builds the search section
  Widget _buildSearchSection(BuildContext context, CategoriesLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.primary,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            context.read<CategoriesCubit>().updateSearchQuery(value);
          },
          decoration: const InputDecoration(
            hintText: 'Search categories...',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textSecondary,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  /// Builds the categories grid
  Widget _buildCategoriesGrid(CategoriesLoaded state) {
    final filteredCategories = state.filteredCategories;

    return Container(
      color: AppColors.background,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85, // Reduced aspect ratio to give more height
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) {
          final category = filteredCategories[index];
          return _buildCategoryCard(category);
        },
      ),
    );
  }

  /// Builds individual category card
  Widget _buildCategoryCard(MedicineCategory category) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          // Navigate to category medicines
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening ${category.name} category'),
              backgroundColor: AppColors.primary,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: category.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    category.icon,
                    size: 28,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 8),

                // Category name
                Flexible(
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 2),

                // Category description
                Flexible(
                  child: Text(
                    category.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 6),

                // Item count
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${category.itemCount} items',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
