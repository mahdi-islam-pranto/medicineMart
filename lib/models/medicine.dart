import 'package:equatable/equatable.dart';

/// Medicine data model with equatable for state comparison
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

  const Medicine({
    required this.id,
    required this.name,
    required this.quantity,
    required this.brand,
    required this.regularPrice,
    this.discountPrice,
    this.imageUrl,
    required this.description,
    this.requiresPrescription = false,
    this.quantityOptions = const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  });

  /// Calculate discount percentage
  int get discountPercentage {
    if (discountPrice == null) return 0;
    return ((regularPrice - discountPrice!) / regularPrice * 100).round();
  }

  /// Get effective price (discount price if available, otherwise regular price)
  double get effectivePrice => discountPrice ?? regularPrice;

  /// Check if medicine has discount
  bool get hasDiscount =>
      discountPrice != null && discountPrice! < regularPrice;

  /// Create a copy of this medicine with updated fields
  Medicine copyWith({
    String? id,
    String? name,
    String? quantity,
    String? brand,
    double? regularPrice,
    double? discountPrice,
    String? imageUrl,
    String? description,
    bool? requiresPrescription,
    List<int>? quantityOptions,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      brand: brand ?? this.brand,
      regularPrice: regularPrice ?? this.regularPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
      quantityOptions: quantityOptions ?? this.quantityOptions,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'brand': brand,
      'regularPrice': regularPrice,
      'discountPrice': discountPrice,
      'imageUrl': imageUrl,
      'description': description,
      'requiresPrescription': requiresPrescription,
      'quantityOptions': quantityOptions,
    };
  }

  /// Create from JSON
  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as String,
      brand: json['brand'] as String,
      regularPrice: (json['regularPrice'] as num).toDouble(),
      discountPrice: json['discountPrice'] != null
          ? (json['discountPrice'] as num).toDouble()
          : null,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String,
      requiresPrescription: json['requiresPrescription'] as bool? ?? false,
      quantityOptions: json['quantityOptions'] != null
          ? List<int>.from(json['quantityOptions'] as List)
          : const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        quantity,
        brand,
        regularPrice,
        discountPrice,
        imageUrl,
        description,
        requiresPrescription,
        quantityOptions,
      ];

  @override
  String toString() {
    return 'Medicine(id: $id, name: $name, brand: $brand, price: $effectivePrice)';
  }
}
