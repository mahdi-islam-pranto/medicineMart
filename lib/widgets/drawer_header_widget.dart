import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// DrawerHeaderWidget - A beautiful header for the navigation drawer
///
/// This widget provides:
/// - Fixed height to prevent overflow issues
/// - Gradient background with brand colors
/// - User avatar with proper styling
/// - User information display
/// - Premium member badge
/// - Proper spacing and responsive layout
class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fixed height to prevent overflow - this is key for fixing the RenderFlex error
      height: 240,
      width: double.infinity,
      decoration: const BoxDecoration(
        // Gradient background with brand colors , top to bottom gradient
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
          ],
        ),
      ),
      child: SafeArea(
        // Only apply SafeArea to the top to account for status bar
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            children: [
              // User avatar with border and shadow
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.textOnPrimary.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowMedium,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 28, // Slightly smaller to fit better
                  backgroundColor: AppColors.accentLight,
                  child: Icon(
                    Icons.person,
                    size: 28,
                    color: AppColors.primary,
                  ),
                  // TODO: Replace with actual user image
                  // backgroundImage: NetworkImage(userImageUrl),
                ),
              ),

              const SizedBox(height: 12), // Reduced spacing

              // User name
              const Text(
                'Jesika Sabrina',
                style: TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 18, // Slightly smaller font
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 2), // Reduced spacing

              // User email
              Text(
                'demo@gmail.com',
                style: TextStyle(
                  color: AppColors.textOnPrimary.withOpacity(0.9),
                  fontSize: 13, // Smaller font
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8), // Reduced spacing

              // Status indicator or additional info
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3), // Reduced padding
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Premium Member',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 11, // Smaller font
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
