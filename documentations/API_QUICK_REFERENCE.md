# 🚀 API Quick Reference - Online Medicine App

## 📋 All Available APIs

### Base URL
```
http://admin.modumadicenmart.com/api/
```

## 🔐 Authentication APIs

### 1. User Registration
- **Endpoint**: `POST /customers/create`
- **Service**: `AuthApiService.register()`
- **Request**: Multipart form data with NID image
- **Response**: User data with approval status

### 2. User Login
- **Endpoint**: `POST /app/login`
- **Service**: `AuthApiService.login()`
- **Request**: Email/phone, password, device_id
- **Response**: User data with token (if approved)

## 🛍️ Product APIs

### 1. Product Search
- **Endpoint**: `POST /products/search`
- **Service**: `ProductApiService.searchProducts()`
- **Features**: Search, filter, sort, pagination
- **Request Body**:
```json
{
  "searchQuery": "medicine name",
  "selectedBrands": "brand1,brand2",
  "selectedCategories": "cat1,cat2",
  "productType": "trending|special_offer|top_selling",
  "sortOption": "name_a_to_z|price_low_to_high|price_high_to_low",
  "priceRange": {"min": 0, "max": 1000},
  "pagination": {"page": 1, "limit": 40}
}
```

### 2. Get All Brands
- **Endpoint**: `GET /brand`
- **Service**: `BrandApiService.getAllBrands()`
- **Response**: List of all available brands/companies

### 3. Get All Categories
- **Endpoint**: `GET /category`
- **Service**: `CategoryApiService.getAllCategories()`
- **Response**: List of all product categories

## 🛒 Cart APIs

### 1. Add to Cart
- **Endpoint**: `POST /product/add/to/cart`
- **Service**: `CartApiService.addToCart()`
- **Parameters**: product_id, customer_id, quantity
- **Note**: Quantity 0 removes item from cart

### 2. Get Cart Items
- **Endpoint**: `POST /product/add/to/cart/list`
- **Service**: `CartApiService.getCartItems()`
- **Parameters**: customer_id
- **Response**: Cart items with totals and summary

## 📦 Order APIs

### 1. Create Order
- **Endpoint**: `POST /invoice/create`
- **Service**: `OrderApiService.createOrder()`
- **Request Body**:
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

### 2. Get Order List
- **Endpoint**: `POST /order/list`
- **Service**: `OrderListApiService.getOrders()`
- **Features**: Status filtering, pagination
- **Status Values**: 'all', '1' (pending), '2' (delivered), '3' (cancelled)

## 💬 Feedback & Support APIs

### 1. Submit Feedback
- **Endpoint**: `POST /feedback`
- **Service**: `FeedbackApiService.submitFeedback()`
- **Request Body**:
```json
{
  "customer_id": 1,
  "overall_rating": 5,
  "category": "service",
  "feedback": "Great service!",
  "suggestions": "Keep it up"
}
```

### 2. Get FAQs
- **Endpoint**: `GET /faq`
- **Service**: `FaqApiService.getAllFaqs()`
- **Response**: List of frequently asked questions

## ⚙️ App Configuration APIs

### 1. Get App Settings
- **Endpoint**: `GET /settings/data`
- **Service**: `AppSettingsApiService.getAppSettings()`
- **Response**: App name, contact info, version, domain URL
- **Usage**: Called after login, cached in SharedPreferences

## 🔧 Quick Implementation Patterns

### 1. Basic API Call Pattern
```dart
// 1. Create request
final request = ExampleRequest(param1: value1, param2: value2);

// 2. Call API service
final response = await ExampleApiService.callApi(request);

// 3. Handle response
if (response.success && response.data != null) {
  // Success - update UI state
  emit(ExampleSuccess(data: response.data!));
} else {
  // Error - show error message
  emit(ExampleError(message: response.message));
}
```

### 2. BLoC Integration Pattern
```dart
class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit() : super(const ExampleInitial());
  
  Future<void> performAction() async {
    emit(const ExampleLoading());
    
    try {
      final response = await ExampleApiService.performAction();
      
      if (response.success) {
        emit(ExampleSuccess(data: response.data));
      } else {
        emit(ExampleError(message: response.message));
      }
    } catch (e) {
      emit(ExampleError(message: 'Action failed: ${e.toString()}'));
    }
  }
}
```

### 3. UI Integration Pattern
```dart
BlocBuilder<ExampleCubit, ExampleState>(
  builder: (context, state) {
    if (state is ExampleLoading) {
      return const CircularProgressIndicator();
    } else if (state is ExampleSuccess) {
      return SuccessWidget(data: state.data);
    } else if (state is ExampleError) {
      return ErrorWidget(message: state.message);
    }
    return const InitialWidget();
  },
)
```

## 🚨 Common Error Codes

- **200**: Success
- **400**: Bad Request (validation errors)
- **401**: Unauthorized (invalid credentials)
- **403**: Forbidden (pending approval)
- **404**: Not Found
- **500**: Internal Server Error

## 📱 State Management Quick Reference

### Available Cubits
- `AuthCubit`: Authentication state
- `ExploreProductsCubit`: Product listing and filtering
- `MedicineCubit`: Homepage medicine data
- `CartCubit`: Shopping cart state
- `OrderCubit`: Order management
- `CategoriesCubit`: Category data
- `NavigationCubit`: Bottom navigation
- `FavoritesCubit`: Favorite products (local storage)

### Common State Types
- `Initial`: Starting state
- `Loading`: API call in progress
- `Loaded/Success`: Data loaded successfully
- `Error`: API call failed

## 🔍 Debugging Tips

### Enable API Logging
```dart
// Add detailed logging in API services
print('🔄 API Call: ${ApiConfig.exampleUrl}');
print('📦 Request: ${json.encode(requestBody)}');
print('📡 Response: ${response.statusCode} - ${response.body}');
```

### Common Issues
1. **Timeout**: Increase `ApiConfig.requestTimeout`
2. **JSON Parsing**: Add null checks in `fromJson()` methods
3. **Network**: Check internet connectivity
4. **CORS**: Ensure proper headers are set

## 📚 File Locations

### API Services
- `lib/APIs/api_config.dart` - Central configuration
- `lib/APIs/*_api_service.dart` - Individual API services

### Models
- `lib/models/*_models.dart` - Request/response models
- `lib/models/models.dart` - Export file

### State Management
- `lib/bloc/cubits/*_cubit.dart` - Cubit classes
- `lib/bloc/states/*_state.dart` - State classes

### UI Integration
- `lib/screens/` - Screen widgets using BLoC
- `lib/widgets/` - Reusable UI components

## 🎯 Next Steps for New Developers

1. **Read the full API Integration Guide** (`API_INTEGRATION_GUIDE.md`)
2. **Study existing API services** to understand patterns
3. **Run the app** and observe API calls in debug console
4. **Test API endpoints** using tools like Postman
5. **Follow the established patterns** when adding new APIs

For detailed implementation examples and best practices, refer to the complete API Integration Guide.
