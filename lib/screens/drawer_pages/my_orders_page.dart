import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_colors.dart';
import '../../bloc/bloc.dart';
import '../../models/models.dart';

/// MyOrdersPage - Display user's order history and tracking
///
/// This page provides:
/// - Order history with status tracking
/// - Order details and items
/// - Reorder functionality
/// - Order status filters
/// - Modern UI design matching app theme
class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Load initial orders (all orders)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderCubit>().loadAllOrders();
    });

    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textOnPrimary,
          labelColor: AppColors.textOnPrimary,
          unselectedLabelColor: AppColors.textOnPrimary.withOpacity(0.7),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Delivered'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrdersTab('all', state),
              _buildOrdersTab('1', state),
              _buildOrdersTab('2', state),
              _buildOrdersTab('3', state),
              _buildOrdersTab('4', state),
            ],
          );
        },
      ),
    );
  }

  /// Handle tab change
  void _onTabChanged(int index) {
    final statusMap = {
      0: 'all',
      1: '1', // pending
      2: '2', // confirmed
      3: '3', // delivered
      4: '4', // cancelled
    };

    final status = statusMap[index] ?? 'all';
    context.read<OrderCubit>().switchToStatus(status);
  }

  /// Build orders tab content
  Widget _buildOrdersTab(String expectedStatus, OrderState state) {
    if (state is OrderLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is OrderError) {
      return _buildErrorState(state.message);
    } else if (state is OrderLoaded) {
      // Only show orders if the current status matches the expected status
      if (state.currentStatus == expectedStatus) {
        if (state.isEmpty) {
          return _buildEmptyState(expectedStatus);
        }
        return _buildOrdersList(state);
      } else {
        // Show loading while switching tabs
        return const Center(child: CircularProgressIndicator());
      }
    } else if (state is OrderRefreshing) {
      // Show previous orders while refreshing
      if (state.currentStatus == expectedStatus) {
        return _buildOrdersList(OrderLoaded(
          orders: state.previousOrders,
          pagination: const OrderPagination(
            currentPage: 1,
            totalPages: 1,
            totalOrders: 0,
            perPage: 20,
            hasNext: false,
            hasPrevious: false,
          ),
          summary: const OrderSummary(
            totalOrders: 0,
            pendingOrders: 0,
            confirmedOrders: 0,
            deliveredOrders: 0,
            cancelledOrders: 0,
          ),
          currentStatus: expectedStatus,
        ));
      }
    }

    return const Center(child: CircularProgressIndicator());
  }

  /// Build orders list
  Widget _buildOrdersList(OrderLoaded state) {
    return RefreshIndicator(
      onRefresh: () => context.read<OrderCubit>().refreshOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.orders.length + (state.hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.orders.length) {
            // Load more indicator
            if (state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              // Load more button
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => context.read<OrderCubit>().loadMoreOrders(),
                  child: const Text('Load More'),
                ),
              );
            }
          }

          final order = state.orders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderData order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order: #${order.orderNumber}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _buildStatusChip(order.displayStatus),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              order.createdAt,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 12),

            // Order items
            ...order.items.map<Widget>((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.qty}x ${item.name}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '৳${item.price}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )),

            const Divider(height: 24),

            // Order footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ৳${order.total}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    if (order.status.toLowerCase() == 'delivered')
                      TextButton(
                        onPressed: () => _reorderItems(order),
                        child: const Text('Reorder'),
                      ),
                    TextButton(
                      onPressed: () => _viewOrderDetails(order),
                      child: const Text('View Details'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        break;
      case 'confirmed':
        backgroundColor = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.primary;
        break;
      case 'delivered':
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case 'cancelled':
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        break;
      default:
        backgroundColor = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error loading orders',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Check Your Internet Connection. If the problem persists, please contact support.",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<OrderCubit>().refreshOrders(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String status) {
    String message;
    IconData icon;

    switch (status) {
      case '1': // pending
        message = 'No pending orders';
        icon = Icons.hourglass_empty;
        break;
      case '2': // confirmed
        message = 'No confirmed orders';
        icon = Icons.check_circle;
        break;
      case '3': // delivered
        message = 'No delivered orders';
        icon = Icons.check_circle_outline;
        break;
      case '4': // cancelled
        message = 'No cancelled orders';
        icon = Icons.cancel_outlined;
        break;
      default:
        message = 'No orders found';
        icon = Icons.shopping_bag_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your orders will appear here',
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _reorderItems(OrderData order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Items from Order #${order.id} added to cart'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _viewOrderDetails(OrderData order) {
    // Navigate to order details page
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #${order.orderNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Order Number: ${}'),
            // const SizedBox(height: 8),
            Text('Status: ${order.displayStatus}'),
            const SizedBox(height: 8),
            Text('Total: ৳${order.total}'),
            const SizedBox(height: 8),
            Text('Created: ${order.createdAt}'),
            const SizedBox(height: 8),
            Text('Estimated Delivery: ${order.estimatedDelivery}'),
            const SizedBox(height: 16),
            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('${item.qty}x ${item.name} - ৳${item.price}'),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
