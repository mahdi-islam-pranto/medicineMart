/// Feedback Models for Online Medicine App
///
/// This file contains all the data models related to feedback functionality
/// including feedback request, response, and data structures.

import 'package:equatable/equatable.dart';

/// Feedback request model for submitting feedback
class FeedbackRequest extends Equatable {
  final int customerId;
  final int overallRating;
  final String category;
  final String feedback;
  final String? suggestions;

  const FeedbackRequest({
    required this.customerId,
    required this.overallRating,
    required this.category,
    required this.feedback,
    this.suggestions,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'overall_rating': overallRating,
      'category': category.toLowerCase(),
      'feedback': feedback,
      'suggestions': suggestions ?? '',
    };
  }

  @override
  List<Object?> get props => [customerId, overallRating, category, feedback, suggestions];

  @override
  String toString() {
    return 'FeedbackRequest(customerId: $customerId, overallRating: $overallRating, category: $category, feedback: $feedback, suggestions: $suggestions)';
  }
}

/// Individual feedback data model
class FeedbackData {
  final int id;
  final int customerId;
  final int overallRating;
  final String category;
  final String feedback;
  final String suggestions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FeedbackData({
    required this.id,
    required this.customerId,
    required this.overallRating,
    required this.category,
    required this.feedback,
    required this.suggestions,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create FeedbackData from JSON
  factory FeedbackData.fromJson(Map<String, dynamic> json) {
    return FeedbackData(
      id: json['id'] as int,
      customerId: json['customer_id'] as int,
      overallRating: json['overall_rating'] as int,
      category: json['category'] as String,
      feedback: json['feedback'] as String,
      suggestions: json['suggestions'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert FeedbackData to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'overall_rating': overallRating,
      'category': category,
      'feedback': feedback,
      'suggestions': suggestions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'FeedbackData(id: $id, customerId: $customerId, overallRating: $overallRating, category: $category, feedback: $feedback, suggestions: $suggestions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackData &&
        other.id == id &&
        other.customerId == customerId &&
        other.overallRating == overallRating &&
        other.category == category &&
        other.feedback == feedback &&
        other.suggestions == suggestions &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(id, customerId, overallRating, category, feedback, suggestions, createdAt, updatedAt);
}

/// Feedback API Response model
class FeedbackResponse {
  final int status;
  final String message;
  final FeedbackData? data;
  final bool success;

  const FeedbackResponse({
    required this.status,
    required this.message,
    this.data,
    this.success = true,
  });

  /// Create FeedbackResponse from JSON
  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: json['data'] != null 
          ? FeedbackData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      success: json['status'] == 200,
    );
  }

  /// Convert FeedbackResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

  /// Create error response
  factory FeedbackResponse.error({
    required String message,
    int status = 500,
  }) {
    return FeedbackResponse(
      status: status,
      message: message,
      data: null,
      success: false,
    );
  }

  @override
  String toString() {
    return 'FeedbackResponse(status: $status, message: $message, data: $data, success: $success)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackResponse &&
        other.status == status &&
        other.message == message &&
        other.data == data &&
        other.success == success;
  }

  @override
  int get hashCode => Object.hash(status, message, data, success);
}
