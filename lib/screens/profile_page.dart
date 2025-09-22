import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../bloc/bloc.dart';
import 'drawer_pages/about_us_page.dart';
import 'drawer_pages/feedback_page.dart';
import 'drawer_pages/help_support_page.dart';
import 'drawer_pages/my_orders_page.dart';

/// ProfilePage - User profile and account management
///
/// This page provides:
/// - User profile information
/// - Account settings and preferences
/// - Order history access
/// - Help and support options
/// - Modern design matching app theme
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            _buildProfileHeader(),

            const SizedBox(height: 24),

            // Menu sections
            _buildMenuSection(),
          ],
        ),
      ),
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Profile',
        style: TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        // IconButton(
        //   onPressed: () {
        //     // Settings
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(
        //         content: Text('Settings coming soon!'),
        //         backgroundColor: AppColors.primary,
        //       ),
        //     );
        //   },
        //   icon: const Icon(
        //     Icons.settings_outlined,
        //     color: AppColors.textOnPrimary,
        //   ),
        // ),
      ],
    );
  }

  /// Builds the profile header section
  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            // Get user info from auth state
            final user = state.user;
            final userName = user?.fullName ?? 'Pharmacy Owner';
            final userId = user?.id ?? '1';
            final pharmacyName = user?.pharmacyName ?? 'Your Pharmacy';

            return Column(
              children: [
                // Profile picture
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowMedium.withOpacity(0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_pharmacy,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 16),

                // User name
                Text(
                  userName,
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Pharmacy name
                Text(
                  pharmacyName,
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                // Stats row
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildStatItem('Orders', '12'),
                //     _buildStatItem('Favorites', '5'),
                //     _buildStatItem('Reviews', '8'),
                //   ],
                // ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Builds individual stat item
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: 12,
            // opacity: 0.8,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Builds the menu section
  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Account section
          _buildSectionHeader('Account'),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () => _showComingSoon('Edit Profile'),
          ),
          // _buildMenuItem(
          //   icon: Icons.location_on_outlined,
          //   title: 'Addresses',
          //   subtitle: 'Manage delivery addresses',
          //   onTap: () => _showComingSoon('Addresses'),
          // ),

          // Payment methods
          // _buildMenuItem(
          //   icon: Icons.payment_outlined,
          //   title: 'Payment Methods',
          //   subtitle: 'Manage payment options',
          //   onTap: () => _showComingSoon('Payment Methods'),
          // ),

          const SizedBox(height: 24),

          // Orders section
          _buildSectionHeader('Orders'),
          _buildMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Order History',
            subtitle: 'View your past orders',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyOrdersPage()),
            ),
          ),
          _buildMenuItem(
            icon: Icons.local_shipping_outlined,
            title: 'Track Orders',
            subtitle: 'Track your current orders',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyOrdersPage()),
            ),
          ),
          // _buildMenuItem(
          //   icon: Icons.receipt_outlined,
          //   title: 'Prescriptions',
          //   subtitle: 'Manage uploaded prescriptions',
          //   onTap: () => _showComingSoon('Prescriptions'),
          // ),

          const SizedBox(height: 24),

          // Support section
          _buildSectionHeader('Support'),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: '24/7 customer service',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpSupportPage()),
            ),
          ),
          _buildMenuItem(
            icon: Icons.star_outline,
            title: 'Rate App',
            subtitle: 'Share your feedback',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FeedbackPage()),
            ),
          ),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version and info',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutUsPage()),
            ),
          ),

          const SizedBox(height: 24),

          // Logout button
          _buildLogoutButton(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Builds section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual menu item
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  /// Builds logout button
  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: ListTile(
        onTap: _showLogoutDialog,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.logout,
            color: AppColors.error,
            size: 20,
          ),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: AppColors.error,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: const Text(
          'Sign out of your account',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  /// Shows coming soon message
  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  /// Shows logout confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Call the AuthCubit logout method
              context.read<AuthCubit>().logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
