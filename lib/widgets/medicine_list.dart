import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'medicine_card.dart';

/// MedicineList - A modern vertical list widget that displays medicines with filtering and sorting
///
/// This widget provides:
/// - Modern vertical list layout optimized for horizontal medicine cards
/// - Filtering by search query, brand, and alphabet
/// - Loading states and empty states
/// - Proper spacing and padding
/// - Infinite scroll support (can be extended)
/// - Professional layout with consistent spacing
class MedicineList extends StatefulWidget {
  final List<Medicine> medicines;
  final String searchQuery;
  final String? selectedBrand;
  final String? selectedLetter;
  final Map<String, bool> favorites;
  final Map<String, int> cartItems;
  final Function(Medicine) onFavoriteToggle;
  final Function(Medicine, int) onAddToCart;
  final bool isLoading;

  const MedicineList({
    super.key,
    required this.medicines,
    this.searchQuery = '',
    this.selectedBrand,
    this.selectedLetter,
    required this.favorites,
    required this.cartItems,
    required this.onFavoriteToggle,
    required this.onAddToCart,
    this.isLoading = false,
  });

  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  /// Filters medicines based on current filter criteria
  List<Medicine> get filteredMedicines {
    List<Medicine> filtered = widget.medicines;

    // Filter by search query
    if (widget.searchQuery.isNotEmpty) {
      filtered = filtered.where((medicine) {
        final query = widget.searchQuery.toLowerCase();
        return medicine.name.toLowerCase().contains(query) ||
            medicine.brand.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by selected brand
    if (widget.selectedBrand != null) {
      filtered = filtered.where((medicine) {
        return medicine.brand == widget.selectedBrand;
      }).toList();
    }

    // Filter by selected letter
    if (widget.selectedLetter != null) {
      filtered = filtered.where((medicine) {
        return medicine.name.toUpperCase().startsWith(widget.selectedLetter!);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    final filtered = filteredMedicines;

    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return _buildMedicineGrid(filtered);
  }

  /// Builds the main medicine list with modern vertical layout
  Widget _buildMedicineGrid(List<Medicine> medicines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product header section
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Product',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Filter/sort icon
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.tune,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),

        // Medicine list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];
            return MedicineCard(
              medicine: medicine,
              isFavorite: widget.favorites[medicine.id] ?? false,
              cartQuantity: widget.cartItems[medicine.id] ?? 0,
              onFavoriteToggle: widget.onFavoriteToggle,
              onAddToCart: widget.onAddToCart,
            );
          },
        ),
      ],
    );
  }

  /// Builds loading state with shimmer effect
  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product header loading
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 16,
                width: 80,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),

        // Loading cards list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6, // Show 6 loading cards
          itemBuilder: (context, index) {
            return _buildLoadingCard();
          },
        ),
      ],
    );
  }

  /// Builds individual loading card with shimmer effect for horizontal layout
  Widget _buildLoadingCard() {
    const borderRadius = 12.0;
    const cardPadding = 12.0;
    const imageSize = 80.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Content placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name placeholder
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Brand placeholder
                  Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Price placeholder
                  Container(
                    height: 14,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Action buttons placeholder
            Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds empty state when no medicines match the filters
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty state icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off,
              size: 48,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 24),

          // Empty state title
          const Text(
            'No medicines found',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          // Empty state description
          Text(
            _getEmptyStateMessage(),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Clear filters button (if filters are active)
          if (_hasActiveFilters())
            ElevatedButton(
              onPressed: _clearAllFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Clear All Filters',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Gets appropriate empty state message based on active filters
  String _getEmptyStateMessage() {
    if (widget.searchQuery.isNotEmpty) {
      return 'No medicines found for "${widget.searchQuery}". Try adjusting your search terms.';
    } else if (widget.selectedBrand != null) {
      return 'No medicines found for ${widget.selectedBrand}. Try selecting a different brand.';
    } else if (widget.selectedLetter != null) {
      return 'No medicines found starting with "${widget.selectedLetter}". Try selecting a different letter.';
    } else {
      return 'No medicines available at the moment. Please check back later.';
    }
  }

  /// Checks if any filters are currently active
  bool _hasActiveFilters() {
    return widget.searchQuery.isNotEmpty ||
        widget.selectedBrand != null ||
        widget.selectedLetter != null;
  }

  /// Clears all active filters (this would need to be implemented by parent widget)
  void _clearAllFilters() {
    // This would typically call parent widget methods to clear filters
    // For now, we'll show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clear filters functionality needs to be implemented'),
      ),
    );
  }
}
