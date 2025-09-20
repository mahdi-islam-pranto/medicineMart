import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../../models/models.dart';
import '../states/auth_state.dart';
import '../../APIs/auth_api_service.dart';
import '../../APIs/app_settings_api_service.dart';
import '../../services/app_settings_storage_service.dart';

/// AuthCubit manages authentication state for pharmacy owners
///
/// This cubit handles:
/// - User registration with admin approval workflow
/// - User login with status validation
/// - Persistent authentication state
/// - Logout functionality
/// - Mock backend simulation (to be replaced with real API)
class AuthCubit extends Cubit<AuthState> {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  AuthCubit() : super(const AuthInitial());

  /// Initialize authentication state on app start
  Future<void> initialize() async {
    emit(const AuthLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      final token = prefs.getString(_tokenKey);

      if (userJson != null) {
        final user = User.fromJson(json.decode(userJson));

        // Check user status and emit appropriate state
        switch (user.status) {
          case UserStatus.approved:
            emit(AuthAuthenticated(user: user, token: token));
            break;
          case UserStatus.pending:
            emit(AuthPendingApproval(user: user));
            break;
          case UserStatus.rejected:
            emit(AuthRejected(user: user));
            break;
          case UserStatus.suspended:
            emit(AuthSuspended(user: user));
            break;
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Register a new pharmacy owner
  Future<void> register(RegistrationRequest request) async {
    emit(const AuthRegistrationLoading());

    try {
      // Validate the request
      final validationErrors = request.validate();
      if (validationErrors.isNotEmpty) {
        emit(AuthRegistrationError(
          message: 'Please fix the following errors:',
          validationErrors: validationErrors,
        ));
        return;
      }

      // Call the real API
      final response = await AuthApiService.register(request);

      if (response.success && response.user != null) {
        // Registration successful
        final user = response.user!;

        // Save user to local storage for persistence
        await _saveCurrentUser(user, response.token);

        emit(AuthRegistrationSuccess(
          user: user,
          message: response.message ??
              'Registration successful! Please login to continue.',
        ));
      } else {
        // Registration failed
        emit(AuthRegistrationError(
          message: response.message ?? 'Registration failed. Please try again.',
        ));
      }
    } catch (e) {
      emit(const AuthRegistrationError(
        message: 'Registration failed. Please try again.',
      ));
    }
  }

  /// Login with email/phone and password
  Future<void> login(LoginRequest request) async {
    emit(const AuthLoginLoading());

    try {
      // Validate the request
      final validationErrors = request.validate();
      if (validationErrors.isNotEmpty) {
        emit(AuthLoginError(
          message:
              'Please fix the following errors: ${validationErrors.join(', ')}',
        ));
        return;
      }

      // Call the real API
      final response = await AuthApiService.login(request);

      if (response.success && response.user != null) {
        // Login successful
        final user = response.user!;
        final token = response.token;

        // Save user to local storage for persistence
        await _saveCurrentUser(user, token);

        // Fetch and save app settings after successful login
        await _fetchAndSaveAppSettings();

        // Check user status and emit appropriate state
        switch (user.status) {
          case UserStatus.approved:
            emit(AuthAuthenticated(user: user, token: token));
            break;
          case UserStatus.pending:
            emit(const AuthLoginError(
              message:
                  'Your account is pending approval. Please wait for admin confirmation.',
            ));
            break;
          case UserStatus.rejected:
            emit(const AuthLoginError(
              message:
                  'Your account has been rejected. Please contact support.',
            ));
            break;
          case UserStatus.suspended:
            emit(const AuthLoginError(
              message:
                  'Your account has been suspended. Please contact support.',
            ));
            break;
        }
      } else {
        // Login failed
        emit(AuthLoginError(
          message: response.message ?? 'Invalid credentials. Please try again.',
        ));
      }
    } catch (e) {
      emit(const AuthLoginError(
        message: 'Login failed. Please try again.',
      ));
    }
  }

  /// Logout current user
  Future<void> logout() async {
    emit(const AuthLogoutLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);

      // Clear app settings on logout
      await AppSettingsStorageService.clearAppSettings();

      emit(const AuthUnauthenticated());
    } catch (e) {
      // Even if clearing fails, emit unauthenticated state
      emit(const AuthUnauthenticated());
    }
  }

  /// Check approval status (for pending users)
  Future<void> checkApprovalStatus() async {
    final currentUser = state.user;
    if (currentUser == null) return;

    // In a real app, this would make an API call
    // For now, we'll simulate random approval for demo purposes
    if (currentUser.status == UserStatus.pending) {
      // Mock: randomly approve some users for demo
      final random = Random();
      if (random.nextBool()) {
        final approvedUser = currentUser.copyWith(
          status: UserStatus.approved,
          approvedAt: DateTime.now(),
        );

        await _updateUserInStorage(approvedUser);
        final token = _generateToken();
        await _saveCurrentUser(approvedUser, token);
        emit(AuthAuthenticated(user: approvedUser, token: token));
      }
    }
  }

  // Helper methods for token generation and user storage

  String _generateToken() {
    return 'token_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  Future<void> _updateUserInStorage(User user) async {
    // Update user in local storage when status changes
    await _saveCurrentUser(user);
  }

  Future<void> _saveCurrentUser(User user, [String? token]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    if (token != null) {
      await prefs.setString(_tokenKey, token);
    }
    // print user data log
    print('User data saved: ${user.toJson()}');
  }

  /// Fetch app settings from API and save to SharedPreferences
  Future<void> _fetchAndSaveAppSettings() async {
    try {
      print('🔄 Fetching app settings after login...');

      // Call the app settings API
      final response = await AppSettingsApiService.getAppSettings();

      if (response.success && response.data != null) {
        // Save settings to SharedPreferences
        final saved =
            await AppSettingsStorageService.saveAppSettings(response.data!);

        if (saved) {
          print('✅ App settings fetched and saved successfully');
        } else {
          print(
              '⚠️ App settings fetched but failed to save to SharedPreferences');
        }
      } else {
        print('⚠️ Failed to fetch app settings: ${response.error}');
        // Don't throw error, just log it - app can work with fallback values
      }
    } catch (e) {
      print('⚠️ Error fetching app settings: $e');
      // Don't throw error, just log it - app can work with fallback values
    }
  }
}
