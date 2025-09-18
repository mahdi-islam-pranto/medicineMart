import 'package:equatable/equatable.dart';

/// Category data model
class Category extends Equatable {
  final int id;
  final String name;

  const Category({
    required this.id,
    required this.name,
  });

  /// Create from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
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
  String toString() => 'Category(id: $id, name: $name)';
}

/// Category API response model
class CategoryResponse extends Equatable {
  final bool success;
  final String message;
  final List<Category> categories;

  const CategoryResponse({
    required this.success,
    required this.message,
    required this.categories,
  });

  /// Create from JSON
  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    final categories = dataList
        .map((item) => Category.fromJson(item as Map<String, dynamic>))
        .toList();

    return CategoryResponse(
      success: json['status'] == '200',
      message: json['message'] as String? ?? '',
      categories: categories,
    );
  }

  /// Create error response
  factory CategoryResponse.error(String message) {
    return CategoryResponse(
      success: false,
      message: message,
      categories: [],
    );
  }

  @override
  List<Object?> get props => [success, message, categories];

  @override
  String toString() => 'CategoryResponse(success: $success, message: $message, categories: ${categories.length})';
}
