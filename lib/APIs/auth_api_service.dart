import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';
import '../models/user.dart';
import 'api_config.dart';

/// Authentication API Service
///
/// This service handles all authentication-related API calls including
/// registration and login with proper error handling and response parsing.
class AuthApiService {
  /// Register a new pharmacy owner
  ///
  /// Takes a [RegistrationRequest] and sends it to the registration endpoint.
  /// Returns an [AuthResponse] with success/failure status and user data.
  static Future<AuthResponse> register(RegistrationRequest request) async {
    try {
      // Prepare the request body according to API specification
      final requestBody = {
        'fullName': request.fullName,
        'phoneNumber': request.phoneNumber,
        'pharmacyName': request.pharmacyName,
        'district': request.district,
        'policeStation': request.policeStation,
        'pharmacyFullAddress': request.pharmacyFullAddress,
        'email': request.email,
        'password': request.password,
        'nidImagePath':
            request.nidImagePath ?? 'string', // Default value as per API
      };

      // Make the HTTP POST request
      final response = await http
          .post(
            Uri.parse(ApiConfig.registerUrl),
            headers: ApiConfig.headers,
            body: json.encode(requestBody),
          )
          .timeout(ApiConfig.requestTimeout);

      // Parse the response
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        // Note: Adjust this based on your actual API response structure
        return AuthResponse.success(
          message: responseData['message'] ??
              'Registration successful! Please wait for admin approval.',
          user: _parseUserFromResponse(responseData, request),
        );
      } else {
        // Registration failed
        final errorMessage = responseData['message'] ??
            responseData['error'] ??
            'Registration failed. Please try again.';
        return AuthResponse.error(errorMessage);
      }
    } on SocketException {
      return AuthResponse.error(
          'No internet connection. Please check your network and try again.');
    } on http.ClientException {
      return AuthResponse.error('Network error. Please try again.');
    } on FormatException {
      return AuthResponse.error(
          'Invalid response from server. Please try again.');
    } catch (e) {
      return AuthResponse.error('Registration failed. Please try again.');
    }
  }

  /// Login with email/phone and password
  ///
  /// Takes a [LoginRequest] and sends it to the login endpoint.
  /// Returns an [AuthResponse] with success/failure status, user data, and token.
  static Future<AuthResponse> login(LoginRequest request) async {
    try {
      // Prepare the request body according to API specification
      final requestBody = request.toJson();

      // Make the HTTP POST request
      final response = await http
          .post(
            Uri.parse(ApiConfig.loginUrl),
            headers: ApiConfig.headers,
            body: json.encode(requestBody),
          )
          .timeout(ApiConfig.requestTimeout);

      // Parse the response
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Login successful
        // Parse the actual API response structure
        final data = responseData['data'];
        final token = data['token'];
        final customer = data['customer'];

        if (customer != null) {
          final user = _parseUserFromLoginResponse(customer);
          return AuthResponse.success(
            message: responseData['message'] ?? 'Login successful!',
            user: user,
            token: token,
          );
        } else {
          return AuthResponse.error('Invalid response from server.');
        }
      } else if (response.statusCode == 403) {
        return AuthResponse.error(
            'Wait for admin approval. Please try after some time again.');
      } else {
        // Login failed
        final errorMessage = responseData['message'] ??
            responseData['error'] ??
            'Invalid credentials. Please try again.';
        return AuthResponse.error(errorMessage);
      }
    } on SocketException {
      return AuthResponse.error(
          'No internet connection. Please check your network and try again.');
    } on http.ClientException {
      return AuthResponse.error('Network error. Please try again.');
    } on FormatException {
      return AuthResponse.error(
          'Invalid response from server. Please try again.');
    } catch (e) {
      return AuthResponse.error('Login failed. Please try again.');
    }
  }

  /// Parse user data from registration response
  ///
  /// Since the registration API might not return complete user data,
  /// we create a user object from the request data and response.
  static User _parseUserFromResponse(
      Map<String, dynamic> responseData, RegistrationRequest request) {
    // Extract user data from response or use request data as fallback
    final userData = responseData['user'] ?? responseData['data'];

    return User(
      id: userData?['id']?.toString() ??
          'temp_${DateTime.now().millisecondsSinceEpoch}',
      fullName: userData?['fullName'] ?? request.fullName,
      phoneNumber: userData?['phoneNumber'] ?? request.phoneNumber,
      pharmacyName: userData?['pharmacyName'] ?? request.pharmacyName,
      district: userData?['district'] ?? request.district,
      policeStation: userData?['policeStation'] ?? request.policeStation,
      pharmacyFullAddress:
          userData?['pharmacyFullAddress'] ?? request.pharmacyFullAddress,
      email: userData?['email'] ?? request.email,
      nidImagePath: userData?['nidImagePath'] ?? request.nidImagePath,
      status: _parseUserStatus(userData?['status']),
      createdAt: _parseDateTime(userData?['createdAt']) ?? DateTime.now(),
      approvedAt: _parseDateTime(userData?['approvedAt']),
    );
  }

  /// Parse user data from login response
  static User _parseUserFromLoginResponse(Map<String, dynamic> userData) {
    return User(
      id: userData['id']?.toString() ??
          'temp_${DateTime.now().millisecondsSinceEpoch}',
      fullName: userData['fullName'] ?? '',
      phoneNumber: userData['phoneNumber'] ?? '',
      pharmacyName: userData['pharmacyName'] ?? '',
      district: userData['district'] ?? '',
      policeStation: userData['policeStation'] ?? '',
      pharmacyFullAddress: userData['pharmacyFullAddress'] ?? '',
      email: userData['email'] ?? '',
      nidImagePath: userData['nidImagePath'],
      status: _parseUserStatus(userData['login_approval']),
      createdAt: _parseDateTime(userData['created_at']) ?? DateTime.now(),
      approvedAt:
          _parseDateTime(userData['approvedAt'] ?? userData['approved_at']),
    );
  }

  /// Parse user status from API response
  static UserStatus _parseUserStatus(dynamic status) {
    if (status == null) return UserStatus.pending;

    final statusStr = status.toString();
    switch (statusStr) {
      case '1':
        return UserStatus.approved;
      case '0':
        return UserStatus.pending;
      case '-1':
        return UserStatus.rejected;
      default:
        return UserStatus.pending;
    }
  }

  /// Parse DateTime from API response
  static DateTime? _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return null;

    try {
      if (dateTime is String) {
        return DateTime.parse(dateTime);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
