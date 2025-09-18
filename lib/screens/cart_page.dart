import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import '../widgets/app_drawer.dart';
import '../widgets/quantity_selector.dart';
import 'drawer_pages/my_orders_page.dart';

/// CartPage - Shopping cart with checkout functionality
///
/// This page provides:
/// - List of items in cart with quantity controls
/// - Price calculation and total display
/// - Checkout functionality
/// - Empty cart state
/// - Modern design matching app theme
/// - Auto-refresh when navigating to cart tab
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    // Load cart data when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const AppDrawer(),
      body: MultiBlocListener(
        listeners: [
          // Listen to cart state changes
          BlocListener<CartCubit, CartState>(
            listener: (context, state) {
              if (state is CartCheckoutSuccess) {
                _showOrderSuccessDialog(context, state);
              } else if (state is CartError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
          // Listen to navigation changes to refresh cart when tab becomes active
          BlocListener<NavigationCubit, NavigationState>(
            listener: (context, state) {
              // If cart tab is selected (index 2), refresh cart data
              if (state.currentIndex == 2) {
                context.read<CartCubit>().loadCart();
              }
            },
          ),
        ],
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    const Text('Error loading cart'),
                    const SizedBox(height: 8),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CartCubit>().loadCart(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is CartLoaded) {
              return state.isEmpty
                  ? _buildEmptyCart()
                  : _buildCartContent(state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && state.isNotEmpty) {
            return _buildCheckoutSection(state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final itemCount = state is CartLoaded ? state.uniqueProductCount : 0;
          final hasItems = state is CartLoaded && state.isNotEmpty;

          return AppBar(
            title: Text(
              'My Cart ($itemCount)',
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
              if (hasItems)
                IconButton(
                  onPressed: () => context.read<CartCubit>().clearCart(),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.textOnPrimary,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Builds the cart content
  Widget _buildCartContent(CartLoaded state) {
    return Column(
      children: [
        // Cart items list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
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
              width: 80,
              height: 80,
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
                    '${item.name}',
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

                  // const SizedBox(
                  //   height: 2,
                  // ),

                  // Text(
                  //   item.discountPercentage.toString(),
                  //   style: const TextStyle(
                  //     color: AppColors.textSecondary,
                  //     fontSize: 11,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),

                  const SizedBox(height: 8),

                  // Price
                  Row(
                    children: [
                      if (item.originalPrice > item.price)
                        Text(
                          '৳ ${item.originalPrice.toStringAsFixed(item.originalPrice.truncateToDouble() == item.originalPrice ? 0 : 2)}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      if (item.originalPrice > item.price)
                        const SizedBox(width: 8),
                      Text(
                        '৳ ${item.price.toStringAsFixed(item.price.truncateToDouble() == item.price ? 0 : 2)}',
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
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () =>
                        context.read<CartCubit>().removeFromCart(item.id),
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
                ),

                const SizedBox(height: 8),

                // Quantity controls
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => _showQuantitySelector(context, item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
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
                            '${item.cartQuantity}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 2),

                          // Unit name
                          Text(
                            item.quantity,
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
  Widget _buildCheckoutSection(CartLoaded state) {
    final subtotal = state.totalPrice;
    const delivery = 0.0;
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
                  '৳ ${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // delivery
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

            const SizedBox(height: 4),

            // Total discount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Discount:',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  '৳ ${state.totalDiscount.toStringAsFixed(2)}',
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

            // Checkout/make an order button
            SizedBox(
              width: double.infinity,
              child: Builder(
                builder: (context) => ElevatedButton(
                  onPressed:
                      state.isUpdating ? null : () => _handleCheckout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: state.isUpdating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textOnPrimary,
                            ),
                          ),
                        )
                      : const Text(
                          'Make an Order',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the quantity selector bottom sheet for cart items
  void _showQuantitySelector(BuildContext context, CartItem item) {
    // Default quantity options for cart items
    const quantityOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 30, 50];

    showQuantitySelector(
      context: context,
      quantityOptions: quantityOptions,
      selectedQuantity: item.cartQuantity,
      unitName: item.quantity,
      onQuantitySelected: (quantity) {
        context.read<CartCubit>().updateQuantity(item.id, quantity);
      },
    );
  }

  /// Handle checkout button press
  void _handleCheckout(BuildContext context) {
    // Show confirmation dialog before proceeding
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: const Text('Are you sure you want to place this order?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Trigger checkout
                context.read<CartCubit>().checkout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  /// Show order success dialog
  void _showOrderSuccessDialog(
      BuildContext context, CartCheckoutSuccess state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 64,
          ),
          title: const Text(
            'Order Placed Successfully!',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.message,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderDetailRow('Order ID:', state.orderData.orderId),
                    // _buildOrderDetailRow(
                    //     'Status:', state.orderData.orderStatus),
                    _buildOrderDetailRow('Estimated Delivery:',
                        state.orderData.estimatedDelivery),
                    _buildOrderDetailRow('Total Amount:',
                        '৳ ${state.orderData.totalAmount.toStringAsFixed(0)}'),
                    _buildOrderDetailRow(
                        'Payment Status:', state.orderData.paymentStatus),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Close dialog

                // Navigator.of(context).pop();
                // Optionally navigate to orders page or home
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MyOrdersPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Build order detail row
  Widget _buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
