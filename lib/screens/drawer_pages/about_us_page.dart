import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';

/// AboutUsPage - Information about the app and company
///
/// This page provides:
/// - Company information and mission
/// - App version and build info
/// - Team information
/// - Social media links
/// - Terms and privacy policy links
/// - Modern UI design matching app theme
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text(
          'About Us',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App logo and name
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.local_pharmacy,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Health & Medicine',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Best Price & Quickly Service',
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.8),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Mission section
            _buildSection(
              title: 'Our Mission',
              content:
                  'We are committed to making healthcare accessible and affordable for everyone. Our mission is to provide genuine medicines and health products with the convenience of online ordering and reliable home delivery.',
              icon: Icons.flag,
            ),

            const SizedBox(height: 24),

            // Vision section
            _buildSection(
              title: 'Our Vision',
              content:
                  'To become the most trusted online pharmacy platform, revolutionizing healthcare delivery through technology and ensuring every person has access to quality medicines when they need them.',
              icon: Icons.visibility,
            ),

            const SizedBox(height: 24),

            // Features section
            _buildSection(
              title: 'What We Offer',
              content: '',
              icon: Icons.star,
              child: Column(
                children: [
                  _buildFeatureItem(Icons.verified, 'Genuine Medicines',
                      'All products are sourced from licensed distributors'),
                  _buildFeatureItem(Icons.local_shipping, 'Fast Delivery',
                      'Quick and reliable delivery to your doorstep'),
                  _buildFeatureItem(Icons.support_agent, '24/7 Support',
                      'Round-the-clock customer support'),
                  _buildFeatureItem(Icons.security, 'Secure Payments',
                      'Safe and secure payment processing through cash on delivery'),
                  _buildFeatureItem(Icons.discount, 'Best Prices',
                      'Competitive prices and regular discounts'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contact information
            _buildSection(
              title: 'Contact Information',
              content: '',
              icon: Icons.contact_phone,
              child: Column(
                children: [
                  _buildContactItem(
                      Icons.location_on, 'Address', 'Dhaka, Bangladesh'),
                  _buildContactItem(Icons.phone, 'Phone', '+880 1234 567890'),
                  _buildContactItem(
                      Icons.email, 'Email', 'mmodumadicenmart@gmail.com'),
                  _buildContactItem(
                      Icons.language, 'Website', 'http://modumadicenmart.com'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Social media links
            // _buildSection(
            //   title: 'Follow Us',
            //   content: '',
            //   icon: Icons.share,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       // _buildSocialButton(Icons.facebook, 'Facebook',
            //       //     () => _openSocialMedia('facebook')),
            //       // _buildSocialButton(Icons.alternate_email, 'Twitter',
            //       //     () => _openSocialMedia('twitter')),
            //       // _buildSocialButton(Icons.camera_alt, 'Instagram',
            //       //     () => _openSocialMedia('instagram')),
            //       // _buildSocialButton(Icons.video_library, 'YouTube',
            //       //     () => _openSocialMedia('youtube')),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 24),

            // Legal links
            // _buildSection(
            //   title: 'Legal',
            //   content: '',
            //   icon: Icons.gavel,
            //   child: Column(
            //     children: [
            //       // _buildLegalItem(
            //       //     'Terms of Service', () => _openLegalPage('terms')),
            //       // _buildLegalItem(
            //       //     'Privacy Policy', () => _openLegalPage('privacy')),
            //       // _buildLegalItem(
            //       //     'Refund Policy', () => _openLegalPage('refund')),
            //       // _buildLegalItem(
            //       //     'Shipping Policy', () => _openLegalPage('shipping')),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 24),

            // App version info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderLight,
                  width: 1,
                ),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'App Version',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '1.0.0',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Build Number',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '100',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Copyright
            Center(
              child: Text(
                '© 2025 Health & Medicine. All rights reserved.',
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.6),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 12),
            child,
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalItem(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  // void _openSocialMedia(String platform) {
  //   // In a real app, these would be actual social media URLs
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Opening $platform page'),
  //       backgroundColor: AppColors.success,
  //     ),
  //   );
  // }

  // void _openLegalPage(String page) {
  //   // In a real app, these would navigate to actual legal pages
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Opening $page page'),
  //       backgroundColor: AppColors.success,
  //     ),
  //   );
  // }
}
