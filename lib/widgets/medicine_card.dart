import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// MedicineCard - A reusable card widget for displaying medicine information
///
/// This widget provides:
/// - Professional card design with proper spacing and shadows
/// - Medicine image with placeholder support
/// - Medicine name, quantity, and brand information
/// - Regular and discount pricing display
/// - Favorite toggle functionality
/// - Add to cart with quantity selection
/// - Responsive design that works in grid layouts
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
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive values
    final cardPadding = (screenWidth * 0.03).clamp(8.0, 16.0);
    final borderRadius = (screenWidth * 0.03).clamp(8.0, 16.0);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and favorite button
          _buildImageSection(screenWidth, borderRadius),

          // Medicine information
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medicine name and quantity
                  _buildNameSection(screenWidth),

                  SizedBox(height: cardPadding * 0.3),

                  // Brand name
                  _buildBrandSection(screenWidth),

                  SizedBox(height: cardPadding * 0.6),

                  // Pricing
                  _buildPricingSection(screenWidth),

                  const Spacer(),

                  // Add to cart section
                  _buildAddToCartSection(screenWidth, cardPadding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the image section with favorite button
  Widget _buildImageSection(double screenWidth, double borderRadius) {
    // Calculate responsive image height
    final imageHeight = (screenWidth * 0.25).clamp(100.0, 140.0);
    return Stack(
      children: [
        // Medicine image
        Container(
          height: imageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
          ),
          child: widget.medicine.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
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

        // Favorite button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => widget.onFavoriteToggle(widget.medicine),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.isFavorite
                    ? AppColors.error
                    : AppColors.textSecondary,
                size: 16,
              ),
            ),
          ),
        ),

        // Discount badge (if applicable)
        if (widget.medicine.discountPercentage > 0)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${widget.medicine.discountPercentage}% OFF',
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 10,
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
        size: 40,
      ),
    );
  }

  /// Builds medicine name and quantity section
  Widget _buildNameSection(double screenWidth) {
    final nameFontSize = (screenWidth * 0.035).clamp(12.0, 16.0);

    return Text(
      '${widget.medicine.name} ${widget.medicine.quantity}',
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: nameFontSize,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds brand name section
  Widget _buildBrandSection(double screenWidth) {
    final brandFontSize = (screenWidth * 0.03).clamp(10.0, 14.0);

    return Text(
      widget.medicine.brand,
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: brandFontSize,
        fontWeight: FontWeight.w400,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds pricing section with regular and discount prices
  Widget _buildPricingSection(double screenWidth) {
    final priceFontSize = (screenWidth * 0.04).clamp(14.0, 18.0);
    final smallPriceFontSize = (screenWidth * 0.03).clamp(10.0, 14.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Discount price (if applicable)
        if (widget.medicine.discountPrice != null)
          Text(
            '৳${widget.medicine.discountPrice!.toStringAsFixed(2)}',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: priceFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),

        // Regular price
        Text(
          '৳${widget.medicine.regularPrice.toStringAsFixed(2)}',
          style: TextStyle(
            color: widget.medicine.discountPrice != null
                ? AppColors.textSecondary
                : AppColors.primary,
            fontSize: widget.medicine.discountPrice != null
                ? smallPriceFontSize
                : priceFontSize,
            fontWeight: widget.medicine.discountPrice != null
                ? FontWeight.w400
                : FontWeight.bold,
            decoration: widget.medicine.discountPrice != null
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
      ],
    );
  }

  /// Builds add to cart section with quantity selection
  Widget _buildAddToCartSection(double screenWidth, double cardPadding) {
    final buttonFontSize = (screenWidth * 0.03).clamp(10.0, 14.0);
    final buttonHeight = (screenWidth * 0.08).clamp(32.0, 40.0);
    if (widget.cartQuantity > 0) {
      // Show quantity controls when item is in cart
      return Container(
        height: buttonHeight,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(cardPadding),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Decrease quantity
            IconButton(
              onPressed: () {
                if (widget.cartQuantity > 1) {
                  widget.onAddToCart(widget.medicine, widget.cartQuantity - 1);
                } else {
                  widget.onAddToCart(widget.medicine, 0); // Remove from cart
                }
              },
              icon: Icon(
                widget.cartQuantity > 1 ? Icons.remove : Icons.delete_outline,
                color: AppColors.primary,
                size: 16,
              ),
            ),

            // Current quantity
            Text(
              '${widget.cartQuantity}',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: buttonFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Increase quantity
            IconButton(
              onPressed: () {
                widget.onAddToCart(widget.medicine, widget.cartQuantity + 1);
              },
              icon: const Icon(
                Icons.add,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ],
        ),
      );
    } else {
      // Show add to cart button when item is not in cart
      return SizedBox(
        width: double.infinity,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: () {
            widget.onAddToCart(widget.medicine, _selectedQuantity);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            padding: EdgeInsets.symmetric(vertical: cardPadding * 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardPadding),
            ),
            elevation: 0,
          ),
          child: Text(
            'Add to Cart',
            style: TextStyle(
              fontSize: buttonFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }
}

/// Medicine data model
class Medicine {
  final String id;
  final String name;
  final String quantity;
  final String brand;
  final double regularPrice;
  final double? discountPrice;
  final String? imageUrl;
  final String description;
  final bool requiresPrescription;

  Medicine({
    required this.id,
    required this.name,
    required this.quantity,
    required this.brand,
    required this.regularPrice,
    this.discountPrice,
    this.imageUrl,
    required this.description,
    this.requiresPrescription = false,
  });

  /// Calculate discount percentage
  int get discountPercentage {
    if (discountPrice == null) return 0;
    return ((regularPrice - discountPrice!) / regularPrice * 100).round();
  }

  /// Get effective price (discount price if available, otherwise regular price)
  double get effectivePrice => discountPrice ?? regularPrice;
}
