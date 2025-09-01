# 🔐 Complete Authentication System Guide

## Overview
This guide explains the complete authentication system for the Online Medicine app, built with Flutter and BLoC state management. The system handles user registration, login, and persistent authentication with real API integration.

## 📁 File Structure

```
lib/
├── APIs/
│   ├── api_config.dart          # API endpoints and configuration
│   └── auth_api_service.dart    # HTTP requests for auth operations
├── bloc/
│   ├── cubits/
│   │   └── auth_cubit.dart      # Authentication business logic
│   └── states/
│       └── auth_state.dart      # All possible authentication states
├── models/
│   ├── auth_models.dart         # Request/Response models
│   └── user.dart               # User data model
├── screens/
│   └── auth/
│       ├── login_screen.dart    # Login UI
│       └── register_screen.dart # Registration UI
└── main.dart                   # App entry point with BLoC providers
```

## 🔄 Authentication Flow

### 1. App Startup Flow
```
App Launch → SplashScreen → AuthCubit.initialize() → Check stored user → Navigate
```

**File: `lib/screens/splash_screen.dart`**
- Calls `context.read<AuthCubit>().initialize()` to check if user is already logged in
- Listens to AuthState changes and navigates accordingly:
  - `AuthAuthenticated` → Homepage
  - `AuthUnauthenticated` → Login Screen

### 2. Registration Flow
```
Register Screen → Form Validation → API Call → Success Dialog → Login Screen
```

**User Journey:**
1. User fills registration form
2. Clicks "Register" button
3. Form validation occurs
4. API call to registration endpoint
5. Success dialog appears
6. User clicks "Continue to Login"
7. Navigates to Login Screen

### 3. Login Flow
```
Login Screen → Form Validation → API Call → Check Approval Status → Navigate
```

**User Journey:**
1. User enters email/phone and password
2. Clicks "Login" button
3. Form validation occurs
4. API call to login endpoint
5. Check `login_approval` status:
   - `"1"` (Approved) → Homepage with user data
   - `"0"` (Pending) → Error dialog
   - `"-1"` (Rejected) → Error dialog

## 🏗️ Architecture Components

### 1. API Configuration (`lib/APIs/api_config.dart`)

```dart
class ApiConfig {
  static const String baseUrl = 'http://admin.modumadicenmart.com/api/';
  static const String registerEndpoint = 'customers/create';
  static const String loginEndpoint = 'app/login';
  
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get loginUrl => '$baseUrl$loginEndpoint';
  
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
```

**Purpose:** Centralized configuration for all API endpoints and settings.
**Why it's useful:** Easy to change base URL or endpoints without touching multiple files.

### 2. API Service (`lib/APIs/auth_api_service.dart`)

**Key Methods:**

#### `register(RegistrationRequest request)`
- Makes HTTP POST to registration endpoint
- Handles network errors and timeouts
- Returns `AuthResponse` with success/failure status

#### `login(LoginRequest request)`
- Makes HTTP POST to login endpoint
- Parses the specific API response structure:
```json
{
  "data": {
    "token": "...",
    "customer": { ... }
  }
}
```
- Maps `login_approval` field to user status

**Error Handling:**
- `SocketException` → "No internet connection"
- `http.ClientException` → "Network error"
- `FormatException` → "Invalid response from server"

### 3. State Management (`lib/bloc/cubits/auth_cubit.dart`)

**Key States:**
- `AuthInitial` → App just started
- `AuthLoading` → Checking stored authentication
- `AuthLoginLoading` → Login API call in progress
- `AuthRegistrationLoading` → Registration API call in progress
- `AuthAuthenticated` → User is logged in and approved
- `AuthLoginError` → Login failed with error message
- `AuthRegistrationError` → Registration failed
- `AuthRegistrationSuccess` → Registration successful
- `AuthUnauthenticated` → User not logged in

**Key Methods:**

#### `initialize()`
```dart
Future<void> initialize() async {
  emit(const AuthLoading());
  
  final prefs = await SharedPreferences.getInstance();
  final userJson = prefs.getString(_userKey);
  final token = prefs.getString(_tokenKey);
  
  if (userJson != null) {
    final user = User.fromJson(json.decode(userJson));
    emit(AuthAuthenticated(user: user, token: token));
  } else {
    emit(const AuthUnauthenticated());
  }
}
```
**Purpose:** Check if user is already logged in when app starts.

#### `register(RegistrationRequest request)`
```dart
Future<void> register(RegistrationRequest request) async {
  emit(const AuthRegistrationLoading());
  
  // Validate form
  final validationErrors = request.validate();
  if (validationErrors.isNotEmpty) {
    emit(AuthRegistrationError(message: '...', validationErrors: validationErrors));
    return;
  }
  
  // Call API
  final response = await AuthApiService.register(request);
  
  if (response.success) {
    emit(AuthRegistrationSuccess(user: response.user!, message: response.message!));
  } else {
    emit(AuthRegistrationError(message: response.message!));
  }
}
```
**Purpose:** Handle registration process with validation and API call.

#### `login(LoginRequest request)`
```dart
Future<void> login(LoginRequest request) async {
  emit(const AuthLoginLoading());
  
  final response = await AuthApiService.login(request);
  
  if (response.success && response.user != null) {
    final user = response.user!;
    await _saveCurrentUser(user, response.token);
    
    // Check approval status
    switch (user.status) {
      case UserStatus.approved:
        emit(AuthAuthenticated(user: user, token: response.token));
        break;
      case UserStatus.pending:
        emit(const AuthLoginError(message: 'Account pending approval...'));
        break;
      // ... other cases
    }
  }
}
```
**Purpose:** Handle login with approval status checking.

### 4. Data Models

#### User Model (`lib/models/user.dart`)
```dart
class User {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String pharmacyName;
  final String district;
  final String policeStation;
  final String pharmacyFullAddress;
  final String email;
  final String? nidImagePath;
  final UserStatus status;
  final DateTime createdAt;
  final DateTime? approvedAt;
}

enum UserStatus { approved, pending, rejected, suspended }
```

#### Request Models (`lib/models/auth_models.dart`)
```dart
class LoginRequest {
  final String emailOrPhone;
  final String password;
  final String? deviceId;
  
  Map<String, dynamic> toJson() => {
    'emailOrPhone': emailOrPhone,
    'password': password,
    'device_id': deviceId ?? 'flutter_app_${DateTime.now().millisecondsSinceEpoch}',
  };
}
```

## 🎨 UI Components

### 1. Login Screen (`lib/screens/auth/login_screen.dart`)

**Key Features:**
- Form validation before API call
- Loading state during login
- Error dialogs for failed attempts
- Success message and navigation

**BLoC Integration:**
```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthLoginError) {
      _showErrorDialog(state.message);
    } else if (state is AuthAuthenticated) {
      _showSuccessMessage('Login successful! Welcome back.');
      _navigateToMainApp();
    }
  },
  child: // UI widgets
)
```

**Form Handling:**
```dart
void _handleLogin() {
  if (!_formKey.currentState!.validate()) return;
  
  final request = LoginRequest(
    emailOrPhone: _emailOrPhoneController.text.trim(),
    password: _passwordController.text,
  );
  
  context.read<AuthCubit>().login(request);
}
```

### 2. Register Screen (`lib/screens/auth/register_screen.dart`)

**Key Features:**
- Comprehensive form with all required fields
- District and police station dropdowns
- NID image upload functionality
- Back button navigation to login
- Success dialog with login navigation

**Navigation Handling:**
```dart
// Back button in AppBar
leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  },
)

// Success dialog navigation
void _showSuccessDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Registration Successful'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: const Text('Continue to Login'),
        ),
      ],
    ),
  );
}
```

## 💾 Data Persistence

**Local Storage Keys:**
- `current_user` → Stores user data as JSON
- `auth_token` → Stores authentication token

**Save User Data:**
```dart
Future<void> _saveCurrentUser(User user, [String? token]) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userKey, json.encode(user.toJson()));
  if (token != null) {
    await prefs.setString(_tokenKey, token);
  }
}
```

**Load User Data:**
```dart
final prefs = await SharedPreferences.getInstance();
final userJson = prefs.getString(_userKey);
if (userJson != null) {
  final user = User.fromJson(json.decode(userJson));
  // User is logged in
}
```

## 🔄 State Flow Diagram

```
App Start
    ↓
AuthInitial
    ↓
initialize()
    ↓
AuthLoading
    ↓
Check SharedPreferences
    ↓
┌─────────────────┬─────────────────┐
│   User Found    │   No User       │
│       ↓         │       ↓         │
│ AuthAuthenticated│ AuthUnauthenticated│
│       ↓         │       ↓         │
│   Homepage      │  Login Screen   │
└─────────────────┴─────────────────┘
```

## 🚨 Error Handling

### Network Errors
- No internet connection
- Server timeout
- Invalid response format

### Validation Errors
- Empty required fields
- Invalid email format
- Invalid phone number format
- Password mismatch

### API Errors
- Invalid credentials
- Account not approved
- Account rejected/suspended

## 🧪 Testing the System

### Registration Test:
1. Fill all required fields
2. Submit form
3. Check API call in network logs
4. Verify success dialog appears
5. Confirm navigation to login screen

### Login Test:
1. Enter valid credentials
2. Submit form
3. Check API response structure
4. Verify user data saved in SharedPreferences
5. Confirm navigation to homepage

### Persistence Test:
1. Login successfully
2. Close and reopen app
3. Verify user stays logged in
4. Check splash screen navigation

## 🔧 Common Issues & Solutions

### Issue: "Invalid response from server"
**Solution:** Check API response structure matches expected format in `auth_api_service.dart`

### Issue: User not staying logged in
**Solution:** Verify `_saveCurrentUser()` is called after successful login

### Issue: Navigation not working
**Solution:** Check BlocListener is properly set up in UI screens

### Issue: Form validation not working
**Solution:** Ensure `_formKey.currentState!.validate()` is called before API call

## 📝 Adding New Features

### Adding Password Reset:
1. Add new state in `auth_state.dart`
2. Add method in `auth_cubit.dart`
3. Add API endpoint in `api_config.dart`
4. Add API call in `auth_api_service.dart`
5. Update UI to handle new state

### Adding Social Login:
1. Add new request model in `auth_models.dart`
2. Add social login method in `auth_cubit.dart`
3. Add API endpoint and service method
4. Update UI with social login buttons

## 🔍 Code Examples for Common Tasks

### How to Check if User is Logged In
```dart
// In any widget
final authState = context.read<AuthCubit>().state;
if (authState is AuthAuthenticated) {
  // User is logged in
  final user = authState.user;
  final token = authState.token;
}
```

### How to Logout User
```dart
// Call logout method
context.read<AuthCubit>().logout();

// This will:
// 1. Clear SharedPreferences
// 2. Emit AuthUnauthenticated state
// 3. Navigate to login screen
```

### How to Get Current User Data
```dart
// Method 1: From BLoC state
final authState = context.read<AuthCubit>().state;
if (authState is AuthAuthenticated) {
  final userName = authState.user.fullName;
  final pharmacyName = authState.user.pharmacyName;
}

// Method 2: Using extension method
final user = context.read<AuthCubit>().state.user;
if (user != null) {
  print('User: ${user.fullName}');
}
```

### How to Handle Loading States in UI
```dart
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    if (state is AuthLoginLoading) {
      return const CircularProgressIndicator();
    }

    return ElevatedButton(
      onPressed: state.isLoading ? null : _handleLogin,
      child: state is AuthLoginLoading
        ? const CircularProgressIndicator()
        : const Text('Login'),
    );
  },
)
```

## 📊 API Response Examples

### Successful Login Response
```json
{
    "status": 200,
    "message": "Logged in successfully",
    "data": {
        "token": "2|rMHKQDNELhcAytyCPen47ASbhqSjXF1Wxeus7qTN",
        "token_type": "Bearer",
        "customer": {
            "id": 2,
            "fullName": "Pranto",
            "phoneNumber": "01610681903",
            "pharmacyName": "PP pharmacy",
            "district": "Dhaka",
            "policeStation": "Uttara",
            "pharmacyFullAddress": "Uttara, Uttarkhan",
            "email": "pranto@gmail.com",
            "nidImagePath": "1234",
            "login_approval": "1",  // 1=approved, 0=pending, -1=rejected
            "device_id": "string",
            "created_at": "2025-08-28T11:45:27.000000Z",
            "updated_at": "2025-08-28T11:51:08.000000Z"
        }
    }
}
```

### Failed Login Response
```json
{
    "status": 401,
    "message": "Invalid credentials",
    "data": null
}
```

### Registration Response
```json
{
    "status": 201,
    "message": "Registration successful! Please wait for admin approval.",
    "data": {
        "user": {
            "id": 3,
            "fullName": "New User",
            "email": "newuser@example.com",
            // ... other user fields
        }
    }
}
```

## 🎯 Best Practices

### 1. Always Handle Loading States
```dart
// ❌ Bad: No loading indication
ElevatedButton(
  onPressed: _handleLogin,
  child: const Text('Login'),
)

// ✅ Good: Show loading state
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    return ElevatedButton(
      onPressed: state is AuthLoginLoading ? null : _handleLogin,
      child: state is AuthLoginLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text('Login'),
    );
  },
)
```

### 2. Validate Forms Before API Calls
```dart
void _handleLogin() {
  // ✅ Always validate first
  if (!_formKey.currentState!.validate()) {
    return;
  }

  // Then make API call
  final request = LoginRequest(
    emailOrPhone: _emailOrPhoneController.text.trim(),
    password: _passwordController.text,
  );

  context.read<AuthCubit>().login(request);
}
```

### 3. Use BlocListener for Navigation
```dart
// ✅ Good: Use BlocListener for side effects like navigation
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  },
  child: // Your UI widgets
)
```

### 4. Handle All Error Cases
```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthLoginError) {
      _showErrorDialog(state.message);
    } else if (state is AuthRegistrationError) {
      _showErrorDialog(state.message, state.validationErrors);
    }
    // Handle other error states...
  },
)
```

## 🚀 Performance Tips

### 1. Use const Constructors
```dart
// ✅ Good: Use const for better performance
const Text('Login')
const SizedBox(height: 20)
const CircularProgressIndicator()
```

### 2. Dispose Controllers
```dart
class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // ✅ Always dispose controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

### 3. Use BlocBuilder vs BlocListener Appropriately
```dart
// ✅ BlocBuilder for UI changes
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    return Text(state is AuthAuthenticated ? 'Welcome!' : 'Please login');
  },
)

// ✅ BlocListener for side effects (navigation, dialogs, etc.)
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthLoginError) {
      showDialog(/* error dialog */);
    }
  },
)
```

## 🔧 Debugging Tips

### 1. Add Debug Prints
```dart
// In AuthCubit methods
print('🔐 Login attempt for: ${request.emailOrPhone}');
print('📱 API Response: ${response.statusCode}');
print('✅ User authenticated: ${user.fullName}');
```

### 2. Check SharedPreferences
```dart
// Debug stored data
final prefs = await SharedPreferences.getInstance();
print('Stored user: ${prefs.getString('current_user')}');
print('Stored token: ${prefs.getString('auth_token')}');
```

### 3. Monitor State Changes
```dart
// Add this to AuthCubit
@override
void onChange(Change<AuthState> change) {
  super.onChange(change);
  print('🔄 Auth State: ${change.currentState} → ${change.nextState}');
}
```

## 📚 Learning Resources

### Understanding BLoC Pattern
- [Official BLoC Documentation](https://bloclibrary.dev/)
- [BLoC State Management Tutorial](https://www.youtube.com/watch?v=THCkkQ-V1-8)

### Flutter HTTP Requests
- [HTTP Package Documentation](https://pub.dev/packages/http)
- [Handling Network Requests](https://flutter.dev/docs/cookbook/networking/fetch-data)

### SharedPreferences
- [Storing Key-Value Data](https://flutter.dev/docs/cookbook/persistence/key-value)

This comprehensive guide provides everything a junior developer needs to understand and work with the authentication system. Each section builds upon the previous one, from basic concepts to advanced implementation details.
