import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Medicine category data model with equatable for state comparison
class MedicineCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int itemCount;

  const MedicineCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.itemCount,
  });

  /// Create a copy of this category with updated fields
  MedicineCategory copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    Color? color,
    int? itemCount,
  }) {
    return MedicineCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  /// Convert to JSON (excluding icon and color as they're not serializable)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'itemCount': itemCount,
    };
  }

  /// Create from JSON (icon and color need to be set separately)
  factory MedicineCategory.fromJson(
    Map<String, dynamic> json, {
    required IconData icon,
    required Color color,
  }) {
    return MedicineCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: icon,
      color: color,
      itemCount: json['itemCount'] as int,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        icon,
        color,
        itemCount,
      ];

  @override
  String toString() {
    return 'MedicineCategory(id: $id, name: $name, itemCount: $itemCount)';
  }
}
