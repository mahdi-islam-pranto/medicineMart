import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';

/// Filter bottom sheet widget for explore products
class FilterBottomSheet extends StatefulWidget {
  final ProductFilter currentFilter;
  final List<Brand> availableBrands;
  final List<Category> availableCategories;
  final Function(ProductFilter) onApplyFilter;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.availableBrands,
    required this.availableCategories,
    required this.onApplyFilter,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ProductFilter _tempFilter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tempFilter = widget.currentFilter;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.borderMedium,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter By',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: AppColors.textOnPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'Company'),
                Tab(text: 'Category'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCompanyTab(),
                _buildCategoryTab(),
              ],
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyTab() {
    return Column(
      children: [
        // Search field
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Manufacturer',
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderMedium),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderMedium),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              filled: true,
              fillColor: AppColors.surfaceVariant,
            ),
            onChanged: (value) {
              setState(() {
                // Filter brands based on search
              });
            },
          ),
        ),

        // Brand list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.availableBrands.length,
            itemBuilder: (context, index) {
              final brand = widget.availableBrands[index];

              return RadioListTile<String>(
                title: Text(
                  brand.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
                value: brand.id.toString(),
                groupValue: _tempFilter.selectedBrandId,
                onChanged: (String? value) {
                  setState(() {
                    if (value == _tempFilter.selectedBrandId) {
                      // Deselect if already selected
                      _tempFilter = _tempFilter.copyWith(clearBrand: true);
                    } else {
                      // Select new brand
                      _tempFilter = _tempFilter.copyWith(
                        selectedBrandId: value,
                      );
                    }
                  });
                },
                activeColor: AppColors.primary,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.availableCategories.length,
              itemBuilder: (context, index) {
                final category = widget.availableCategories[index];

                return RadioListTile<String>(
                  title: Text(
                    category.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  value: category.id.toString(),
                  groupValue: _tempFilter.selectedCategoryId,
                  onChanged: (String? value) {
                    setState(() {
                      if (value == _tempFilter.selectedCategoryId) {
                        // Deselect if already selected
                        _tempFilter = _tempFilter.copyWith(clearCategory: true);
                      } else {
                        // Select new category
                        _tempFilter = _tempFilter.copyWith(
                          selectedCategoryId: value,
                        );
                      }
                    });
                  },
                  activeColor: AppColors.primary,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _tempFilter = const ProductFilter();
      _searchController.clear();
    });
  }

  void _applyFilters() {
    widget.onApplyFilter(_tempFilter);
    Navigator.pop(context);
  }
}
