import 'package:flutter/material.dart';

/// AppColors class defines the complete color palette for the Online Medicine app
/// This follows Material Design 3 principles with a medical/healthcare theme
class AppColors {
  // === PRIMARY COLORS ===
  /// Main brand color - Deep medical green, conveys trust and health
  static const Color primary = Color(0xFF004030);

  /// Lighter variant of primary for hover states and accents
  static const Color primaryLight = Color(0xFF2E6B5A);

  /// Darker variant for pressed states and emphasis
  static const Color primaryDark = Color(0xFF002920);

  // === SECONDARY COLORS ===
  /// Secondary brand color - Medium teal, professional medical feel
  static const Color secondary = Color(0xFF4A9782);

  /// Light secondary for subtle backgrounds and highlights
  static const Color secondaryLight = Color(0xFF7BC4A8);

  /// Dark secondary for contrast and depth
  static const Color secondaryDark = Color(0xFF2F6B5C);

  // === ACCENT COLORS ===
  /// Warm accent color - Light beige for warmth and comfort
  static const Color accent = Color(0xFFDCD0A8);

  /// Cream accent for very light backgrounds
  static const Color accentLight = Color(0xFFFFF9E5);

  // === SURFACE COLORS ===
  /// Main background color - Clean and medical
  static const Color background = Color(0xFFF8FAF9);

  /// Card and elevated surface color
  static const Color surface = Color(0xFFFFFFFF);

  /// Slightly elevated surface (like list items)
  static const Color surfaceVariant = Color(0xFFF0F4F2);

  // === TEXT COLORS ===
  /// Primary text color - High contrast for readability
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Secondary text color - Medium contrast for supporting text
  static const Color textSecondary = Color(0xFF6B7280);

  /// Tertiary text color - Low contrast for hints and disabled text
  static const Color textTertiary = Color(0xFF9CA3AF);

  /// Text on primary color backgrounds
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // === FUNCTIONAL COLORS ===
  /// Success color for positive actions and states
  static const Color success = Color(0xFF10B981);

  /// Warning color for caution states
  static const Color warning = Color(0xFFF59E0B);

  /// Error color for negative actions and states
  static const Color error = Color(0xFFEF4444);

  /// Info color for informational states
  static const Color info = Color(0xFF3B82F6);

  // === INTERACTIVE COLORS ===
  /// Hover state color overlay
  static const Color hover = Color(0x0F004030);

  /// Pressed state color overlay
  static const Color pressed = Color(0x1F004030);

  /// Focus state color
  static const Color focus = Color(0xFF4A9782);

  // === BORDER AND DIVIDER COLORS ===
  /// Light border color for subtle separation
  static const Color borderLight = Color(0xFFE5E7EB);

  /// Medium border color for clear separation
  static const Color borderMedium = Color(0xFFD1D5DB);

  /// Strong border color for emphasis
  static const Color borderStrong = Color(0xFF9CA3AF);

  // === SHADOW COLORS ===
  /// Light shadow for subtle elevation
  static const Color shadowLight = Color(0x0A000000);

  /// Medium shadow for moderate elevation
  static const Color shadowMedium = Color(0x14000000);

  /// Strong shadow for high elevation
  static const Color shadowStrong = Color(0x1F000000);
}
