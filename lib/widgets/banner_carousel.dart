import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// BannerCarousel - A horizontal scrollable banner widget for medicine advertisements
///
/// This widget provides:
/// - Smooth horizontal scrolling with page indicators
/// - Auto-scroll functionality with pause on user interaction
/// - Professional banner design with gradients and shadows
/// - Responsive design that works on different screen sizes
/// - Customizable banner content and styling
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Sample banner data - In a real app, this would come from an API
  final List<BannerData> _banners = [
    BannerData(
      title: 'Free Delivery',
      subtitle: 'On orders above ৳500',
      description: 'Get your medicines delivered to your doorstep for free!',
      color: AppColors.primary,
      icon: Icons.local_shipping,
    ),
    BannerData(
      title: '20% OFF',
      subtitle: 'On all supplements',
      description: 'Boost your health with premium supplements at great prices',
      color: AppColors.secondary,
      icon: Icons.local_offer,
    ),
    BannerData(
      title: '24/7 Support',
      subtitle: 'Expert consultation',
      description: 'Get professional medical advice anytime, anywhere',
      color: AppColors.primaryLight,
      icon: Icons.support_agent,
    ),
    BannerData(
      title: 'Quick Refill',
      subtitle: 'Upload prescription',
      description: 'Refill your regular medicines with just a photo',
      color: AppColors.primaryDark,
      icon: Icons.camera_alt,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

// Stop auto-scroll when widget is disposed
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Starts auto-scroll functionality
  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive banner height (15% of screen height, min 140, max 180)
    final bannerHeight = (screenHeight * 0.20).clamp(140.0, 180.0);

    return Container(
      height: bannerHeight + 24, // Add space for indicators
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Banner PageView
          SizedBox(
            height: bannerHeight,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                return _buildBannerItem(_banners[index], screenWidth);
              },
            ),
          ),

          const SizedBox(height: 8),

          // Page indicators
          SizedBox(
            height: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (index) => _buildIndicator(index == _currentPage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual banner item with responsive design
  Widget _buildBannerItem(BannerData banner, double screenWidth) {
    // Calculate responsive margins and padding
    final horizontalMargin = (screenWidth * 0.04).clamp(12.0, 20.0);
    final contentPadding = (screenWidth * 0.04).clamp(12.0, 20.0);

    // Calculate responsive font sizes
    final titleFontSize = (screenWidth * 0.055).clamp(20.0, 28.0);
    final subtitleFontSize = (screenWidth * 0.04).clamp(14.0, 18.0);
    final descriptionFontSize = (screenWidth * 0.03).clamp(11.0, 14.0);
    final buttonFontSize = (screenWidth * 0.03).clamp(11.0, 14.0);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            banner.color,
            banner.color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowMedium,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              banner.icon,
              size: 120,
              color: AppColors.textOnPrimary.withOpacity(0.1),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Title
                Text(
                  banner.title,
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: contentPadding * 0.2),

                // Subtitle
                Text(
                  banner.subtitle,
                  style: TextStyle(
                    color: AppColors.textOnPrimary.withOpacity(0.9),
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: contentPadding * 0.3),

                // Description
                Text(
                  banner.description,
                  style: TextStyle(
                    color: AppColors.textOnPrimary.withOpacity(0.8),
                    fontSize: descriptionFontSize,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // SizedBox(height: contentPadding * 0.4),
                const Spacer(),
                // Action button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Handle banner action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${banner.title} clicked!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textOnPrimary,
                    foregroundColor: banner.color,
                    padding: EdgeInsets.symmetric(
                      horizontal: contentPadding * 0.8,
                      vertical: contentPadding * 0.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(contentPadding),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Learn More',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds page indicator dot
  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.borderLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Data model for banner content
class BannerData {
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final IconData icon;

  BannerData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.icon,
  });
}
