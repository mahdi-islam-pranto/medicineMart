# Product List & Explore Products Documentation

## 📋 Overview
This document provides a comprehensive guide to the Product List functionality in the Online Medicine app, including the Explore Products page, API integration, filtering, and state management.

## 🏗️ Architecture Overview

### State Management Pattern
- **BLoC Pattern**: Using Cubit for state management
- **Main Cubit**: `ExploreProductsCubit` handles all product-related operations
- **States**: Loading, Loaded, Error states for different UI conditions

### API Integration
- **Product API**: Fetches products with filtering and pagination
- **Brand API**: Fetches company/brand names for filtering
- **Real Data Only**: No dummy data fallbacks - shows errors when API fails

## 📁 File Structure

```
lib/
├── APIs/
│   ├── api_config.dart              # API endpoints and configuration
│   ├── product_api_service.dart     # Product API calls
│   └── brand_api_service.dart       # Brand API calls
├── models/
│   ├── medicine.dart                # Product/Medicine model
│   ├── brand_models.dart            # Brand models
│   ├── product_filter.dart          # Filter state model
│   └── product_api_models.dart      # API request/response models
├── bloc/cubits/
│   └── explore_products_cubit.dart  # Main state management
├── screens/
│   └── explore_products_page.dart   # Main UI page
└── widgets/
    ├── medicine_card.dart           # Product display card
    ├── filter_bottom_sheet.dart     # Filter UI
    └── sort_bottom_sheet.dart       # Sort UI
```

## 🔄 Data Flow Workflow

### 1. Initial Load Process
```
User Opens Explore Products Page
        ↓
ExploreProductsCubit.loadProducts()
        ↓
ProductApiService.getAllProducts(limit: 1000)
        ↓
BrandApiService.getBrandNames()
        ↓
ExploreProductsLoaded State Emitted
        ↓
UI Updates with Products & Filters
```

### 2. Filter Application Process
```
User Applies Filter
        ↓
ExploreProductsCubit.applyFilter(filter)
        ↓
ProductApiService.searchProducts(request)
        ↓
Local Filtering Applied (if needed)
        ↓
ExploreProductsLoaded State Updated
        ↓
UI Shows Filtered Results
```

## 🎯 Key Features

### ✅ Implemented Features

1. **Real API Data Only**
   - No dummy data fallbacks
   - Error states when API fails
   - Comprehensive logging for debugging

2. **Product Tag Filtering**
   - `All`: Shows all products
   - `Trending`: Products with `productTag = "trending"`
   - `Special Offer`: Products with `productTag = "special_offer"`
   - `New Product`: Products with `productTag = "top_selling"`

3. **Brand/Company Filtering**
   - Dynamic brand list from API
   - Multi-select brand filtering
   - Search within brands

4. **Search & Sort**
   - Real-time search by product name/brand
   - Multiple sort options (name, price, discount)
   - Combined with other filters

5. **Navigation**
   - Back button in app bar
   - Navigation to main screen
   - Clean UI design

## 📊 API Integration Details

### Product API Endpoint
```
URL: http://admin.modumadicenmart.com/api/products/search
Method: POST
Content-Type: application/json
```

**Request Body:**
```json
{
  "searchQuery": "string",
  "selectedBrands": "comma,separated,brands",
  "selectedCategories": "comma,separated,categories",
  "productType": "trending|special_offer|top_selling",
  "sortOption": "name_asc|price_desc|etc",
  "priceRange": {"min": 0, "max": 1000},
  "pagination": {"page": 1, "limit": 1000}
}
```

### Brand API Endpoint
```
URL: http://admin.modumadicenmart.com/api/brand
Method: GET
Content-Type: application/json
```

**Response:**
```json
{
  "status": "200",
  "message": "Brands",
  "data": [
    {"id": 1, "name": "Brand Name"},
    ...
  ]
}
```

## 🧩 Code Components

### 1. Medicine Model (`lib/models/medicine.dart`)
```dart
class Medicine extends Equatable {
  final String id;
  final String name;
  final String quantity;
  final String brand;
  final double regularPrice;
  final double? discountPrice;
  final String? imageUrl;
  final String description;
  final bool requiresPrescription;
  final List<int> quantityOptions;
  final String? productTag;  // KEY: Used for filtering
}
```

**Key Points:**
- `productTag` field is crucial for category filtering
- `fromApiJson()` factory handles API response parsing
- Fallback image URL when `imageUrl` is null

### 2. ExploreProductsCubit (`lib/bloc/cubits/explore_products_cubit.dart`)

**Key Methods:**
- `loadProducts()`: Initial data loading
- `applyFilter()`: Apply filters and search
- `updateSearchQuery()`: Real-time search
- `updateProductCategory()`: Category tab filtering
- `_loadBrandsFromAPI()`: Load brands from API
- `_applyProductCategoryFilter()`: Filter by productTag

**State Management:**
```dart
// States
ExploreProductsInitial()     // Initial state
ExploreProductsLoading()     // Loading data
ExploreProductsLoaded(...)   // Data loaded successfully
ExploreProductsError(...)    // Error occurred
```

### 3. Explore Products Page (`lib/screens/explore_products_page.dart`)

**UI Components:**
- App bar with back button
- Search bar
- Category filter tabs
- Filter & sort buttons
- Product list/grid
- Empty state handling

**Key Features:**
- BlocBuilder for state management
- Pull-to-refresh capability
- Error state handling
- Navigation back to main screen

## 🔧 Development Guidelines

### Adding New Filters

1. **Update ProductFilter Model** (`lib/models/product_filter.dart`)
```dart
class ProductFilter extends Equatable {
  // Add new filter property
  final YourNewFilter? newFilter;

  const ProductFilter({
    // ... existing properties
    this.newFilter,
  });
}
```

2. **Update API Request Model** (`lib/models/product_api_models.dart`)
```dart
class ProductSearchRequest extends Equatable {
  // Add corresponding API field
  final String newFilterField;
}
```

3. **Update Cubit Logic** (`lib/bloc/cubits/explore_products_cubit.dart`)
```dart
// Add filter application logic
List<Medicine> _applyFilters(List<Medicine> products, ProductFilter filter) {
  // ... existing filters

  // Apply new filter
  if (filter.newFilter != null) {
    filtered = filtered.where((product) {
      // Your filter logic here
    }).toList();
  }
}
```

4. **Update UI** (`lib/widgets/filter_bottom_sheet.dart`)
```dart
// Add new filter UI components
Widget _buildNewFilterTab() {
  // Your filter UI here
}
```

### Adding New Sort Options

1. **Update SortOption Enum** (`lib/models/sort_option.dart`)
```dart
enum SortOption {
  // ... existing options
  yourNewSortOption,
}
```

2. **Update API Conversion** (`lib/APIs/product_api_service.dart`)
```dart
static String _convertSortOptionToString(SortOption sortOption) {
  switch (sortOption) {
    // ... existing cases
    case SortOption.yourNewSortOption:
      return 'your_api_sort_value';
  }
}
```

3. **Update Local Sorting** (`lib/bloc/cubits/explore_products_cubit.dart`)
```dart
List<Medicine> _applySorting(List<Medicine> products, SortOption sortOption) {
  switch (sortOption) {
    // ... existing cases
    case SortOption.yourNewSortOption:
      return products..sort((a, b) => /* your sorting logic */);
  }
}
```

## 🐛 Debugging & Logging

### Console Logs to Monitor

**Product Loading:**
```
🔄 Loading products from API...
✅ Successfully loaded 25 products from API
❌ API failed to load products: [error message]
```

**Brand Loading:**
```
🔄 Loading brands from API...
✅ Successfully loaded 15 brands from API
❌ Error loading brands from API: [error]
```

**Filter Application:**
```
🔄 Applying filters: ProductFilter(...)
✅ API filter returned 8 products
⚠️ API filter failed, applying filters locally
```

### Common Issues & Solutions

1. **No Products Showing**
   - Check API endpoint connectivity
   - Verify API response format
   - Check console logs for errors
   - Ensure `productTag` field is properly set

2. **Filters Not Working**
   - Verify filter conversion in `convertFilterToRequest()`
   - Check API request body format
   - Test local filtering fallback

3. **Brands Not Loading**
   - Check brand API endpoint
   - Verify brand response format
   - Check network connectivity

## 📱 UI/UX Guidelines

### Loading States
- Show loading spinner during API calls
- Disable user interactions during loading
- Provide clear feedback for long operations

### Error States
- Show user-friendly error messages
- Provide retry options
- Log detailed errors for debugging
- Never show dummy data on API failure

### Empty States
- Clear "No products found" message
- Suggest filter adjustments
- Maintain filter UI visibility

### Performance Considerations
- Use pagination (limit: 1000 currently)
- Implement proper image loading with fallbacks
- Cache brand data when possible
- Optimize filter operations

## 🚀 Future Enhancements

### Planned Features
1. **Advanced Filtering**
   - Price range slider
   - Prescription requirement filter
   - Availability status filter

2. **Enhanced Search**
   - Search suggestions
   - Search history
   - Barcode scanning

3. **Performance Improvements**
   - Infinite scroll pagination
   - Image caching
   - Offline support

4. **Analytics**
   - Track popular searches
   - Filter usage analytics
   - Performance monitoring

## 📞 Support & Maintenance

### Key Files to Monitor
- `lib/APIs/product_api_service.dart` - API integration
- `lib/bloc/cubits/explore_products_cubit.dart` - Business logic
- `lib/screens/explore_products_page.dart` - UI implementation

### Testing Checklist
- [ ] Product loading from API
- [ ] Brand loading from API
- [ ] All filter combinations
- [ ] Search functionality
- [ ] Sort options
- [ ] Error handling
- [ ] Navigation flow
- [ ] Performance with large datasets

### Deployment Notes
- Ensure API endpoints are accessible
- Test with production data
- Monitor API response times
- Check error rates and logging

---

**Last Updated:** [Current Date]
**Version:** 1.0
**Maintainer:** Development Team
