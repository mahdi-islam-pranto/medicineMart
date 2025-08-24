import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                Row(
                  children: [
                    Expanded(child: _buildContactOption(
                      icon: Icons.phone,
                      title: 'Call Us',
                      subtitle: '24/7 Support',
                      onTap: () => _makePhoneCall(),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _buildContactOption(
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: 'support@medicine.com',
                      onTap: () => _sendEmail(),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _buildContactOption(
                      icon: Icons.chat,
                      title: 'Live Chat',
                      subtitle: 'Chat with us',
                      onTap: () => _startLiveChat(),
                    )),
                  ],
                ),
              ],
            ),
          ),

          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for help...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Help categories
                  _buildSectionTitle('Quick Help'),
                  const SizedBox(height: 12),
                  _buildHelpCategories(),
                  
                  const SizedBox(height: 24),
                  
                  // FAQ section
                  _buildSectionTitle('Frequently Asked Questions'),
                  const SizedBox(height: 12),
                  _buildFaqSection(),
                  
                  const SizedBox(height: 24),
                ],
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

  Widget _buildHelpCategories() {
    final categories = [
      {'icon': Icons.shopping_cart, 'title': 'Orders & Delivery', 'subtitle': 'Track orders, delivery info'},
      {'icon': Icons.payment, 'title': 'Payment & Refunds', 'subtitle': 'Payment methods, refund policy'},
      {'icon': Icons.local_pharmacy, 'title': 'Medicines & Prescriptions', 'subtitle': 'Medicine info, prescriptions'},
      {'icon': Icons.account_circle, 'title': 'Account & Profile', 'subtitle': 'Manage your account'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () => _openHelpCategory(category['title'] as String),
          child: Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'] as IconData,
                  color: AppColors.primary,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  category['title'] as String,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  category['subtitle'] as String,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFaqSection() {
    final faqs = _getFilteredFaqs();
    
    return Column(
      children: faqs.asMap().entries.map((entry) {
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
              faq['question'] as String,
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
                  faq['answer'] as String,
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

  List<Map<String, String>> _getFilteredFaqs() {
    final allFaqs = [
      {
        'question': 'How do I place an order?',
        'answer': 'You can place an order by browsing our products, adding items to cart, and proceeding to checkout. Make sure to provide accurate delivery information.',
      },
      {
        'question': 'What payment methods do you accept?',
        'answer': 'We accept various payment methods including credit/debit cards, mobile banking (bKash, Nagad, Rocket), and cash on delivery.',
      },
      {
        'question': 'How long does delivery take?',
        'answer': 'Standard delivery takes 1-3 business days within Dhaka and 3-5 business days outside Dhaka. Express delivery is available for urgent orders.',
      },
      {
        'question': 'Can I return medicines?',
        'answer': 'Due to safety regulations, medicines cannot be returned once delivered. However, if you receive damaged or wrong items, please contact us immediately.',
      },
      {
        'question': 'Do I need a prescription for all medicines?',
        'answer': 'Prescription medicines require a valid prescription from a registered doctor. Over-the-counter medicines can be purchased without prescription.',
      },
      {
        'question': 'How do I track my order?',
        'answer': 'You can track your order from the "My Orders" section in the app or by using the tracking link sent to your email/SMS.',
      },
    ];

    if (_searchQuery.isEmpty) return allFaqs;
    
    return allFaqs.where((faq) =>
        faq['question']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        faq['answer']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  void _makePhoneCall() async {
    const phoneNumber = 'tel:+8801234567890';
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      _showErrorSnackBar('Could not launch phone dialer');
    }
  }

  void _sendEmail() async {
    const email = 'mailto:support@medicine.com?subject=Support Request';
    if (await canLaunchUrl(Uri.parse(email))) {
      await launchUrl(Uri.parse(email));
    } else {
      _showErrorSnackBar('Could not launch email client');
    }
  }

  void _startLiveChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Live Chat'),
        content: const Text('Live chat feature will be available soon. Please use phone or email for immediate assistance.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openHelpCategory(String category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $category help section'),
        backgroundColor: AppColors.success,
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
