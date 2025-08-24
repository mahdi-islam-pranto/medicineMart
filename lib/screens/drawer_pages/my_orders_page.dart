import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

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

class _MyOrdersPageState extends State<MyOrdersPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
            Tab(text: 'Delivered'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList('all'),
          _buildOrdersList('pending'),
          _buildOrdersList('delivered'),
          _buildOrdersList('cancelled'),
        ],
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    final orders = _getOrdersForStatus(status);
    
    if (orders.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
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
                  'Order #${order['id']}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _buildStatusChip(order['status']),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              order['date'],
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Order items
            ...order['items'].map<Widget>((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item['quantity']}x ${item['name']}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '৳${item['price']}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )).toList(),
            
            const Divider(height: 24),
            
            // Order footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ৳${order['total']}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    if (order['status'] == 'delivered')
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

  Widget _buildEmptyState(String status) {
    String message;
    IconData icon;
    
    switch (status) {
      case 'pending':
        message = 'No pending orders';
        icon = Icons.hourglass_empty;
        break;
      case 'delivered':
        message = 'No delivered orders';
        icon = Icons.check_circle_outline;
        break;
      case 'cancelled':
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

  List<Map<String, dynamic>> _getOrdersForStatus(String status) {
    // Mock data - replace with actual API call
    final allOrders = [
      {
        'id': '12345',
        'date': '2024-01-15',
        'status': 'delivered',
        'total': '450.00',
        'items': [
          {'name': 'Paracetamol 500mg', 'quantity': 2, 'price': '120.00'},
          {'name': 'Vitamin D3', 'quantity': 1, 'price': '330.00'},
        ],
      },
      {
        'id': '12346',
        'date': '2024-01-20',
        'status': 'pending',
        'total': '280.00',
        'items': [
          {'name': 'Omeprazole 20mg', 'quantity': 1, 'price': '280.00'},
        ],
      },
      {
        'id': '12347',
        'date': '2024-01-18',
        'status': 'cancelled',
        'total': '150.00',
        'items': [
          {'name': 'Aspirin 75mg', 'quantity': 3, 'price': '150.00'},
        ],
      },
    ];

    if (status == 'all') return allOrders;
    return allOrders.where((order) => order['status'] == status).toList();
  }

  void _reorderItems(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Items from Order #${order['id']} added to cart'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _viewOrderDetails(Map<String, dynamic> order) {
    // Navigate to order details page
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #${order['id']}'),
        content: const Text('Order details will be shown here'),
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
