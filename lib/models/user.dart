/// User model for pharmacy owners in the Online Medicine app
/// 
/// This model represents a pharmacy owner who registers to use the app.
/// They need admin approval before they can access the full functionality.
class User {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String pharmacyName;
  final String district;
  final String policeStation;
  final String pharmacyFullAddress;
  final String? nidImagePath; // Path to uploaded NID image
  final String email; // Added for login purposes
  final UserStatus status;
  final DateTime createdAt;
  final DateTime? approvedAt;

  const User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.pharmacyName,
    required this.district,
    required this.policeStation,
    required this.pharmacyFullAddress,
    this.nidImagePath,
    required this.email,
    required this.status,
    required this.createdAt,
    this.approvedAt,
  });

  /// Creates a copy of this user with the given fields replaced with new values
  User copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? pharmacyName,
    String? district,
    String? policeStation,
    String? pharmacyFullAddress,
    String? nidImagePath,
    String? email,
    UserStatus? status,
    DateTime? createdAt,
    DateTime? approvedAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      district: district ?? this.district,
      policeStation: policeStation ?? this.policeStation,
      pharmacyFullAddress: pharmacyFullAddress ?? this.pharmacyFullAddress,
      nidImagePath: nidImagePath ?? this.nidImagePath,
      email: email ?? this.email,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
    );
  }

  /// Converts this user to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'pharmacyName': pharmacyName,
      'district': district,
      'policeStation': policeStation,
      'pharmacyFullAddress': pharmacyFullAddress,
      'nidImagePath': nidImagePath,
      'email': email,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
    };
  }

  /// Creates a user from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      pharmacyName: json['pharmacyName'] as String,
      district: json['district'] as String,
      policeStation: json['policeStation'] as String,
      pharmacyFullAddress: json['pharmacyFullAddress'] as String,
      nidImagePath: json['nidImagePath'] as String?,
      email: json['email'] as String,
      status: UserStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => UserStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      approvedAt: json['approvedAt'] != null 
          ? DateTime.parse(json['approvedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.fullName == fullName &&
        other.phoneNumber == phoneNumber &&
        other.pharmacyName == pharmacyName &&
        other.district == district &&
        other.policeStation == policeStation &&
        other.pharmacyFullAddress == pharmacyFullAddress &&
        other.nidImagePath == nidImagePath &&
        other.email == email &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.approvedAt == approvedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      fullName,
      phoneNumber,
      pharmacyName,
      district,
      policeStation,
      pharmacyFullAddress,
      nidImagePath,
      email,
      status,
      createdAt,
      approvedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, email: $email, status: $status)';
  }
}

/// Enum representing the status of a pharmacy owner's account
enum UserStatus {
  /// User has registered but is waiting for admin approval
  pending,
  
  /// User has been approved by admin and can access the app
  approved,
  
  /// User has been rejected by admin
  rejected,
  
  /// User account has been suspended
  suspended,
}

/// Extension to provide user-friendly status descriptions
extension UserStatusExtension on UserStatus {
  String get displayName {
    switch (this) {
      case UserStatus.pending:
        return 'Pending Approval';
      case UserStatus.approved:
        return 'Approved';
      case UserStatus.rejected:
        return 'Rejected';
      case UserStatus.suspended:
        return 'Suspended';
    }
  }

  String get description {
    switch (this) {
      case UserStatus.pending:
        return 'Your account is under review. Please wait for admin approval.';
      case UserStatus.approved:
        return 'Your account has been approved. You can access all features.';
      case UserStatus.rejected:
        return 'Your account has been rejected. Please contact support.';
      case UserStatus.suspended:
        return 'Your account has been suspended. Please contact support.';
    }
  }

  bool get canLogin {
    return this == UserStatus.approved;
  }
}
