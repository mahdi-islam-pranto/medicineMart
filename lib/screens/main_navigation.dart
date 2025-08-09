import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'homepage.dart';
import 'categories_page.dart';
import 'cart_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';

/// MainNavigation - The main navigation wrapper with bottom navigation bar
///
/// This widget provides:
/// - Modern bottom navigation bar with 5 essential tabs
/// - Smooth navigation between different screens
/// - Badge support for cart items and notifications
/// - Professional design matching the app theme
/// - User-friendly navigation experience
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Sample cart count for badge display
  int _cartItemCount = 3;

  // Sample favorites count
  int _favoritesCount = 5;

  // List of pages for navigation
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const CategoriesPage(),
      const CartPage(),
      const FavoritesPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Builds the modern bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        // Use a slightly darker surface color for better contrast
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primaryLight, // Assuming AppColors.primary is lighter
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            offset: Offset(0, -2),
            blurRadius: 12,
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 65, // Reduced height to prevent overflow
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 1,
                  icon: Icons.category_outlined,
                  activeIcon: Icons.category,
                  label: 'Categories',
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 2,
                  icon: Icons.shopping_cart_outlined,
                  activeIcon: Icons.shopping_cart,
                  label: 'Cart',
                  badgeCount: _cartItemCount,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 3,
                  icon: Icons.favorite_outline,
                  activeIcon: Icons.favorite,
                  label: 'Favorites',
                  badgeCount: _favoritesCount,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 4,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds individual navigation item with badge support
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int? badgeCount,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.secondary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive
                      ? AppColors.accent // Light beige for active state
                      : AppColors.textOnPrimary
                          .withOpacity(0.7), // Light color for inactive
                  size: 22, // Slightly smaller to prevent overflow
                ),

                // Badge for cart and favorites
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: const BoxDecoration(
                        color: AppColors
                            .warning, // Orange color for better visibility
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        badgeCount > 99 ? '99+' : badgeCount.toString(),
                        style: const TextStyle(
                          color: AppColors.textOnPrimary,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 2),

            // Label
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? AppColors.accent // Light beige for active state
                      : AppColors.textOnPrimary
                          .withOpacity(0.7), // Light color for inactive
                  fontSize: 10, // Smaller font to prevent overflow
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Updates cart item count (to be called from other screens)
  void updateCartCount(int count) {
    setState(() {
      _cartItemCount = count;
    });
  }

  /// Updates favorites count (to be called from other screens)
  void updateFavoritesCount(int count) {
    setState(() {
      _favoritesCount = count;
    });
  }
}
