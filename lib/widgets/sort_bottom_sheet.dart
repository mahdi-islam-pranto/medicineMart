import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';

/// Sort bottom sheet widget for explore products
class SortBottomSheet extends StatefulWidget {
  final SortOption currentSortOption;
  final Function(SortOption) onApplySort;

  const SortBottomSheet({
    super.key,
    required this.currentSortOption,
    required this.onApplySort,
  });

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late SortOption _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.currentSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  'Sort By',
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

          // Sort options
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSortSection(
                    'Sort by price',
                    [SortOption.priceLowToHigh, SortOption.priceHighToLow],
                  ),
                  // _buildSortSection(
                  //   'Sort by discount',
                  //   [
                  //     SortOption.discountHighToLow,
                  //     SortOption.discountLowToHigh
                  //   ],
                  // ),
                  _buildSortSection(
                    'Sort by Alphabet',
                    [SortOption.nameAtoZ, SortOption.nameZtoA],
                  ),
                  // _buildSortSection(
                  //   'Sort by delivery date',
                  //   [
                  //     SortOption.deliveryDate1,
                  //     SortOption.deliveryDate2,
                  //     SortOption.deliveryDate3,
                  //   ],
                  // ),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 30),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearSort,
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
                    onPressed: _applySort,
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

  Widget _buildSortSection(String title, List<SortOption> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        ...options.map((option) => _buildSortOption(option)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSortOption(SortOption option) {
    final isSelected = _selectedOption == option;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          option.displayName,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              )
            : null,
        onTap: () {
          setState(() {
            _selectedOption = option;
          });
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        dense: true,
      ),
    );
  }

  void _clearSort() {
    setState(() {
      _selectedOption = SortOption.nameAtoZ;
    });
  }

  void _applySort() {
    widget.onApplySort(_selectedOption);
    Navigator.pop(context);
  }
}
