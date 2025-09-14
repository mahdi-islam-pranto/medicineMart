/// FAQ Models for Online Medicine App
///
/// This file contains all the data models related to FAQ functionality
/// including FAQ items and API response structures.

/// Individual FAQ item model
class FaqItem {
  final int id;
  final String title;
  final String description;

  const FaqItem({
    required this.id,
    required this.title,
    required this.description,
  });

  /// Create FaqItem from JSON
  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  /// Convert FaqItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'FaqItem(id: $id, title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FaqItem &&
        other.id == id &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode => Object.hash(id, title, description);
}

/// FAQ API Response model
class FaqResponse {
  final String status;
  final String message;
  final List<FaqItem> data;
  final bool success;

  const FaqResponse({
    required this.status,
    required this.message,
    required this.data,
    this.success = true,
  });

  /// Create FaqResponse from JSON
  factory FaqResponse.fromJson(Map<String, dynamic> json) {
    return FaqResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => FaqItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      success: json['status'] == '200',
    );
  }

  /// Convert FaqResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  /// Create error response
  factory FaqResponse.error({
    required String message,
    String status = 'error',
  }) {
    return FaqResponse(
      status: status,
      message: message,
      data: const [],
      success: false,
    );
  }

  @override
  String toString() {
    return 'FaqResponse(status: $status, message: $message, data: ${data.length} items, success: $success)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FaqResponse &&
        other.status == status &&
        other.message == message &&
        other.data.length == data.length &&
        other.success == success;
  }

  @override
  int get hashCode => Object.hash(status, message, data, success);
}
