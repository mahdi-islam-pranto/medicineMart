import 'package:equatable/equatable.dart';
import 'medicine.dart';

/// Favorite item data model with equatable for state comparison
class FavoriteItem extends Equatable {
  final String id;
  final String name;
  final String genericName;
  final String quantity;
  final String brand;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final DateTime addedDate;

  const FavoriteItem({
    required this.id,
    required this.genericName,
    required this.name,
    required this.quantity,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.addedDate,
  });

  /// Calculate discount percentage
  int get discountPercentage {
    if (originalPrice <= price) return 0;
    if (originalPrice <= 0) return 0; // Prevent division by zero

    final percentage = ((originalPrice - price) / originalPrice * 100);

    // Check for invalid results (NaN, Infinity)
    if (percentage.isNaN || percentage.isInfinite) return 0;

    return percentage.round();
  }

  /// Check if item has discount
  bool get hasDiscount => price < originalPrice;

  /// Calculate discount amount
  double get discountAmount => originalPrice - price;

  /// Create favorite item from medicine
  factory FavoriteItem.fromMedicine(Medicine medicine) {
    return FavoriteItem(
      id: medicine.id,
      name: medicine.name,
      genericName: medicine.genericName,
      quantity: medicine.quantity,
      brand: medicine.brand,
      price: medicine.effectivePrice,
      originalPrice: medicine.regularPrice,
      imageUrl: medicine.imageUrl ?? '',
      addedDate: DateTime.now(),
    );
  }

  /// Convert to medicine object
  Medicine toMedicine() {
    return Medicine(
      id: id,
      name: name,
      genericName: genericName,
      quantity: quantity,
      brand: brand,
      regularPrice: originalPrice,
      discountPrice: hasDiscount ? price : null,
      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      description: '', // Description not stored in favorites
      requiresPrescription: false, // Default value
    );
  }

  /// Create a copy of this favorite item with updated fields
  FavoriteItem copyWith({
    String? id,
    String? name,
    String? quantity,
    String? brand,
    double? price,
    double? originalPrice,
    String? imageUrl,
    DateTime? addedDate,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      quantity: quantity ?? this.quantity,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      addedDate: addedDate ?? this.addedDate,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'brand': brand,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'addedDate': addedDate.toIso8601String(),
    };
  }

  /// Create from JSON
  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      genericName: json['generic_name'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String? ?? '',
      addedDate: json['addedDate'] != null
          ? DateTime.tryParse(json['addedDate'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        quantity,
        brand,
        price,
        originalPrice,
        imageUrl,
        addedDate,
      ];

  @override
  String toString() {
    return 'FavoriteItem(id: $id, name: $name, brand: $brand, addedDate: $addedDate)';
  }
}
