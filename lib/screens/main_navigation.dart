import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../bloc/bloc.dart';
import 'homepage.dart';
import 'explore_products_page.dart';
import 'cart_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'auth/login_screen.dart';

/// MainNavigation - The main navigation wrapper with bottom navigation bar
///
/// This widget provides:
/// - Modern bottom navigation bar with 5 essential tabs
/// - Smooth navigation between different screens
/// - Badge support for cart items and notifications
/// - Professional design matching the app theme
/// - User-friendly navigation experience
class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  // List of pages for navigation
  static final List<Widget> _pages = [
    const HomePage(),
    BlocProvider(
      create: (context) => ExploreProductsCubit(),
      child: const ExploreProductsPage(),
    ),
    const CartPage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen to authentication state changes
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              // Navigate to login screen when user logs out
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false, // Remove all previous routes
              );
            }
          },
        ),
        BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartLoaded) {
              context
                  .read<NavigationCubit>()
                  .updateCartItemCount(state.totalItems);
            }
          },
        ),
        BlocListener<FavoritesCubit, FavoritesState>(
          listener: (context, state) {
            if (state is FavoritesLoaded) {
              context
                  .read<NavigationCubit>()
                  .updateFavoritesCount(state.totalItems);
            }
          },
        ),
      ],
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state.currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: _buildBottomNavigationBar(context, state),
          );
        },
      ),
    );
  }

  /// Builds the modern bottom navigation bar
  Widget _buildBottomNavigationBar(
      BuildContext context, NavigationState state) {
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
                  context: context,
                  state: state,
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context: context,
                  state: state,
                  index: 1,
                  icon: Icons.medical_services_outlined,
                  activeIcon: Icons.medical_services,
                  label: 'Medicines',
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context: context,
                  state: state,
                  index: 2,
                  icon: Icons.shopping_cart_outlined,
                  activeIcon: Icons.shopping_cart,
                  label: 'Cart',
                  badgeCount: state.cartItemCount,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context: context,
                  state: state,
                  index: 3,
                  icon: Icons.favorite_outline,
                  activeIcon: Icons.favorite,
                  label: 'Favorites',
                  badgeCount: state.favoritesCount,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  context: context,
                  state: state,
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
    required BuildContext context,
    required NavigationState state,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int? badgeCount,
  }) {
    final isActive = state.currentIndex == index;

    return GestureDetector(
      onTap: () {
        context.read<NavigationCubit>().changeTab(index);
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
}
