import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// DrawerItem - A modern, interactive navigation item for the drawer
/// 
/// This widget provides:
/// - Modern Material Design 3 styling
/// - Hover and selection states
/// - Icon with background container
/// - Title and optional subtitle
/// - Optional badge for notifications
/// - Destructive action styling (for logout)
/// - Proper accessibility support
class DrawerItem extends StatelessWidget {
  /// The main icon to display
  final IconData icon;
  
  /// Icon to show when item is selected (optional)
  final IconData? selectedIcon;
  
  /// The main title text
  final String title;
  
  /// Optional subtitle text for additional context
  final String? subtitle;
  
  /// Optional badge text (e.g., "New", "3")
  final String? badge;
  
  /// Whether this item is currently selected
  final bool isSelected;
  
  /// Whether this is a destructive action (like logout)
  final bool isDestructive;
  
  /// Callback when item is tapped
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.title,
    this.subtitle,
    this.badge,
    this.isSelected = false,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
      ),
      child: ListTile(
        // Icon with proper theming
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary 
                : isDestructive 
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isSelected && selectedIcon != null ? selectedIcon : icon,
            color: isSelected 
                ? AppColors.textOnPrimary
                : isDestructive 
                    ? AppColors.error
                    : AppColors.textSecondary,
            size: 20,
          ),
        ),
        
        // Title and subtitle
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        
        subtitle: subtitle != null 
            ? Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: isDestructive 
                      ? AppColors.error.withOpacity(0.7)
                      : AppColors.textSecondary,
                ),
              )
            : null,
        
        // Badge or trailing icon
        trailing: badge != null 
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : isSelected 
                ? const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 20,
                  )
                : null,
        
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        
        // Hover effect for better interaction feedback
        hoverColor: AppColors.hover,
        splashColor: AppColors.pressed,
      ),
    );
  }
}
