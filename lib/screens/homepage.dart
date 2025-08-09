import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/search_widget.dart';
import '../widgets/filter_widgets.dart';
import '../widgets/medicine_list.dart';
import '../widgets/medicine_card.dart';
import '../theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Filter states
  String _searchQuery = '';
  String? _selectedBrand;
  String? _selectedLetter;

  // App states
  final Map<String, bool> _favorites = {};
  final Map<String, int> _cartItems = {};
  bool _isLoading = false;

  // Sample data - In a real app, this would come from an API
  late List<Medicine> _medicines;
  late List<String> _brands;

  @override
  void initState() {
    super.initState();
    _initializeSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Enhanced app bar with proper theming and professional design
      appBar: _buildAppBar(context),
      // Modern, production-grade drawer
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner carousel section
              const BannerCarousel(),

              const SizedBox(height: 16),

              // Search section
              SearchWidget(
                onSearchChanged: _onSearchChanged,
                initialQuery: _searchQuery,
              ),

              const SizedBox(height: 16),

              // Active filters display
              ActiveFilters(
                selectedBrand: _selectedBrand,
                selectedLetter: _selectedLetter,
                searchQuery: _searchQuery,
                onBrandRemoved: (brand) =>
                    setState(() => _selectedBrand = null),
                onLetterRemoved: (letter) =>
                    setState(() => _selectedLetter = null),
                onSearchRemoved: (query) => _onSearchChanged(''),
                onClearAll: _clearAllFilters,
              ),

              // Brand filter section
              FilterSection(
                child: BrandFilter(
                  brands: _brands,
                  selectedBrand: _selectedBrand,
                  onBrandSelected: _onBrandSelected,
                ),
              ),

              // Alphabet filter section
              FilterSection(
                showDivider: false,
                child: AlphabetFilter(
                  selectedLetter: _selectedLetter,
                  onLetterSelected: _onLetterSelected,
                ),
              ),

              const SizedBox(height: 16),

              // Medicine list section
              MedicineList(
                medicines: _medicines,
                searchQuery: _searchQuery,
                selectedBrand: _selectedBrand,
                selectedLetter: _selectedLetter,
                favorites: _favorites,
                cartItems: _cartItems,
                onFavoriteToggle: _onFavoriteToggle,
                onAddToCart: _onAddToCart,
                isLoading: _isLoading,
              ),

              const SizedBox(height: 24), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  /// Initializes sample medicine data
  /// In a real app, this would fetch data from an API
  void _initializeSampleData() {
    _medicines = [
      Medicine(
        id: '1',
        name: 'Tablet- Acipro',
        quantity: 'Box',
        brand: 'Square',
        regularPrice: 500.00,
        discountPrice: 410.00,
        imageUrl:
            'https://via.placeholder.com/150x150/E3F2FD/1976D2?text=ACIPRO',
        description: 'Pain relief and fever reducer',
        requiresPrescription: false,
      ),
      Medicine(
        id: '2',
        name: 'Tablet- Amox',
        quantity: 'Box',
        brand: 'Square',
        regularPrice: 630.00,
        discountPrice: 360.00,
        imageUrl: 'https://via.placeholder.com/150x150/FFF3E0/F57C00?text=AMOX',
        description: 'Antibiotic for bacterial infections',
        requiresPrescription: true,
      ),
      Medicine(
        id: '3',
        name: 'Syrup- Asthalin',
        quantity: '100ml',
        brand: 'Renata',
        regularPrice: 360.00,
        discountPrice: 230.00,
        imageUrl:
            'https://via.placeholder.com/150x150/E8F5E8/4CAF50?text=SYRUP',
        description: 'Antihistamine for allergies',
        requiresPrescription: false,
      ),
      Medicine(
        id: '4',
        name: 'Capsule- Amoxicillin',
        quantity: '500ml',
        brand: 'Beximco',
        regularPrice: 600.00,
        discountPrice: 410.00,
        imageUrl: 'https://via.placeholder.com/150x150/FFF8E1/FFC107?text=CAPS',
        description: 'Proton pump inhibitor for acid reflux',
        requiresPrescription: false,
      ),
      Medicine(
        id: '5',
        name: 'Syrup- Reneta-B',
        quantity: '250ml',
        brand: 'Renata',
        regularPrice: 630.00,
        discountPrice: 500.00,
        imageUrl:
            'https://via.placeholder.com/150x150/FCE4EC/E91E63?text=SYRUP',
        description: 'Diabetes medication',
        requiresPrescription: true,
      ),
      Medicine(
        id: '6',
        name: 'Injection- Cefotaxime',
        quantity: '1000mg',
        brand: 'Beximco',
        regularPrice: 450.00,
        imageUrl: 'https://via.placeholder.com/150x150/F3E5F5/9C27B0?text=INJ',
        description: 'Blood thinner and pain reliever',
        requiresPrescription: false,
      ),
      Medicine(
        id: '7',
        name: 'Tablet- Ibuprofen',
        quantity: '400mg',
        brand: 'Sun Pharma',
        regularPrice: 220.00,
        discountPrice: 176.00,
        imageUrl: 'https://via.placeholder.com/150x150/E1F5FE/0277BD?text=IBU',
        description: 'Anti-inflammatory pain reliever',
        requiresPrescription: false,
      ),
      Medicine(
        id: '8',
        name: 'Capsule- Losartan',
        quantity: '50mg',
        brand: 'Dr. Reddy\'s',
        regularPrice: 557.50,
        imageUrl: 'https://via.placeholder.com/150x150/EFEBE9/5D4037?text=LOS',
        description: 'Blood pressure medication',
        requiresPrescription: true,
      ),
      Medicine(
        id: '9',
        name: 'Tablet- Vitamin D3',
        quantity: '1000 IU',
        brand: 'HealthKart',
        regularPrice: 1250.00,
        discountPrice: 990.00,
        imageUrl: 'https://via.placeholder.com/150x150/FFF9C4/F9A825?text=VIT',
        description: 'Vitamin D supplement',
        requiresPrescription: false,
      ),
      Medicine(
        id: '10',
        name: 'Tablet- Calcium',
        quantity: '500mg',
        brand: 'Lupin',
        regularPrice: 655.00,
        imageUrl: 'https://via.placeholder.com/150x150/E8EAF6/3F51B5?text=CAL',
        description: 'Calcium supplement',
        requiresPrescription: false,
      ),
    ];

    // Extract unique brands
    _brands = _medicines.map((medicine) => medicine.brand).toSet().toList();
    _brands.sort();
  }

  /// Handles search query changes
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  /// Handles brand filter selection
  void _onBrandSelected(String? brand) {
    setState(() {
      _selectedBrand = brand;
    });
  }

  /// Handles alphabet filter selection
  void _onLetterSelected(String? letter) {
    setState(() {
      _selectedLetter = letter;
    });
  }

  /// Clears all active filters
  void _clearAllFilters() {
    setState(() {
      _searchQuery = '';
      _selectedBrand = null;
      _selectedLetter = null;
    });
  }

  /// Handles favorite toggle
  void _onFavoriteToggle(Medicine medicine) {
    setState(() {
      _favorites[medicine.id] = !(_favorites[medicine.id] ?? false);
    });

    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _favorites[medicine.id] == true
              ? '${medicine.name} added to favorites'
              : '${medicine.name} removed from favorites',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  /// Handles add to cart functionality
  void _onAddToCart(Medicine medicine, int quantity) {
    setState(() {
      if (quantity > 0) {
        _cartItems[medicine.id] = quantity;
      } else {
        _cartItems.remove(medicine.id);
      }
    });

    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          quantity > 0
              ? '${medicine.name} ${quantity > 1 ? 'quantity updated' : 'added to cart'}'
              : '${medicine.name} removed from cart',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  /// Handles pull-to-refresh
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would fetch fresh data from API here
    _initializeSampleData();

    setState(() {
      _isLoading = false;
    });
  }

  /// Builds a professional app bar with proper theming and functionality
  ///
  /// Features:
  /// - Gradient background matching our brand colors
  /// - Proper spacing and typography
  /// - Search icon for quick medicine search
  /// - Notification badge with count
  /// - Profile access
  /// - Consistent with Material Design 3
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize:
          const Size.fromHeight(64), // Increased height for better proportions
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
            ],
          ),
          // Add subtle shadow for depth
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: AppBar(
          // Make background transparent to show gradient
          backgroundColor: Colors.transparent,
          elevation: 0,

          // Custom drawer icon with better styling
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.menu,
                  color: AppColors.textOnPrimary,
                  size: 20,
                ),
              ),
            ),
          ),

          // App title with proper typography
          title: const Row(
            children: [
              Icon(
                Icons.local_pharmacy,
                color: AppColors.textOnPrimary,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'MediCare+',
                style: TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          // Action buttons with proper styling
          actions: [
            // Search icon
            IconButton(
              onPressed: () {
                // TODO: Implement search functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Search feature coming soon!')),
                );
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.search,
                  color: AppColors.textOnPrimary,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(width: 4),

            // Notification icon with badge
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Navigate to notifications
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Notifications coming soon!')),
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.textOnPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textOnPrimary,
                      size: 20,
                    ),
                  ),
                ),
                // Notification badge
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 4),

            // Profile icon
            IconButton(
              onPressed: () {
                // TODO: Navigate to profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile coming soon!')),
                );
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppColors.textOnPrimary,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(width: 12), // Right padding
          ],
        ),
      ),
    );
  }
}
