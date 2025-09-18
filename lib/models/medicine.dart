import 'package:equatable/equatable.dart';

/// Medicine data model with equatable for state comparison
class Medicine extends Equatable {
  final String id;
  final String name;
  final String genericName;
  final String quantity;
  final String brand;
  final double regularPrice;
  final double? discountPrice;
  final String? imageUrl;
  final String description;
  final bool requiresPrescription;
  final List<int> quantityOptions;
  final String? productTag;
  final bool allowCustomQuantity;
  final int maxCustomQuantity;
  final String?
      apiDiscountPercentage; // Store the actual API discount percentage

  const Medicine({
    required this.id,
    required this.name,
    required this.genericName,
    required this.quantity,
    required this.brand,
    required this.regularPrice,
    this.discountPrice,
    this.imageUrl,
    required this.description,
    this.requiresPrescription = false,
    this.quantityOptions = const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    this.productTag,
    this.allowCustomQuantity = false,
    this.maxCustomQuantity = 50,
    this.apiDiscountPercentage,
  });

  /// Get discount percentage (from API if available, otherwise calculated)
  double get discountPercentage {
    // Use API discount percentage if available
    if (apiDiscountPercentage != null && apiDiscountPercentage!.isNotEmpty) {
      // Parse the API percentage string (e.g., "51.81%" -> 51.81)
      final percentageStr = apiDiscountPercentage!.replaceAll('%', '');
      final apiPercentage = double.tryParse(percentageStr);
      if (apiPercentage != null &&
          !apiPercentage.isNaN &&
          !apiPercentage.isInfinite) {
        return apiPercentage;
      }
    }

    // Fallback to calculated percentage
    if (discountPrice == null) return 0.0;
    if (regularPrice <= 0) return 0.0; // Prevent division by zero
    if (discountPrice! >= regularPrice) {
      return 0.0; // No discount if discount price is higher or equal
    }

    final percentage = ((regularPrice - discountPrice!) / regularPrice * 100);

    // Check for invalid results (NaN, Infinity)
    if (percentage.isNaN || percentage.isInfinite) return 0.0;

    return percentage;
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
    String? genericName,
    String? quantity,
    String? brand,
    double? regularPrice,
    double? discountPrice,
    String? imageUrl,
    String? description,
    bool? requiresPrescription,
    List<int>? quantityOptions,
    String? productTag,
    bool? allowCustomQuantity,
    int? maxCustomQuantity,
    String? apiDiscountPercentage,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      quantity: quantity ?? this.quantity,
      brand: brand ?? this.brand,
      regularPrice: regularPrice ?? this.regularPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
      quantityOptions: quantityOptions ?? this.quantityOptions,
      productTag: productTag ?? this.productTag,
      allowCustomQuantity: allowCustomQuantity ?? this.allowCustomQuantity,
      maxCustomQuantity: maxCustomQuantity ?? this.maxCustomQuantity,
      apiDiscountPercentage:
          apiDiscountPercentage ?? this.apiDiscountPercentage,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'generic_name': genericName,
      'quantity': quantity,
      'brand': brand,
      'regularPrice': regularPrice,
      'discountPrice': discountPrice,
      'imageUrl': imageUrl,
      'description': description,
      'requiresPrescription': requiresPrescription,
      'quantityOptions': quantityOptions,
      'productTag': productTag,
      'allowCustomQuantity': allowCustomQuantity,
      'maxCustomQuantity': maxCustomQuantity,
      'apiDiscountPercentage': apiDiscountPercentage,
    };
  }

  /// Create from JSON (for local/existing data)
  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] as String,
      name: json['name'] as String,
      genericName: json['generic_name'] as String,
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
      productTag: json['productTag'] as String?,
      allowCustomQuantity: json['allowCustomQuantity'] as bool? ?? false,
      maxCustomQuantity: json['maxCustomQuantity'] as int? ?? 50,
      apiDiscountPercentage: json['apiDiscountPercentage'] as String?,
    );
  }

  /// Helper method to parse price from string or number
  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) {
      return double.tryParse(price) ?? 0.0;
    }
    return 0.0;
  }

  /// Create from API JSON response
  factory Medicine.fromApiJson(Map<String, dynamic> json) {
    // Handle null imageUrl with fallback
    String? imageUrl = json['imageUrl'] as String?;
    if (imageUrl == null || imageUrl.isEmpty) {
      // Use a working sample medicine image
      imageUrl = null;
    }

    return Medicine(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      genericName: json['generic_name'] as String? ?? '',
      quantity: json['productType'] as String? ??
          'Strip', // Use productType as quantity
      brand: json['manufacturer'] as String? ?? 'Unknown Brand',
      regularPrice: _parsePrice(json['regularPrice']),
      discountPrice: json['discountPrice'] != null
          ? _parsePrice(json['discountPrice'])
          : null,
      imageUrl: imageUrl,
      description:
          json['description'] as String? ?? json['name'] as String? ?? '',
      requiresPrescription: json['requiresPrescription'] as bool? ?? false,
      quantityOptions: json['quantityOptions'] != null
          ? List<int>.from(json['quantityOptions'] as List)
          : const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      productTag: json['productTag'] as String?,
      allowCustomQuantity: json['allowCustomQuantity'] as bool? ?? false,
      maxCustomQuantity: json['maxCustomQuantity'] as int? ?? 50,
      apiDiscountPercentage: json['discountPersentage']
          as String?, // Note: API has typo "Persentage"
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        genericName,
        quantity,
        brand,
        regularPrice,
        discountPrice,
        imageUrl,
        description,
        requiresPrescription,
        quantityOptions,
        productTag,
        allowCustomQuantity,
        maxCustomQuantity,
        apiDiscountPercentage,
      ];

  @override
  String toString() {
    return 'Medicine(id: $id, name: $name, genericName: $genericName, brand: $brand, price: $effectivePrice)';
  }
}
