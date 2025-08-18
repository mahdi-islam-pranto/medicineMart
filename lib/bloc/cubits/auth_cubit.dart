import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../../models/models.dart';
import '../states/auth_state.dart';

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
  static const String _usersKey = 'registered_users'; // Mock storage

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

      // Check if user already exists (mock check)
      final existingUser =
          await _findUserByEmailOrPhone(request.email, request.phoneNumber);
      if (existingUser != null) {
        emit(const AuthRegistrationError(
          message: 'An account with this email or phone number already exists.',
        ));
        return;
      }

      // For demo purposes, create user with approved status
      final user = User(
        id: _generateUserId(),
        fullName: request.fullName,
        phoneNumber: request.phoneNumber,
        pharmacyName: request.pharmacyName,
        district: request.district,
        policeStation: request.policeStation,
        pharmacyFullAddress: request.pharmacyFullAddress,
        nidImagePath: request.nidImagePath,
        email: request.email,
        status: UserStatus.approved, // Auto-approve for demo
        createdAt: DateTime.now(),
        approvedAt: DateTime.now(), // Set approval time
      );

      // Save user to mock storage
      await _saveUserToStorage(user, request.password);

      // Generate token and save current user for session
      final token = _generateToken();
      await _saveCurrentUser(user, token);

      emit(AuthRegistrationSuccess(
        user: user,
        message: 'Registration successful! Welcome to the app.',
      ));

      // Transition to authenticated state (skip approval for demo)
      await Future.delayed(const Duration(milliseconds: 500));
      emit(AuthAuthenticated(user: user, token: token));
    } catch (e) {
      emit(AuthRegistrationError(
        message: 'Registration failed. Please try again.',
      ));
    }
  }

  /// Login with email/phone and password
  Future<void> login(LoginRequest request) async {
    emit(const AuthLoginLoading());

    try {
      // For demo purposes, skip validation and go directly to homepage
      // Simulate a short loading time
      await Future.delayed(const Duration(milliseconds: 500));

      final mockUser = User(
        id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: 'Demo Pharmacy Owner',
        phoneNumber: request.emailOrPhone.isNotEmpty
            ? request.emailOrPhone
            : '01700000000',
        pharmacyName: 'Demo Pharmacy',
        district: 'Dhaka',
        policeStation: 'Dhanmondi',
        pharmacyFullAddress: 'Demo Address, Dhaka',
        email: request.emailOrPhone.contains('@')
            ? request.emailOrPhone
            : 'demo@pharmacy.com',
        status: UserStatus.approved, // Always approved for demo
        createdAt: DateTime.now(),
        approvedAt: DateTime.now(),
      );

      final token = _generateToken();
      await _saveCurrentUser(mockUser, token);
      emit(AuthAuthenticated(user: mockUser, token: token));
    } catch (e) {
      // Even if there's an error, still login for demo purposes
      final mockUser = User(
        id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: 'Demo Pharmacy Owner',
        phoneNumber: '01700000000',
        pharmacyName: 'Demo Pharmacy',
        district: 'Dhaka',
        policeStation: 'Dhanmondi',
        pharmacyFullAddress: 'Demo Address, Dhaka',
        email: 'demo@pharmacy.com',
        status: UserStatus.approved,
        createdAt: DateTime.now(),
        approvedAt: DateTime.now(),
      );

      final token = _generateToken();
      await _saveCurrentUser(mockUser, token);
      emit(AuthAuthenticated(user: mockUser, token: token));
    }
  }

  /// Logout current user
  Future<void> logout() async {
    emit(const AuthLogoutLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);

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

  // Mock helper methods (to be replaced with real API calls)

  String _generateUserId() {
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generateToken() {
    return 'token_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  Future<User?> _findUserByEmailOrPhone(String email, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return null;

    final usersList = json.decode(usersJson) as List;
    for (final userMap in usersList) {
      final userData = userMap['user'] as Map<String, dynamic>;
      if (userData['email'] == email || userData['phoneNumber'] == phone) {
        return User.fromJson(userData);
      }
    }

    return null;
  }

  Future<User?> _authenticateUser(String emailOrPhone, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return null;

    final usersList = json.decode(usersJson) as List;
    for (final userMap in usersList) {
      final userData = userMap['user'] as Map<String, dynamic>;
      final storedPassword = userMap['password'] as String;

      if ((userData['email'] == emailOrPhone ||
              userData['phoneNumber'] == emailOrPhone) &&
          storedPassword == password) {
        return User.fromJson(userData);
      }
    }

    return null;
  }

  Future<void> _saveUserToStorage(User user, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    List<dynamic> usersList = [];
    if (usersJson != null) {
      usersList = json.decode(usersJson) as List;
    }

    usersList.add({
      'user': user.toJson(),
      'password': password, // In real app, this would be hashed
    });

    await prefs.setString(_usersKey, json.encode(usersList));
  }

  Future<void> _updateUserInStorage(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return;

    final usersList = json.decode(usersJson) as List;
    for (int i = 0; i < usersList.length; i++) {
      final userData = usersList[i]['user'] as Map<String, dynamic>;
      if (userData['id'] == user.id) {
        usersList[i]['user'] = user.toJson();
        break;
      }
    }

    await prefs.setString(_usersKey, json.encode(usersList));
  }

  Future<void> _saveCurrentUser(User user, [String? token]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    if (token != null) {
      await prefs.setString(_tokenKey, token);
    }
  }
}
