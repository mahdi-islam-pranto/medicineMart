# 🚀 API Integration Guide - Online Medicine App

## 📋 Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [API Configuration](#api-configuration)
4. [API Services](#api-services)
5. [Integration Patterns](#integration-patterns)
6. [Error Handling](#error-handling)
7. [State Management](#state-management)
8. [Best Practices](#best-practices)
9. [Testing](#testing)
10. [Troubleshooting](#troubleshooting)

## 🎯 Overview

This guide provides comprehensive documentation for API integration in the Online Medicine Flutter app. The app follows a clean architecture pattern with dedicated API service classes, proper error handling, and BLoC state management.

### Key Features
- ✅ Centralized API configuration
- ✅ Dedicated service classes for each domain
- ✅ Comprehensive error handling
- ✅ BLoC/Cubit state management integration
- ✅ Proper request/response models
- ✅ Timeout and network error handling
- ✅ Loading states and user feedback

## 🏗️ Architecture

### Project Structure
```
lib/
├── APIs/                           # API service layer
│   ├── api_config.dart            # Central API configuration
│   ├── auth_api_service.dart      # Authentication APIs
│   ├── product_api_service.dart   # Product search & management
│   ├── cart_api_service.dart      # Cart operations
│   ├── order_api_service.dart     # Order creation
│   ├── order_list_api_service.dart # Order listing
│   ├── brand_api_service.dart     # Brand/Company data
│   ├── category_api_service.dart  # Category data
│   ├── feedback_api_service.dart  # User feedback
│   ├── faq_api_service.dart       # FAQ data
│   └── app_settings_api_service.dart # App configuration
├── models/                        # Data models
│   ├── auth_models.dart          # Authentication models
│   ├── product_api_models.dart   # Product API models
│   ├── cart_list_models.dart     # Cart models
│   ├── order_models.dart         # Order models
│   ├── brand_models.dart         # Brand models
│   ├── category_models.dart      # Category models
│   ├── feedback_models.dart      # Feedback models
│   ├── faq_models.dart          # FAQ models
│   └── app_settings_models.dart  # App settings models
├── bloc/cubits/                  # State management
│   ├── auth_cubit.dart          # Authentication state
│   ├── explore_products_cubit.dart # Product listing state
│   ├── cart_cubit.dart          # Cart state
│   ├── order_cubit.dart         # Order state
│   └── medicine_cubit.dart      # Medicine data state
└── screens/                     # UI screens
    └── [various screens using the APIs]
```

## ⚙️ API Configuration

### Base Configuration (`lib/APIs/api_config.dart`)

The `ApiConfig` class centralizes all API endpoints and configuration:

```dart
class ApiConfig {
  // Base URL - easily changeable for different environments
  static const String baseUrl = 'http://admin.modumadicenmart.com/api/';
  
  // Timeout configuration
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Headers for JSON requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Headers for multipart requests (file uploads)
  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
  };
}
```

### Environment Configuration
To switch between development, staging, and production:

1. **Development**: Use local/development server URL
2. **Staging**: Use staging server URL  
3. **Production**: Use production server URL

Simply change the `baseUrl` in `ApiConfig` class.

## 🔧 API Services

### 1. Authentication API Service

**File**: `lib/APIs/auth_api_service.dart`

**Endpoints**:
- Registration: `POST /customers/create`
- Login: `POST /app/login`

**Key Methods**:
```dart
// Register new pharmacy owner
static Future<AuthResponse> register(RegistrationRequest request)

// Login with credentials
static Future<AuthResponse> login(LoginRequest request)
```

**Usage Example**:
```dart
// In AuthCubit
final response = await AuthApiService.login(loginRequest);
if (response.success && response.user != null) {
  // Handle successful login
  emit(AuthAuthenticated(user: response.user!, token: response.token));
} else {
  // Handle login error
  emit(AuthLoginError(message: response.message));
}
```

### 2. Product API Service

**File**: `lib/APIs/product_api_service.dart`

**Endpoints**:
- Product Search: `POST /products/search`

**Key Methods**:
```dart
// Main search method with filters
static Future<ProductSearchResponse> searchProducts(ProductSearchRequest request)

// Convenience methods
static Future<ProductSearchResponse> getAllProducts({int page = 1, int limit = 40})
static Future<ProductSearchResponse> searchProductsByQuery(String query)
static Future<ProductSearchResponse> getProductsByBrands(List<String> brands)
static Future<ProductSearchResponse> getProductsByCategories(List<String> categories)
```

**Request Structure**:
```json
{
  "searchQuery": "medicine name",
  "selectedBrands": "brand1,brand2",
  "selectedCategories": "category1,category2", 
  "productType": "trending|special_offer|top_selling",
  "sortOption": "name_a_to_z|price_low_to_high|price_high_to_low",
  "priceRange": {"min": 0, "max": 1000},
  "pagination": {"page": 1, "limit": 40}
}
```

### 3. Cart API Service

**File**: `lib/APIs/cart_api_service.dart`

**Endpoints**:
- Add to Cart: `POST /product/add/to/cart`
- Get Cart Items: `POST /product/add/to/cart/list`

**Key Methods**:
```dart
// Add or update cart item
static Future<CartApiResponse> addToCart({
  required int productId,
  required int customerId, 
  required int quantity,
})

// Get all cart items
static Future<CartListResponse> getCartItems({required int customerId})
```

### 4. Order API Service

**File**: `lib/APIs/order_api_service.dart`

**Endpoints**:
- Create Order: `POST /invoice/create`

**Key Methods**:
```dart
// Create new order
static Future<OrderResponse> createOrder(OrderRequest request)
```

**Request Structure**:
```json
{
  "customer_id": 1,
  "items": [
    {
      "product_id": 1,
      "quantity": 2,
      "unit_price": 150.00
    }
  ],
  "subtotal": 300.00,
  "discount": 30.00,
  "total_amount": 270.00
}
```

### 5. Brand & Category API Services

**Files**: 
- `lib/APIs/brand_api_service.dart`
- `lib/APIs/category_api_service.dart`

**Endpoints**:
- Brands: `GET /brand`
- Categories: `GET /category`

**Key Methods**:
```dart
// Get all brands
static Future<BrandResponse> getAllBrands()

// Get all categories  
static Future<CategoryResponse> getAllCategories()
```

### 6. Feedback API Service

**File**: `lib/APIs/feedback_api_service.dart`

**Endpoints**:
- Submit Feedback: `POST /feedback`

**Key Methods**:
```dart
// Submit user feedback
static Future<FeedbackResponse> submitFeedback(FeedbackRequest request)
```

### 7. App Settings API Service

**File**: `lib/APIs/app_settings_api_service.dart`

**Endpoints**:
- Get Settings: `GET /settings/data`

**Key Methods**:
```dart
// Get app configuration
static Future<AppSettingsResponse> getAppSettings()
```

## 🔄 Integration Patterns

### 1. API Service Pattern

Each API service follows this consistent pattern:

```dart
class ExampleApiService {
  /// Method description
  ///
  /// Parameters and return value documentation
  static Future<ResponseModel> methodName(RequestModel request) async {
    try {
      // Log the request
      print('🔄 Making API call to: ${ApiConfig.exampleUrl}');
      
      // Make HTTP request
      final response = await http.post(
        Uri.parse(ApiConfig.exampleUrl),
        headers: ApiConfig.headers,
        body: json.encode(request.toJson()),
      ).timeout(ApiConfig.requestTimeout);
      
      // Log response
      print('📡 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');
      
      // Parse response
      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        // Success case
        return ResponseModel.fromJson(responseData);
      } else {
        // Error case
        return ResponseModel.error(
          message: responseData['message'] ?? 'Request failed',
        );
      }
    } on SocketException {
      // Network error
      return ResponseModel.error(
        message: 'No internet connection. Please check your network.',
      );
    } on http.ClientException {
      // HTTP client error
      return ResponseModel.error(
        message: 'Network error. Please try again.',
      );
    } on FormatException {
      // JSON parsing error
      return ResponseModel.error(
        message: 'Invalid response from server.',
      );
    } catch (e) {
      // Generic error
      return ResponseModel.error(
        message: 'Request failed. Please try again.',
      );
    }
  }
}
```

### 2. Model Pattern

All API models follow this pattern:

```dart
// Request Model
class ExampleRequest {
  final String field1;
  final int field2;
  
  const ExampleRequest({
    required this.field1,
    required this.field2,
  });
  
  Map<String, dynamic> toJson() => {
    'field1': field1,
    'field2': field2,
  };
}

// Response Model
class ExampleResponse {
  final bool success;
  final String message;
  final ExampleData? data;
  
  const ExampleResponse({
    required this.success,
    required this.message,
    this.data,
  });
  
  factory ExampleResponse.fromJson(Map<String, dynamic> json) => ExampleResponse(
    success: json['status'] == '200',
    message: json['message'] ?? '',
    data: json['data'] != null ? ExampleData.fromJson(json['data']) : null,
  );
  
  factory ExampleResponse.error({required String message}) => ExampleResponse(
    success: false,
    message: message,
  );
}
```

## ⚠️ Error Handling

### 1. Network Error Types

The app handles these error scenarios:

```dart
// Network connectivity issues
on SocketException {
  return ResponseModel.error(
    message: 'No internet connection. Please check your network and try again.',
  );
}

// HTTP client errors (timeouts, connection refused, etc.)
on http.ClientException {
  return ResponseModel.error(
    message: 'Network error. Please try again.',
  );
}

// JSON parsing errors (malformed response)
on FormatException {
  return ResponseModel.error(
    message: 'Invalid response from server. Please try again.',
  );
}

// Generic errors
catch (e) {
  return ResponseModel.error(
    message: 'Request failed. Please try again.',
  );
}
```

### 2. HTTP Status Code Handling

```dart
if (response.statusCode == 200) {
  // Success
  return ResponseModel.fromJson(responseData);
} else if (response.statusCode == 403) {
  // Specific handling for authentication issues
  return ResponseModel.error(
    message: 'Wait for admin approval. Please try after some time again.',
  );
} else if (response.statusCode >= 400 && response.statusCode < 500) {
  // Client errors
  return ResponseModel.error(
    message: responseData['message'] ?? 'Invalid request.',
  );
} else if (response.statusCode >= 500) {
  // Server errors
  return ResponseModel.error(
    message: 'Server error. Please try again later.',
  );
}
```

### 3. User-Friendly Error Messages

Always provide clear, actionable error messages:

```dart
// Good error messages
'No internet connection. Please check your network and try again.'
'Invalid credentials. Please check your email and password.'
'Wait for admin approval. Please try after some time again.'

// Avoid technical error messages
'SocketException: Failed host lookup'
'HTTP 500 Internal Server Error'
'FormatException: Unexpected character'
```

## 🎯 State Management Integration

### 1. BLoC/Cubit Pattern

Each API service integrates with BLoC/Cubit for state management:

```dart
class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit() : super(const ExampleInitial());

  Future<void> loadData() async {
    emit(const ExampleLoading());

    try {
      final response = await ExampleApiService.getData();

      if (response.success && response.data != null) {
        emit(ExampleLoaded(data: response.data!));
      } else {
        emit(ExampleError(message: response.message));
      }
    } catch (e) {
      emit(ExampleError(message: 'Failed to load data: ${e.toString()}'));
    }
  }

  Future<void> refreshData() async {
    final currentState = state;
    if (currentState is ExampleLoaded) {
      emit(currentState.copyWith(isRefreshing: true));

      try {
        final response = await ExampleApiService.getData();

        if (response.success && response.data != null) {
          emit(currentState.copyWith(
            data: response.data!,
            isRefreshing: false,
          ));
        } else {
          emit(currentState.copyWith(isRefreshing: false));
        }
      } catch (e) {
        emit(currentState.copyWith(isRefreshing: false));
      }
    }
  }
}
```

### 2. State Classes

Define comprehensive state classes:

```dart
abstract class ExampleState extends Equatable {
  const ExampleState();

  @override
  List<Object?> get props => [];
}

class ExampleInitial extends ExampleState {
  const ExampleInitial();
}

class ExampleLoading extends ExampleState {
  const ExampleLoading();
}

class ExampleLoaded extends ExampleState {
  final List<ExampleData> data;
  final bool isRefreshing;

  const ExampleLoaded({
    required this.data,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [data, isRefreshing];

  ExampleLoaded copyWith({
    List<ExampleData>? data,
    bool? isRefreshing,
  }) {
    return ExampleLoaded(
      data: data ?? this.data,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class ExampleError extends ExampleState {
  final String message;

  const ExampleError({required this.message});

  @override
  List<Object?> get props => [message];
}
```

### 3. UI Integration

Connect API states to UI components:

```dart
class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example')),
      body: BlocBuilder<ExampleCubit, ExampleState>(
        builder: (context, state) {
          if (state is ExampleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExampleLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<ExampleCubit>().refreshData(),
              child: ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  final item = state.data[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.description),
                  );
                },
              ),
            );
          } else if (state is ExampleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ExampleCubit>().loadData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

## 📱 Loading States & User Feedback

### 1. Loading Indicators

Provide appropriate loading feedback:

```dart
// Full screen loading
if (state is ExampleLoading) {
  return const Center(child: CircularProgressIndicator());
}

// Button loading state
ElevatedButton(
  onPressed: state.isLoading ? null : _handleAction,
  child: state.isLoading
    ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
    : const Text('Submit'),
)

// Pull-to-refresh loading
RefreshIndicator(
  onRefresh: () => context.read<ExampleCubit>().refreshData(),
  child: ListView(...),
)
```

### 2. Success Messages

Show success feedback using SnackBars:

```dart
if (response.success) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Operation completed successfully'),
      backgroundColor: AppColors.success,
      duration: Duration(seconds: 2),
    ),
  );
}
```

### 3. Error Messages

Display errors with retry options:

```dart
if (state is ExampleError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(state.message),
      backgroundColor: AppColors.error,
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () => context.read<ExampleCubit>().loadData(),
      ),
    ),
  );
}
```

## 🏆 Best Practices

### 1. API Service Guidelines

**✅ Do:**
- Use static methods for API calls
- Include comprehensive error handling
- Add detailed logging for debugging
- Use proper timeout configurations
- Validate request data before sending
- Return consistent response models
- Handle all HTTP status codes appropriately

**❌ Don't:**
- Make API calls directly from UI widgets
- Ignore error handling
- Use hardcoded URLs in service methods
- Block the UI thread with synchronous calls
- Expose internal implementation details

### 2. Model Design

**✅ Do:**
- Use immutable models with `const` constructors
- Implement `toJson()` and `fromJson()` methods
- Add validation methods for request models
- Use nullable types appropriately
- Include factory constructors for error cases

**❌ Don't:**
- Use mutable models for API data
- Skip null safety considerations
- Mix UI logic with model classes
- Use dynamic types unnecessarily

### 3. State Management

**✅ Do:**
- Use BLoC/Cubit for complex state management
- Implement loading, success, and error states
- Add refresh functionality where appropriate
- Handle pagination properly
- Cache data when beneficial

**❌ Don't:**
- Mix business logic with UI code
- Forget to handle loading states
- Ignore error states in UI
- Make unnecessary API calls

### 4. Error Handling

**✅ Do:**
- Provide user-friendly error messages
- Implement retry mechanisms
- Log errors for debugging
- Handle network connectivity issues
- Show appropriate loading states

**❌ Don't:**
- Show technical error messages to users
- Ignore network errors
- Crash the app on API failures
- Block user interaction during errors

## 🧪 Testing

### 1. Unit Testing API Services

Create unit tests for API services:

```dart
// test/api_services/product_api_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:online_medicine/APIs/product_api_service.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('ProductApiService', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    test('should return products when API call is successful', () async {
      // Arrange
      const responseBody = '''
      {
        "status": "200",
        "message": "Products found",
        "data": {
          "products": [
            {
              "id": 1,
              "name": "Test Medicine",
              "price": 100.0
            }
          ],
          "pagination": {
            "current_page": 1,
            "total_pages": 1
          }
        }
      }
      ''';

      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(responseBody, 200));

      // Act
      final result = await ProductApiService.getAllProducts();

      // Assert
      expect(result.success, true);
      expect(result.data?.products.length, 1);
      expect(result.data?.products.first.name, 'Test Medicine');
    });

    test('should return error when API call fails', () async {
      // Arrange
      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"message": "Server error"}', 500));

      // Act
      final result = await ProductApiService.getAllProducts();

      // Assert
      expect(result.success, false);
      expect(result.message, contains('Server error'));
    });
  });
}
```

### 2. Integration Testing

Test the complete flow from API to UI:

```dart
// test/integration/product_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:online_medicine/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Product Flow Integration Tests', () {
    testWidgets('should load and display products', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to products page
      await tester.tap(find.text('Explore Products'));
      await tester.pumpAndSettle();

      // Wait for products to load
      await tester.pump(const Duration(seconds: 3));

      // Verify products are displayed
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsWidgets);
    });
  });
}
```

### 3. Mock API Responses

Create mock responses for testing:

```dart
// test/mocks/api_responses.dart
class MockApiResponses {
  static const String successfulProductResponse = '''
  {
    "status": "200",
    "message": "Products found",
    "data": {
      "products": [
        {
          "id": 1,
          "name": "Paracetamol",
          "brand": "Square",
          "price": 50.0,
          "imageUrl": "https://example.com/image.jpg"
        }
      ],
      "pagination": {
        "current_page": 1,
        "total_pages": 5,
        "total_items": 200
      }
    }
  }
  ''';

  static const String errorResponse = '''
  {
    "status": "400",
    "message": "Invalid request parameters"
  }
  ''';

  static const String networkErrorResponse = '''
  {
    "message": "No internet connection"
  }
  ''';
}
```

## 🔧 Troubleshooting

### 1. Common Issues

**Issue**: API calls timing out
```dart
// Solution: Increase timeout duration
static const Duration requestTimeout = Duration(seconds: 60);
```

**Issue**: JSON parsing errors
```dart
// Solution: Add null checks and validation
factory ExampleResponse.fromJson(Map<String, dynamic> json) {
  try {
    return ExampleResponse(
      success: json['status']?.toString() == '200',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? ExampleData.fromJson(json['data']) : null,
    );
  } catch (e) {
    return ExampleResponse.error(message: 'Invalid response format');
  }
}
```

**Issue**: Network connectivity problems
```dart
// Solution: Add connectivity checks
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}
```

### 2. Debugging Tips

**Enable detailed logging:**
```dart
// Add to main.dart for debug builds
void main() {
  if (kDebugMode) {
    // Enable HTTP logging
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp(MyApp());
}
```

**Log API requests and responses:**
```dart
print('🔄 API Request: ${ApiConfig.exampleUrl}');
print('📦 Request Body: ${json.encode(requestBody)}');
print('📡 Response Status: ${response.statusCode}');
print('📄 Response Body: ${response.body}');
```

**Use network inspection tools:**
- Charles Proxy
- Wireshark
- Flutter Inspector Network tab

### 3. Performance Optimization

**Implement caching:**
```dart
class ApiCache {
  static final Map<String, dynamic> _cache = {};
  static const Duration cacheExpiry = Duration(minutes: 5);

  static void set(String key, dynamic data) {
    _cache[key] = {
      'data': data,
      'timestamp': DateTime.now(),
    };
  }

  static dynamic get(String key) {
    final cached = _cache[key];
    if (cached != null) {
      final timestamp = cached['timestamp'] as DateTime;
      if (DateTime.now().difference(timestamp) < cacheExpiry) {
        return cached['data'];
      }
    }
    return null;
  }
}
```

**Implement pagination:**
```dart
// Load data in chunks
Future<void> loadMoreProducts() async {
  if (!hasMorePages || isLoadingMore) return;

  final nextPage = currentPage + 1;
  final response = await ProductApiService.getAllProducts(
    page: nextPage,
    limit: 20,
  );

  if (response.success) {
    // Append new products to existing list
    final updatedProducts = [...currentProducts, ...response.data!.products];
    emit(ProductsLoaded(products: updatedProducts, currentPage: nextPage));
  }
}
```

## 📚 Specific API Implementation Examples

### 1. Authentication Flow

**Complete Login Implementation:**

```dart
// 1. Create login request
final loginRequest = LoginRequest(
  emailOrPhone: emailController.text.trim(),
  password: passwordController.text,
  deviceId: ApiConfig.deviceId,
);

// 2. Call API through Cubit
context.read<AuthCubit>().login(loginRequest);

// 3. Handle response in UI
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (state is AuthLoginError) {
      _showErrorDialog(state.message);
    }
  },
  child: // UI widgets
)
```

### 2. Product Search with Filters

**Complete Product Search Implementation:**

```dart
// 1. Create search request with filters
final searchRequest = ProductSearchRequest(
  searchQuery: searchController.text,
  selectedBrands: selectedBrands.join(','),
  selectedCategories: selectedCategories.join(','),
  productType: selectedProductType, // 'trending', 'special_offer', etc.
  sortOption: selectedSortOption, // 'name_a_to_z', 'price_low_to_high', etc.
  priceRange: PriceRange(min: minPrice, max: maxPrice),
  pagination: Pagination(page: currentPage, limit: 40),
);

// 2. Call API through Cubit
context.read<ExploreProductsCubit>().searchProducts(searchRequest);

// 3. Handle response in UI
BlocBuilder<ExploreProductsCubit, ExploreProductsState>(
  builder: (context, state) {
    if (state is ExploreProductsLoaded) {
      return ListView.builder(
        itemCount: state.filteredProducts.length,
        itemBuilder: (context, index) {
          return MedicineCard(medicine: state.filteredProducts[index]);
        },
      );
    } else if (state is ExploreProductsError) {
      return ErrorWidget(message: state.message);
    }
    return const LoadingWidget();
  },
)
```

### 3. Cart Operations

**Add to Cart Implementation:**

```dart
// 1. Add item to cart
Future<void> addToCart(Medicine medicine, int quantity) async {
  final response = await CartApiService.addToCart(
    productId: medicine.id,
    customerId: currentUser.id,
    quantity: quantity,
  );

  if (response.success) {
    // Refresh cart data
    context.read<CartCubit>().loadCart();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medicine.name} added to cart'),
        backgroundColor: AppColors.success,
      ),
    );
  } else {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
```

### 4. Order Creation

**Complete Order Flow:**

```dart
// 1. Prepare order items from cart
final orderItems = cartItems.map((cartItem) => OrderItem(
  productId: cartItem.medicine.id,
  quantity: cartItem.quantity,
  unitPrice: cartItem.medicine.price,
)).toList();

// 2. Calculate totals
final subtotal = orderItems.fold<double>(
  0, (sum, item) => sum + (item.quantity * item.unitPrice),
);
final discount = calculateDiscount(subtotal);
final totalAmount = subtotal - discount;

// 3. Create order request
final orderRequest = OrderRequest(
  customerId: currentUser.id,
  items: orderItems,
  subtotal: subtotal,
  discount: discount,
  totalAmount: totalAmount,
);

// 4. Submit order
final response = await OrderApiService.createOrder(orderRequest);

if (response.success && response.data != null) {
  // Clear cart after successful order
  context.read<CartCubit>().clearCart();

  // Navigate to order confirmation
  Navigator.pushNamed(context, '/order-confirmation',
    arguments: response.data!.orderId);
} else {
  // Show error message
  _showErrorDialog(response.message);
}
```

## 🚀 Adding New APIs

### Step-by-Step Guide

**1. Add endpoint to ApiConfig:**
```dart
// In lib/APIs/api_config.dart
static const String newFeatureEndpoint = 'new-feature';
static String get newFeatureUrl => '$baseUrl$newFeatureEndpoint';
```

**2. Create request/response models:**
```dart
// In lib/models/new_feature_models.dart
class NewFeatureRequest {
  final String parameter1;
  final int parameter2;

  const NewFeatureRequest({
    required this.parameter1,
    required this.parameter2,
  });

  Map<String, dynamic> toJson() => {
    'parameter1': parameter1,
    'parameter2': parameter2,
  };
}

class NewFeatureResponse {
  final bool success;
  final String message;
  final NewFeatureData? data;

  const NewFeatureResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory NewFeatureResponse.fromJson(Map<String, dynamic> json) =>
    NewFeatureResponse(
      success: json['status'] == '200',
      message: json['message'] ?? '',
      data: json['data'] != null ? NewFeatureData.fromJson(json['data']) : null,
    );

  factory NewFeatureResponse.error({required String message}) =>
    NewFeatureResponse(success: false, message: message);
}
```

**3. Create API service:**
```dart
// In lib/APIs/new_feature_api_service.dart
class NewFeatureApiService {
  static Future<NewFeatureResponse> performAction(NewFeatureRequest request) async {
    try {
      print('🔄 Calling new feature API: ${ApiConfig.newFeatureUrl}');

      final response = await http.post(
        Uri.parse(ApiConfig.newFeatureUrl),
        headers: ApiConfig.headers,
        body: json.encode(request.toJson()),
      ).timeout(ApiConfig.requestTimeout);

      print('📡 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return NewFeatureResponse.fromJson(responseData);
      } else {
        return NewFeatureResponse.error(
          message: responseData['message'] ?? 'Request failed',
        );
      }
    } on SocketException {
      return NewFeatureResponse.error(
        message: 'No internet connection. Please check your network.',
      );
    } on http.ClientException {
      return NewFeatureResponse.error(
        message: 'Network error. Please try again.',
      );
    } on FormatException {
      return NewFeatureResponse.error(
        message: 'Invalid response from server.',
      );
    } catch (e) {
      return NewFeatureResponse.error(
        message: 'Request failed. Please try again.',
      );
    }
  }
}
```

**4. Create state management:**
```dart
// In lib/bloc/cubits/new_feature_cubit.dart
class NewFeatureCubit extends Cubit<NewFeatureState> {
  NewFeatureCubit() : super(const NewFeatureInitial());

  Future<void> performAction(NewFeatureRequest request) async {
    emit(const NewFeatureLoading());

    try {
      final response = await NewFeatureApiService.performAction(request);

      if (response.success && response.data != null) {
        emit(NewFeatureSuccess(data: response.data!));
      } else {
        emit(NewFeatureError(message: response.message));
      }
    } catch (e) {
      emit(NewFeatureError(message: 'Action failed: ${e.toString()}'));
    }
  }
}
```

**5. Integrate with UI:**
```dart
// In your screen widget
BlocProvider(
  create: (context) => NewFeatureCubit(),
  child: BlocListener<NewFeatureCubit, NewFeatureState>(
    listener: (context, state) {
      if (state is NewFeatureSuccess) {
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action completed successfully')),
        );
      } else if (state is NewFeatureError) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    },
    child: BlocBuilder<NewFeatureCubit, NewFeatureState>(
      builder: (context, state) {
        if (state is NewFeatureLoading) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: () {
            final request = NewFeatureRequest(
              parameter1: 'value1',
              parameter2: 123,
            );
            context.read<NewFeatureCubit>().performAction(request);
          },
          child: const Text('Perform Action'),
        );
      },
    ),
  ),
)
```

## 📝 Summary

This API Integration Guide provides a comprehensive framework for maintaining and extending the Online Medicine app's API integrations. Key takeaways:

1. **Centralized Configuration**: All API endpoints are managed in `ApiConfig`
2. **Consistent Patterns**: All API services follow the same structure and error handling
3. **Proper State Management**: BLoC/Cubit integration for reactive UI updates
4. **Comprehensive Error Handling**: Network, parsing, and business logic errors are handled
5. **User-Friendly Feedback**: Loading states, success messages, and error dialogs
6. **Testable Architecture**: Services are designed for easy unit and integration testing
7. **Scalable Design**: Easy to add new APIs following the established patterns

For any questions or issues with API integration, refer to this guide and follow the established patterns for consistency and maintainability.
```
