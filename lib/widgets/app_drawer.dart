import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../screens/explore_products_page.dart';
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
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore,
                  title: 'Explore All Products',
                  subtitle: 'Browse all medicines & products',
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToExploreProducts(context);
                  },
                ),

                DrawerItem(
                  icon: Icons.upload_file_outlined,
                  selectedIcon: Icons.upload_file,
                  title: 'Upload Prescription',
                  subtitle: 'Get medicines delivered',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to upload prescription screen
                  },
                ),

                DrawerItem(
                  icon: Icons.shopping_cart_outlined,
                  selectedIcon: Icons.shopping_cart,
                  title: 'Supplements',
                  subtitle: 'Health & wellness products',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to supplements screen
                  },
                ),

                DrawerItem(
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  title: 'My Profile',
                  subtitle: 'Manage your account',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to profile screen
                  },
                ),

                DrawerItem(
                  icon: Icons.local_offer_outlined,
                  selectedIcon: Icons.local_offer,
                  title: 'Offers & Discounts',
                  subtitle: 'Save on your orders',
                  badge: '3 New',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to offers screen
                  },
                ),

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
                    // Navigate to help screen
                  },
                ),

                DrawerItem(
                  icon: Icons.info_outline,
                  selectedIcon: Icons.info,
                  title: 'About Us',
                  subtitle: 'Learn more about our app',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to about screen
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

  /// Navigate to explore products page
  void _navigateToExploreProducts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ExploreProductsCubit(),
          child: const ExploreProductsPage(),
        ),
      ),
    );
  }
}
