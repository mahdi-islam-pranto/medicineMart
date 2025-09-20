import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';
import '../../APIs/faq_api_service.dart';
import '../../models/models.dart';
import '../../services/app_settings_storage_service.dart';

/// HelpSupportPage - Customer support and help center
///
/// This page provides:
/// - FAQ section with expandable answers
/// - Contact options (Phone, Email, Chat)
/// - Help categories
/// - Search functionality
/// - Modern UI design matching app theme
class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _expandedFaqIndex;

  // FAQ API state
  List<FaqItem> _faqs = [];
  bool _isLoadingFaqs = true;
  String? _faqErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Load FAQs from API
  Future<void> _loadFaqs() async {
    try {
      setState(() {
        _isLoadingFaqs = true;
        _faqErrorMessage = null;
      });

      final response = await FaqApiService.getAllFaqs();

      if (mounted) {
        setState(() {
          _isLoadingFaqs = false;
          if (response.success) {
            _faqs = response.data;
            _faqErrorMessage = null;
          } else {
            _faqErrorMessage = response.message;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingFaqs = false;
          _faqErrorMessage = 'Failed to load FAQs. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with contact options
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'How can we help you?',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<Map<String, String>>(
                  future: AppSettingsStorageService.getAllSettings(),
                  builder: (context, snapshot) {
                    final settings = snapshot.data ?? {};
                    final phoneNumber =
                        settings['phoneNumber'] ?? '01746733817';
                    final email =
                        settings['email'] ?? 'mmodumadicenmart@gmail.com';

                    return Row(
                      children: [
                        Expanded(
                            child: _buildContactOption(
                          icon: Icons.phone,
                          title: 'Call Us',
                          subtitle: phoneNumber,
                          onTap: () => _makePhoneCall(phoneNumber),
                        )),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildContactOption(
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: email,
                          onTap: () => _sendEmail(email),
                        )),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildContactOption(
                          icon: Icons.chat,
                          title: 'Live Chat',
                          subtitle: 'Chat with us',
                          onTap: () => _startLiveChat(),
                        )),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadFaqs,
              color: AppColors.primary,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Help categories
                    // _buildSectionTitle('Quick Help'),
                    const SizedBox(height: 12),
                    // _buildHelpCategories(),

                    const SizedBox(height: 24),

                    // FAQ section
                    _buildSectionTitle('Frequently Asked Questions'),
                    const SizedBox(height: 12),
                    _buildFaqSearchBar(),
                    const SizedBox(height: 16),
                    _buildFaqSection(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.textOnPrimary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textOnPrimary.withOpacity(0.8),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildFaqSearchBar() {
    return Container(
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
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _expandedFaqIndex = null; // Reset expanded state when searching
          });
        },
        decoration: InputDecoration(
          hintText: 'Search FAQs...',
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSecondary,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _expandedFaqIndex = null;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    // Show loading state
    if (_isLoadingFaqs) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    // Show error state
    if (_faqErrorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(24),
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
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _faqErrorMessage!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFaqs,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (_faqs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
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
        child: const Column(
          children: [
            Icon(
              Icons.help_outline,
              color: AppColors.textSecondary,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'No FAQs available at the moment.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Show FAQ list
    final filteredFaqs = _getFilteredFaqs();

    return Column(
      children: filteredFaqs.asMap().entries.map((entry) {
        final index = entry.key;
        final faq = entry.value;
        final isExpanded = _expandedFaqIndex == index;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
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
          child: ExpansionTile(
            title: Text(
              faq.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.primary,
            ),
            onExpansionChanged: (expanded) {
              setState(() {
                _expandedFaqIndex = expanded ? index : null;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  faq.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<FaqItem> _getFilteredFaqs() {
    if (_searchQuery.isEmpty) return _faqs;

    return _faqs
        .where((faq) =>
            faq.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            faq.description.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _makePhoneCall([String? phoneNumber]) async {
    final phone = phoneNumber ?? '01746733817';
    final phoneUrl = 'tel:+88$phone';
    if (await canLaunchUrl(Uri.parse(phoneUrl))) {
      await launchUrl(Uri.parse(phoneUrl));
    } else {
      _showErrorSnackBar('Could not launch phone dialer');
    }
  }

  void _sendEmail([String? emailAddress]) async {
    final email = emailAddress ?? 'mmodumadicenmart@gmail.com';
    final emailUrl = 'mailto:$email?subject=Support Request';
    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl));
    } else {
      _showErrorSnackBar('Could not launch email client');
    }
  }

  void _startLiveChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Live Chat'),
        content: const Text(
            'Live chat feature will be available soon. Please use phone or email for immediate assistance.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
