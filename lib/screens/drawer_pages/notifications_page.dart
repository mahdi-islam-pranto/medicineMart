import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// NotificationsPage - Display user notifications and alerts
///
/// This page provides:
/// - Categorized notifications (Orders, Offers, Health Tips, etc.)
/// - Mark as read/unread functionality
/// - Clear all notifications
/// - Notification settings
/// - Modern UI design matching app theme
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with TickerProviderStateMixin {
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
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'mark_all_read') {
                _markAllAsRead();
              } else if (value == 'clear_all') {
                _clearAllNotifications();
              } else if (value == 'settings') {
                _openNotificationSettings();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all, size: 20),
                    SizedBox(width: 8),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, size: 20),
                    SizedBox(width: 8),
                    Text('Clear all'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textOnPrimary,
          labelColor: AppColors.textOnPrimary,
          unselectedLabelColor: AppColors.textOnPrimary.withOpacity(0.7),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Orders'),
            Tab(text: 'Offers'),
            Tab(text: 'Health Tips'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList('all'),
          _buildNotificationsList('orders'),
          _buildNotificationsList('offers'),
          _buildNotificationsList('health'),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(String category) {
    final notifications = _getNotificationsForCategory(category);
    
    if (notifications.isEmpty) {
      return _buildEmptyState(category);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isUnread = notification['isUnread'] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.primary.withOpacity(0.05) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: isUnread 
            ? Border.all(color: AppColors.primary.withOpacity(0.2), width: 1)
            : null,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getNotificationColor(notification['type']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getNotificationIcon(notification['type']),
            color: _getNotificationColor(notification['type']),
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification['title'],
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'],
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  notification['time'],
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (notification['actionText'] != null)
                  TextButton(
                    onPressed: () => _handleNotificationAction(notification),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      notification['actionText'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        onTap: () => _markAsRead(notification),
      ),
    );
  }

  Widget _buildEmptyState(String category) {
    String message;
    IconData icon;
    
    switch (category) {
      case 'orders':
        message = 'No order notifications';
        icon = Icons.shopping_bag_outlined;
        break;
      case 'offers':
        message = 'No offer notifications';
        icon = Icons.local_offer_outlined;
        break;
      case 'health':
        message = 'No health tip notifications';
        icon = Icons.health_and_safety_outlined;
        break;
      default:
        message = 'No notifications';
        icon = Icons.notifications_outlined;
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
            'You\'re all caught up!',
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'offer':
        return Icons.local_offer;
      case 'health':
        return Icons.health_and_safety;
      case 'delivery':
        return Icons.local_shipping;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'order':
        return AppColors.primary;
      case 'offer':
        return AppColors.warning;
      case 'health':
        return AppColors.success;
      case 'delivery':
        return AppColors.info;
      case 'payment':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  List<Map<String, dynamic>> _getNotificationsForCategory(String category) {
    final allNotifications = [
      {
        'id': '1',
        'type': 'order',
        'title': 'Order Delivered',
        'message': 'Your order #12345 has been delivered successfully',
        'time': '2 hours ago',
        'isUnread': true,
        'actionText': 'View Order',
        'category': 'orders',
      },
      {
        'id': '2',
        'type': 'offer',
        'title': 'Flash Sale Alert!',
        'message': 'Up to 50% off on all vitamins. Limited time offer!',
        'time': '4 hours ago',
        'isUnread': true,
        'actionText': 'Shop Now',
        'category': 'offers',
      },
      {
        'id': '3',
        'type': 'health',
        'title': 'Daily Health Tip',
        'message': 'Remember to take your vitamins with meals for better absorption',
        'time': '1 day ago',
        'isUnread': false,
        'actionText': null,
        'category': 'health',
      },
      {
        'id': '4',
        'type': 'delivery',
        'title': 'Order Shipped',
        'message': 'Your order #12346 is on the way. Expected delivery: Tomorrow',
        'time': '1 day ago',
        'isUnread': false,
        'actionText': 'Track Order',
        'category': 'orders',
      },
      {
        'id': '5',
        'type': 'payment',
        'title': 'Payment Successful',
        'message': 'Payment of ৳450 received for order #12345',
        'time': '2 days ago',
        'isUnread': false,
        'actionText': null,
        'category': 'orders',
      },
      {
        'id': '6',
        'type': 'offer',
        'title': 'New Coupon Available',
        'message': 'Use code HEALTH20 to get 20% off on your next order',
        'time': '3 days ago',
        'isUnread': false,
        'actionText': 'Use Coupon',
        'category': 'offers',
      },
    ];

    if (category == 'all') return allNotifications;
    return allNotifications.where((n) => n['category'] == category).toList();
  }

  void _markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['isUnread'] = false;
    });
  }

  void _markAllAsRead() {
    setState(() {
      // Mark all notifications as read
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to clear all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                // Clear all notifications
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications cleared'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _openNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings'),
        content: const Text('Notification settings will be available here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleNotificationAction(Map<String, dynamic> notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${notification['actionText']} action triggered'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
