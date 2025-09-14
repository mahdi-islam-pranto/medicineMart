import 'user.dart';

/// Registration request model for pharmacy owner registration
class RegistrationRequest {
  final String fullName;
  final String phoneNumber;
  final String pharmacyName;
  final String district;
  final String policeStation;
  final String pharmacyFullAddress;
  final String email;
  final String password;
  final String confirmPassword;
  final String nidImagePath; // Now required (non-nullable)

  const RegistrationRequest({
    required this.fullName,
    required this.phoneNumber,
    required this.pharmacyName,
    required this.district,
    required this.policeStation,
    required this.pharmacyFullAddress,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.nidImagePath, // Now required
  });

  /// Validates the registration request
  List<String> validate() {
    final errors = <String>[];

    if (fullName.trim().isEmpty) {
      errors.add('Full name is required');
    }

    if (phoneNumber.trim().isEmpty) {
      errors.add('Phone number is required');
    } else if (!_isValidPhoneNumber(phoneNumber)) {
      errors.add('Please enter a valid phone number');
    }

    if (pharmacyName.trim().isEmpty) {
      errors.add('Pharmacy name is required');
    }

    if (district.trim().isEmpty) {
      errors.add('District is required');
    }

    if (policeStation.trim().isEmpty) {
      errors.add('Police station is required');
    }

    if (pharmacyFullAddress.trim().isEmpty) {
      errors.add('Pharmacy address is required');
    }

    if (email.trim().isEmpty) {
      errors.add('Email is required');
    } else if (!_isValidEmail(email)) {
      errors.add('Please enter a valid email address');
    }

    if (password.isEmpty) {
      errors.add('Password is required');
    } else if (password.length < 6) {
      errors.add('Password must be at least 6 characters long');
    }

    if (confirmPassword.isEmpty) {
      errors.add('Please confirm your password');
    } else if (password != confirmPassword) {
      errors.add('Passwords do not match');
    }

    return errors;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    // Basic validation for Bangladeshi phone numbers
    return RegExp(r'^(\+88)?01[0-9]\d{8}$').hasMatch(phone.replaceAll(' ', ''));
  }

  /// Converts to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'pharmacyName': pharmacyName,
      'district': district,
      'policeStation': policeStation,
      'pharmacyFullAddress': pharmacyFullAddress,
      'email': email,
      'password': password,
      'nidImagePath': nidImagePath,
    };
  }
}

/// Login request model
class LoginRequest {
  final String emailOrPhone;
  final String password;
  final String? deviceId;

  const LoginRequest({
    required this.emailOrPhone,
    required this.password,
    this.deviceId,
  });

  /// Validates the login request
  List<String> validate() {
    final errors = <String>[];

    if (emailOrPhone.trim().isEmpty) {
      errors.add('Email or phone number is required');
    }

    if (password.isEmpty) {
      errors.add('Password is required');
    }

    return errors;
  }

  /// Converts to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'emailOrPhone': emailOrPhone,
      'password': password,
      'device_id':
          deviceId ?? 'flutter_app_${DateTime.now().millisecondsSinceEpoch}',
    };
  }
}

/// Authentication response model
class AuthResponse {
  final bool success;
  final String? message;
  final User? user;
  final String? token;

  const AuthResponse({
    required this.success,
    this.message,
    this.user,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      token: json['token'] as String?,
    );
  }

  /// Success response factory
  factory AuthResponse.success({
    String? message,
    User? user,
    String? token,
  }) {
    return AuthResponse(
      success: true,
      message: message,
      user: user,
      token: token,
    );
  }

  /// Error response factory
  factory AuthResponse.error(String message) {
    return AuthResponse(
      success: false,
      message: message,
    );
  }
}

/// Districts in Bangladesh (commonly used ones)
class Districts {
  static const List<String> all = [
    'Barisal',
    'Chittagong',
    'Dhaka',
    'Khulna',
    'Mymensingh',
    'Rajshahi',
    'Rangpur',
    'Sylhet',
    'Barguna',
    'Bhola',
    'Jhalokati',
    'Patuakhali',
    'Pirojpur',
    'Bandarban',
    'Brahmanbaria',
    'Chandpur',
    'Comilla',
    'Cox\'s Bazar',
    'Feni',
    'Khagrachhari',
    'Lakshmipur',
    'Noakhali',
    'Rangamati',
    'Faridpur',
    'Gazipur',
    'Gopalganj',
    'Kishoreganj',
    'Madaripur',
    'Manikganj',
    'Munshiganj',
    'Narayanganj',
    'Narsingdi',
    'Rajbari',
    'Shariatpur',
    'Tangail',
    'Bagerhat',
    'Chuadanga',
    'Jessore',
    'Jhenaidah',
    'Kushtia',
    'Magura',
    'Meherpur',
    'Narail',
    'Satkhira',
    'Jamalpur',
    'Netrakona',
    'Sherpur',
    'Bogra',
    'Joypurhat',
    'Naogaon',
    'Natore',
    'Chapainawabganj',
    'Pabna',
    'Sirajganj',
    'Dinajpur',
    'Gaibandha',
    'Kurigram',
    'Lalmonirhat',
    'Nilphamari',
    'Panchagarh',
    'Thakurgaon',
    'Habiganj',
    'Moulvibazar',
    'Sunamganj',
  ];
}
