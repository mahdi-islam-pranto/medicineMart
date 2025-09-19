import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// QuantitySelector - A modern quantity selection widget with bottom sheet
///
/// This widget provides:
/// - Modern bottom sheet design similar to the provided screenshot
/// - Radio button selection for different quantities
/// - Custom quantity input option
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
  bool _isCustomQuantitySelected = false;
  final TextEditingController _customQuantityController =
      TextEditingController();
  final FocusNode _customQuantityFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tempSelectedQuantity = widget.selectedQuantity;

    // Check if selected quantity is in predefined options
    if (!widget.quantityOptions.contains(widget.selectedQuantity)) {
      _isCustomQuantitySelected = true;
      _customQuantityController.text = widget.selectedQuantity.toString();
    }
  }

  @override
  void dispose() {
    _customQuantityController.dispose();
    _customQuantityFocusNode.dispose();
    super.dispose();
  }

  /// Builds the custom quantity input option
  Widget _buildCustomQuantityOption() {
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
              _isCustomQuantitySelected = true;
              _customQuantityFocusNode.requestFocus();
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
                      color: _isCustomQuantitySelected
                          ? AppColors.primary
                          : AppColors.textSecondary.withOpacity(0.4),
                      width: 2,
                    ),
                    color: _isCustomQuantitySelected
                        ? AppColors.primary
                        : Colors.transparent,
                  ),
                  child: _isCustomQuantitySelected
                      ? const Icon(
                          Icons.circle,
                          size: 8,
                          color: AppColors.textOnPrimary,
                        )
                      : null,
                ),

                const SizedBox(width: 16),

                // Custom quantity input
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Custom: ',
                        style: TextStyle(
                          color: _isCustomQuantitySelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: _isCustomQuantitySelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _customQuantityController,
                          focusNode: _customQuantityFocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            color: _isCustomQuantitySelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: _isCustomQuantitySelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter quantity',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.6),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 0,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _isCustomQuantitySelected = true;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _isCustomQuantitySelected = true;
                              if (value.isNotEmpty) {
                                final customQuantity = int.tryParse(value);
                                if (customQuantity != null &&
                                    customQuantity > 0) {
                                  _tempSelectedQuantity = customQuantity;
                                }
                              }
                            });
                          },
                        ),
                      ),
                      Text(
                        ' ${widget.unitName}${(_tempSelectedQuantity > 1 && _isCustomQuantitySelected) ? 's' : ''}',
                        style: TextStyle(
                          color: _isCustomQuantitySelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: _isCustomQuantitySelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          const Text(
            'Select Quantity',
            style: TextStyle(
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
              child: ListView(
                shrinkWrap: true,
                children: [
                  // Custom quantity option (moved to top)
                  _buildCustomQuantityOption(),

                  // Predefined quantity options
                  ...widget.quantityOptions.map((quantity) {
                    final isSelected = quantity == _tempSelectedQuantity &&
                        !_isCustomQuantitySelected;

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
                              _isCustomQuantitySelected = false;
                              _customQuantityFocusNode.unfocus();
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
                                          : AppColors.textSecondary
                                              .withOpacity(0.4),
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
                  }),
                ],
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
                      int finalQuantity = _tempSelectedQuantity;

                      // If custom quantity is selected, validate the input
                      if (_isCustomQuantitySelected) {
                        final customText =
                            _customQuantityController.text.trim();
                        if (customText.isEmpty) {
                          // Show error if custom field is empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a quantity'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        final customQuantity = int.tryParse(customText);
                        if (customQuantity == null || customQuantity <= 0) {
                          // Show error if invalid quantity
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid quantity'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        finalQuantity = customQuantity;
                      }

                      widget.onQuantitySelected(finalQuantity);
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
