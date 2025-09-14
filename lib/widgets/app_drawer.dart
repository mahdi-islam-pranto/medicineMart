import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../screens/categories_page.dart';
import '../screens/drawer_pages/my_orders_page.dart';
import '../screens/drawer_pages/trending_products_page.dart';
import '../screens/drawer_pages/offers_discounts_page.dart';
import '../screens/drawer_pages/notifications_page.dart';
import '../screens/drawer_pages/help_support_page.dart';
import '../screens/drawer_pages/feedback_page.dart';
import '../screens/drawer_pages/about_us_page.dart';
import '../bloc/bloc.dart';
import 'drawer_header_widget.dart';
import 'drawer_item.dart';

/// AppDrawer - A modern, production-grade navigation drawer
///
/// This widget provides:
/// - Clean separation of concerns from the main screen
/// - Reusable across multiple screens if needed
/// - Modern Material Design 3 styling
/// - Proper theming and accessibility
/// - Organized code structure
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Set the drawer background color to match our theme
      backgroundColor: AppColors.surface,
      // Add subtle shadow for depth
      elevation: 8,
      // Custom shape with rounded corners on the right side
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Header section with user info and gradient background
          const DrawerHeaderWidget(),

          // Expanded scrollable content area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Main navigation section
                _buildSectionHeader('Main Menu'),

                DrawerItem(
                  icon: Icons.shopping_bag_outlined,
                  selectedIcon: Icons.shopping_bag,
                  title: 'My Orders',
                  subtitle: 'Track your orders',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToMyOrders(context);
                  },
                ),

                // DrawerItem(
                //   icon: Icons.trending_up_outlined,
                //   selectedIcon: Icons.trending_up,
                //   title: 'Trending Products',
                //   subtitle: 'Popular medicines',
                //   badge: 'Hot',
                //   onTap: () {
                //     Navigator.pop(context);
                //     _navigateToTrendingProducts(context);
                //   },
                // ),

                DrawerItem(
                  icon: Icons.local_offer_outlined,
                  selectedIcon: Icons.local_offer,
                  title: 'Offers & Discounts',
                  subtitle: 'Save on your orders',
                  badge: 'New',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToOffersDiscounts(context);
                  },
                ),

// Notifications
                // DrawerItem(
                //   icon: Icons.notifications_outlined,
                //   selectedIcon: Icons.notifications,
                //   title: 'Notifications',
                //   subtitle: 'Stay updated',
                //   badge: '5',
                //   onTap: () {
                //     Navigator.pop(context);
                //     _navigateToNotifications(context);
                //   },
                // ),

                // Support section
                const SizedBox(height: 16),
                _buildSectionHeader('Support'),

                DrawerItem(
                  icon: Icons.help_outline,
                  selectedIcon: Icons.help,
                  title: 'Help & Support',
                  subtitle: '24/7 customer service',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToHelpSupport(context);
                  },
                ),

                DrawerItem(
                  icon: Icons.feedback_outlined,
                  selectedIcon: Icons.feedback,
                  title: 'Feedback',
                  subtitle: 'Share your thoughts',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToFeedback(context);
                  },
                ),

                DrawerItem(
                  icon: Icons.info_outline,
                  selectedIcon: Icons.info,
                  title: 'About Us',
                  subtitle: 'Learn more about our app',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToAboutUs(context);
                  },
                ),
              ],
            ),
          ),

          // Bottom section with logout
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.borderLight,
                  width: 1,
                ),
              ),
            ),
            child: DrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a section header for grouping drawer items
  ///
  /// [title] - The section title to display
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  /// Shows a modern logout confirmation dialog with proper theming
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          // Icon and title
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.logout,
                  color: AppColors.error,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Content message
          content: const Text(
            'Are you sure you want to logout? You will need to sign in again to access your account.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.4,
            ),
          ),

          // Action buttons
          actions: [
            // Cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Logout button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement logout logic here
                // Example: AuthService.logout();
                // Navigate to login screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.textOnPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],

          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        );
      },
    );
  }

  /// Navigate to categories page
  void _navigateToCategories(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CategoriesCubit()..loadCategories(),
          child: const CategoriesPage(),
        ),
      ),
    );
  }

  /// Navigates to the My Orders page
  void _navigateToMyOrders(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyOrdersPage(),
      ),
    );
  }

  /// Navigates to the Trending Products page
  void _navigateToTrendingProducts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrendingProductsPage(),
      ),
    );
  }

  /// Navigates to the Offers & Discounts page
  void _navigateToOffersDiscounts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OffersDiscountsPage(),
      ),
    );
  }

  /// Navigates to the Notifications page
  void _navigateToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationsPage(),
      ),
    );
  }

  /// Navigates to the Help & Support page
  void _navigateToHelpSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpSupportPage(),
      ),
    );
  }

  /// Navigates to the Feedback page
  void _navigateToFeedback(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FeedbackPage(),
      ),
    );
  }

  /// Navigates to the About Us page
  void _navigateToAboutUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutUsPage(),
      ),
    );
  }
}
