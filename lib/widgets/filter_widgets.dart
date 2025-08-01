import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// BrandFilter - A horizontal scrollable filter for medicine brands
///
/// This widget provides:
/// - Horizontal scrollable brand chips
/// - Single selection with visual feedback
/// - Reset option to clear selection
/// - Modern chip design with proper theming
/// - Responsive layout that works on different screen sizes
class BrandFilter extends StatefulWidget {
  final List<String> brands;
  final String? selectedBrand;
  final Function(String?) onBrandSelected;

  const BrandFilter({
    super.key,
    required this.brands,
    this.selectedBrand,
    required this.onBrandSelected,
  });

  @override
  State<BrandFilter> createState() => _BrandFilterState();
}

class _BrandFilterState extends State<BrandFilter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with reset button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter by Brand',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.selectedBrand != null)
                TextButton(
                  onPressed: () => widget.onBrandSelected(null),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Horizontal scrollable brand chips
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.brands.length,
            itemBuilder: (context, index) {
              final brand = widget.brands[index];
              final isSelected = widget.selectedBrand == brand;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(brand),
                  selected: isSelected,
                  onSelected: (selected) {
                    widget.onBrandSelected(selected ? brand : null);
                  },
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.primary.withOpacity(0.1),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color:
                        isSelected ? AppColors.primary : AppColors.borderLight,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// AlphabetFilter - A filter for medicines by first letter
///
/// This widget provides:
/// - Grid layout of alphabet letters
/// - Single selection with visual feedback
/// - Reset option to clear selection
/// - Modern button design with proper theming
/// - Compact layout that doesn't take too much space
class AlphabetFilter extends StatefulWidget {
  final String? selectedLetter;
  final Function(String?) onLetterSelected;

  const AlphabetFilter({
    super.key,
    this.selectedLetter,
    required this.onLetterSelected,
  });

  @override
  State<AlphabetFilter> createState() => _AlphabetFilterState();
}

class _AlphabetFilterState extends State<AlphabetFilter> {
  // Generate alphabet list
  final List<String> _alphabet =
      List.generate(26, (index) => String.fromCharCode(65 + index));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with reset button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter by Alphabet',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.selectedLetter != null)
                TextButton(
                  onPressed: () => widget.onLetterSelected(null),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Horizontal scrollable alphabet
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _alphabet.length,
            itemBuilder: (context, index) {
              final letter = _alphabet[index];
              final isSelected = widget.selectedLetter == letter;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    widget.onLetterSelected(isSelected ? null : letter);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.borderLight,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isSelected
                          ? [
                              const BoxShadow(
                                color: AppColors.shadowLight,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        letter,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.textOnPrimary
                              : AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// FilterSection - A container widget that groups filters together
///
/// This widget provides:
/// - Consistent spacing and layout for filter sections
/// - Optional dividers between sections
/// - Proper padding and margins
class FilterSection extends StatelessWidget {
  final Widget child;
  final bool showDivider;

  const FilterSection({
    super.key,
    required this.child,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: child,
        ),
        if (showDivider)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            color: AppColors.borderLight,
          ),
      ],
    );
  }
}

/// ActiveFilters - Shows currently active filters with option to remove them
///
/// This widget provides:
/// - Display of active filters as removable chips
/// - Clear all filters option
/// - Compact design that doesn't take much space
class ActiveFilters extends StatelessWidget {
  final String? selectedBrand;
  final String? selectedLetter;
  final String searchQuery;
  final Function(String?) onBrandRemoved;
  final Function(String?) onLetterRemoved;
  final Function(String) onSearchRemoved;
  final VoidCallback onClearAll;

  const ActiveFilters({
    super.key,
    this.selectedBrand,
    this.selectedLetter,
    this.searchQuery = '',
    required this.onBrandRemoved,
    required this.onLetterRemoved,
    required this.onSearchRemoved,
    required this.onClearAll,
  });

  bool get hasActiveFilters =>
      selectedBrand != null || selectedLetter != null || searchQuery.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!hasActiveFilters) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Filters',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onClearAll,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (searchQuery.isNotEmpty)
                _buildActiveFilterChip(
                  'Search: $searchQuery',
                  () => onSearchRemoved(''),
                ),
              if (selectedBrand != null)
                _buildActiveFilterChip(
                  'Brand: $selectedBrand',
                  () => onBrandRemoved(null),
                ),
              if (selectedLetter != null)
                _buildActiveFilterChip(
                  'Letter: $selectedLetter',
                  () => onLetterRemoved(null),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      deleteIcon: const Icon(
        Icons.close,
        size: 14,
        color: AppColors.textOnPrimary,
      ),
      onDeleted: onRemove,
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
