import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// CategoriesPage - Browse medicines by categories
///
/// This page provides:
/// - Grid layout of medicine categories
/// - Search functionality within categories
/// - Popular categories section
/// - Modern card design for each category
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String _searchQuery = '';

  // Sample categories data
  final List<MedicineCategory> _categories = [
    MedicineCategory(
      id: '1',
      name: 'Pain Relief',
      description: 'Analgesics & Anti-inflammatory',
      icon: Icons.healing,
      color: AppColors.error.withOpacity(0.1),
      itemCount: 45,
    ),
    MedicineCategory(
      id: '2',
      name: 'Antibiotics',
      description: 'Bacterial infection treatment',
      icon: Icons.medication,
      color: AppColors.primary.withOpacity(0.1),
      itemCount: 32,
    ),
    MedicineCategory(
      id: '3',
      name: 'Vitamins',
      description: 'Supplements & Nutrients',
      icon: Icons.eco,
      color: AppColors.success.withOpacity(0.1),
      itemCount: 28,
    ),
    MedicineCategory(
      id: '4',
      name: 'Heart Care',
      description: 'Cardiovascular medicines',
      icon: Icons.favorite,
      color: AppColors.error.withOpacity(0.1),
      itemCount: 23,
    ),
    MedicineCategory(
      id: '5',
      name: 'Diabetes',
      description: 'Blood sugar management',
      icon: Icons.water_drop,
      color: AppColors.info.withOpacity(0.1),
      itemCount: 19,
    ),
    MedicineCategory(
      id: '6',
      name: 'Skin Care',
      description: 'Dermatological treatments',
      icon: Icons.face,
      color: AppColors.warning.withOpacity(0.1),
      itemCount: 34,
    ),
    MedicineCategory(
      id: '7',
      name: 'Respiratory',
      description: 'Breathing & lung care',
      icon: Icons.air,
      color: AppColors.secondary.withOpacity(0.1),
      itemCount: 27,
    ),
    MedicineCategory(
      id: '8',
      name: 'Digestive',
      description: 'Stomach & digestive health',
      icon: Icons.restaurant,
      color: AppColors.accent.withOpacity(0.1),
      itemCount: 31,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search section
          _buildSearchSection(),

          // Categories grid
          Expanded(
            child: _buildCategoriesGrid(),
          ),
        ],
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
  Widget _buildSearchSection() {
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
            setState(() {
              _searchQuery = value;
            });
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
  Widget _buildCategoriesGrid() {
    final filteredCategories = _categories.where((category) {
      return category.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          category.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();

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
    return GestureDetector(
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
    );
  }
}

/// Medicine category data model
class MedicineCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int itemCount;

  MedicineCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.itemCount,
  });
}
