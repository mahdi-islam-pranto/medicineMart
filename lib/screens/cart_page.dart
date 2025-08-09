import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// CartPage - Shopping cart with checkout functionality
///
/// This page provides:
/// - List of items in cart with quantity controls
/// - Price calculation and total display
/// - Checkout functionality
/// - Empty cart state
/// - Modern design matching app theme
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Sample cart items
  List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      name: 'Tablet- Acipro',
      quantity: 'Box',
      brand: 'Square',
      price: 410.00,
      originalPrice: 500.00,
      cartQuantity: 2,
      imageUrl: 'https://via.placeholder.com/80x80/E3F2FD/1976D2?text=ACIPRO',
    ),
    CartItem(
      id: '2',
      name: 'Syrup- Asthalin',
      quantity: '100ml',
      brand: 'Renata',
      price: 230.00,
      originalPrice: 360.00,
      cartQuantity: 1,
      imageUrl: 'https://via.placeholder.com/80x80/E8F5E8/4CAF50?text=SYRUP',
    ),
    CartItem(
      id: '3',
      name: 'Capsule- Amoxicillin',
      quantity: '500ml',
      brand: 'Beximco',
      price: 410.00,
      originalPrice: 600.00,
      cartQuantity: 1,
      imageUrl: 'https://via.placeholder.com/80x80/FFF8E1/FFC107?text=CAPS',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar: _cartItems.isEmpty ? null : _buildCheckoutSection(),
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'My Cart (${_cartItems.length})',
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        if (_cartItems.isNotEmpty)
          IconButton(
            onPressed: _clearCart,
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.textOnPrimary,
            ),
          ),
      ],
    );
  }

  /// Builds the cart content
  Widget _buildCartContent() {
    return Column(
      children: [
        // Cart items list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return _buildCartItemCard(item, index);
            },
          ),
        ),
      ],
    );
  }

  /// Builds individual cart item card
  Widget _buildCartItemCard(CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
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
        child: Row(
          children: [
            // Product image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.medication,
                      color: AppColors.textSecondary,
                      size: 24,
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.name} (${item.quantity})',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 2),
                  
                  Text(
                    item.brand.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Price
                  Row(
                    children: [
                      if (item.originalPrice > item.price)
                        Text(
                          '৳ ${item.originalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      
                      if (item.originalPrice > item.price)
                        const SizedBox(width: 8),
                      
                      Text(
                        '৳ ${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Quantity controls
            Column(
              children: [
                // Remove button
                GestureDetector(
                  onTap: () => _removeItem(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.error,
                      size: 16,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Quantity controls
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _updateQuantity(index, item.cartQuantity + 1),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ),
                      ),
                      
                      Text(
                        '${item.cartQuantity}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      GestureDetector(
                        onTap: () {
                          if (item.cartQuantity > 1) {
                            _updateQuantity(index, item.cartQuantity - 1);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.remove,
                            color: item.cartQuantity > 1 
                                ? AppColors.primary 
                                : AppColors.textSecondary,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds empty cart state
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Your cart is empty',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Add some medicines to get started',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds checkout section
  Widget _buildCheckoutSection() {
    final subtotal = _cartItems.fold<double>(
      0, (sum, item) => sum + (item.price * item.cartQuantity),
    );
    final delivery = 50.0;
    final total = subtotal + delivery;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal:',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  '৳ ${subtotal.toStringAsFixed(0)}',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
            
            const SizedBox(height: 4),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Delivery:',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  '৳ ${delivery.toStringAsFixed(0)}',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
            
            const Divider(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '৳ ${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Checkout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Updates item quantity
  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      _cartItems[index].cartQuantity = newQuantity;
    });
  }

  /// Removes item from cart
  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  /// Clears entire cart
  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _cartItems.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Handles checkout
  void _checkout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout functionality coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

/// Cart item data model
class CartItem {
  final String id;
  final String name;
  final String quantity;
  final String brand;
  final double price;
  final double originalPrice;
  int cartQuantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.cartQuantity,
    required this.imageUrl,
  });
}
