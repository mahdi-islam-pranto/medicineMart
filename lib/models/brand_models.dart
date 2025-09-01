import 'package:equatable/equatable.dart';

/// Brand model for company/manufacturer information
class Brand extends Equatable {
  final int id;
  final String name;

  const Brand({
    required this.id,
    required this.name,
  });

  /// Create from API JSON response
  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() => 'Brand(id: $id, name: $name)';
}

/// Brand API response model
class BrandResponse extends Equatable {
  final String status;
  final String message;
  final List<Brand> data;

  const BrandResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  /// Create from API JSON response
  factory BrandResponse.fromJson(Map<String, dynamic> json) {
    return BrandResponse(
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => Brand.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Check if response is successful
  bool get isSuccess => status == '200';

  @override
  List<Object?> get props => [status, message, data];

  @override
  String toString() => 'BrandResponse(status: $status, message: $message, brands: ${data.length})';
}
