import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/models.dart';
import 'quantity_selector.dart';
import '../utils/image_preview_utils.dart';

/// MedicineCard - A modern horizontal card widget for displaying medicine information
///
/// This widget provides:
/// - Modern horizontal layout with image on left, details in center, actions on right
/// - Professional card design with proper spacing and shadows
/// - Medicine image with placeholder support
/// - Medicine name, quantity, and brand information
/// - Regular and discount pricing display with percentage badges
/// - Favorite toggle functionality
/// - Add to cart with quantity selection
/// - Responsive design optimized for list layouts
class MedicineCard extends StatefulWidget {
  final Medicine medicine;
  final bool isFavorite;
  final int cartQuantity;
  final Function(Medicine) onFavoriteToggle;
  final Function(Medicine, int) onAddToCart;

  const MedicineCard({
    super.key,
    required this.medicine,
    this.isFavorite = false,
    this.cartQuantity = 0,
    required this.onFavoriteToggle,
    required this.onAddToCart,
  });

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive values
    final cardPadding = 12.0;
    final borderRadius = 12.0;
    final imageSize = 100.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Medicine image section
            _buildImageSection(imageSize, borderRadius),

            const SizedBox(width: 12),

            // Medicine details section
            Expanded(
              child: _buildDetailsSection(screenWidth),
            ),

            const SizedBox(width: 8),

            // Action buttons section
            _buildActionSection(),
          ],
        ),
      ),
    );
  }

  /// Builds the image section for horizontal layout
  Widget _buildImageSection(double imageSize, double borderRadius) {
    return Stack(
      children: [
        // Medicine image container with long press gesture
        GestureDetector(
          onLongPress: () => ImagePreviewUtils.showImagePreview(
            context,
            imageUrl: widget.medicine.imageUrl,
            medicineName: widget.medicine.name,
            brand: widget.medicine.brand,
            discountPercentage: widget.medicine.discountPercentage,
          ),
          child: Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: AppColors.borderLight,
                width: 1,
              ),
            ),
            child: widget.medicine.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Image.network(
                      widget.medicine.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    ),
                  )
                : _buildPlaceholderImage(),
          ),
        ),

        // Discount badge (if applicable)
        if (widget.medicine.discountPercentage > 0)
          Positioned(
            top: -2,
            left: -2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Text(
                '${widget.medicine.discountPercentage.toStringAsFixed(2)}%',
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Builds placeholder image when no image is available
  Widget _buildPlaceholderImage() {
    return const Center(
      child: Icon(
        Icons.medication,
        color: AppColors.textSecondary,
        size: 32,
      ),
    );
  }

  /// Builds the details section with medicine info and pricing
  Widget _buildDetailsSection(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Medicine name with type/form
        Text(
          '${widget.medicine.name}',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 2),

        // Generic name
        Text(
          widget.medicine.genericName,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),

        // Brand name
        Text(
          widget.medicine.brand.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 8),

        // Pricing section
        _buildPricingRow(),
      ],
    );
  }

  /// Builds pricing row with regular and discount prices
  Widget _buildPricingRow() {
    return Row(
      children: [
        // Regular price (crossed out if discount available)
        if (widget.medicine.discountPrice != null)
          Text(
            '৳ ${widget.medicine.regularPrice.toStringAsFixed(widget.medicine.regularPrice.truncateToDouble() == widget.medicine.regularPrice ? 0 : 2)}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.lineThrough,
            ),
          ),

        if (widget.medicine.discountPrice != null) const SizedBox(width: 8),

        // Current/discount price
        Text(
          '৳ ${(widget.medicine.discountPrice ?? widget.medicine.regularPrice).toStringAsFixed((widget.medicine.discountPrice ?? widget.medicine.regularPrice).truncateToDouble() == (widget.medicine.discountPrice ?? widget.medicine.regularPrice) ? 0 : 2)}',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Builds action section with favorite and cart buttons
  Widget _buildActionSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Favorite button
        GestureDetector(
          onTap: () => widget.onFavoriteToggle(widget.medicine),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.isFavorite
                  ? AppColors.error.withOpacity(0.1)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.isFavorite
                    ? AppColors.error.withOpacity(0.3)
                    : AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              color:
                  widget.isFavorite ? AppColors.error : AppColors.textSecondary,
              size: 18,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Add to cart button
        _buildCartButton(),
      ],
    );
  }

  /// Builds cart button with quantity controls or add button
  Widget _buildCartButton() {
    if (widget.cartQuantity > 0) {
      // Show quantity display and edit button when item is in cart
      return GestureDetector(
        onTap: () => _showQuantitySelector(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Current quantity
              Text(
                '${widget.cartQuantity}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              // Unit name
              Text(
                widget.medicine.quantity,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 2),

              // Edit icon
              const Icon(
                Icons.edit,
                color: AppColors.primary,
                size: 12,
              ),
            ],
          ),
        ),
      );
    } else {
      // Show add to cart button when item is not in cart
      return GestureDetector(
        onTap: () => _showQuantitySelector(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLight,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.textOnPrimary,
            size: 18,
          ),
        ),
      );
    }
  }

  /// Shows the quantity selector bottom sheet
  void _showQuantitySelector() {
    showQuantitySelector(
      context: context,
      quantityOptions: widget.medicine.quantityOptions,
      selectedQuantity: widget.cartQuantity > 0 ? widget.cartQuantity : 1,
      unitName: widget.medicine.quantity,
      onQuantitySelected: (quantity) {
        widget.onAddToCart(widget.medicine, quantity);
      },
    );
  }
}
