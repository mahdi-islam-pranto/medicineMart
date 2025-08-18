import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// QuantitySelector - A modern quantity selection widget with bottom sheet
///
/// This widget provides:
/// - Modern bottom sheet design similar to the provided screenshot
/// - Radio button selection for different quantities
/// - Apply and Cancel buttons
/// - Smooth animations and professional styling
/// - Customizable quantity options
class QuantitySelector extends StatefulWidget {
  final List<int> quantityOptions;
  final int selectedQuantity;
  final Function(int) onQuantitySelected;
  final String unitName; // e.g., "Box", "Bottle", "Pack"

  const QuantitySelector({
    super.key,
    required this.quantityOptions,
    required this.selectedQuantity,
    required this.onQuantitySelected,
    this.unitName = 'Box',
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _tempSelectedQuantity;

  @override
  void initState() {
    super.initState();
    _tempSelectedQuantity = widget.selectedQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            'Select Quantity',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          // Quantity options list
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.quantityOptions.length,
                itemBuilder: (context, index) {
                  final quantity = widget.quantityOptions[index];
                  final isSelected = quantity == _tempSelectedQuantity;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _tempSelectedQuantity = quantity;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              // Radio button
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary.withOpacity(0.4),
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: AppColors.textOnPrimary,
                                      )
                                    : null,
                              ),

                              const SizedBox(width: 16),

                              // Quantity text
                              Text(
                                '$quantity ${widget.unitName}${quantity > 1 ? 's' : ''}',
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Action buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onQuantitySelected(_tempSelectedQuantity);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Cancel button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }
}

/// Helper function to show quantity selector bottom sheet
Future<void> showQuantitySelector({
  required BuildContext context,
  required List<int> quantityOptions,
  required int selectedQuantity,
  required Function(int) onQuantitySelected,
  String unitName = 'Box',
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return QuantitySelector(
        quantityOptions: quantityOptions,
        selectedQuantity: selectedQuantity,
        onQuantitySelected: onQuantitySelected,
        unitName: unitName,
      );
    },
  );
}
