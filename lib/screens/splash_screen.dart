import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../theme/app_colors.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import 'main_navigation.dart';
import 'auth/login_screen.dart';
import 'auth/admin_approval_screen.dart';

/// SplashScreen - Professional splash screen for Health & Medicine app
///
/// This screen provides:
/// - Beautiful gradient background matching app theme
/// - Custom logo design with medical cross and phone elements
/// - Smooth animations and transitions
/// - Professional branding with app name and tagline
/// - Automatic navigation to main app after delay
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  /// Initialize all animations
  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Logo scale animation
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Text slide animation
    _textAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));
  }

  /// Start the splash screen sequence
  void _startSplashSequence() async {
    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Initialize authentication and wait for minimum splash time
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      // Initialize auth state
      context.read<AuthCubit>().initialize();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // User is authenticated and approved, go to main app
          _navigateToMainApp();
        } else if (state is AuthPendingApproval) {
          // User is waiting for approval
          _navigateToLogin();
        } else if (state is AuthRejected || state is AuthSuspended) {
          // User is rejected or suspended, go to login
          _navigateToLogin();
        } else if (state is AuthUnauthenticated) {
          // User is not authenticated, go to login
          _navigateToLogin();
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
                AppColors.secondary,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Animated Logo Section
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: _buildLogo(),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Animated Text Section
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _textAnimation.value),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildTextSection(),
                      ),
                    );
                  },
                ),

                const Spacer(flex: 3),

                // Loading indicator
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textOnPrimary,
                        ),
                        strokeWidth: 2,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigate to main app
  void _navigateToMainApp() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainNavigation(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  /// Navigate to approval screen
  void _navigateToApprovalScreen(User user) {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              AdminApprovalScreen(user: user),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  /// Navigate to login screen
  void _navigateToLogin() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  /// Builds the custom logo design
  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      alignment: Alignment.center,
      child: ClipOval(
        child: Image.asset(
          'assets/images/applogo.png', // Update with your actual asset path
          width: 150,
          height: 150,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// Builds the text section with app name and tagline
  Widget _buildTextSection() {
    return Column(
      children: [
        // App name
        const Text(
          'HEALTH & MEDICINE',
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // Tagline
        const Text(
          'Best Price & Quickly Service',
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        // Decorative line
        Container(
          width: 60,
          height: 2,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for the medical logo
class MedicalLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textOnPrimary
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw medical cross
    // Vertical bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: 12,
          height: 50,
        ),
        const Radius.circular(6),
      ),
      paint,
    );

    // Horizontal bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: 50,
          height: 12,
        ),
        const Radius.circular(6),
      ),
      paint,
    );

    // Phone curve (representing telemedicine)
    final curvePaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.6,
      size.width * 0.3,
      size.height * 0.4,
    );

    canvas.drawPath(path, curvePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
