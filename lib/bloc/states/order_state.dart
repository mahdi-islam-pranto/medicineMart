import 'package:equatable/equatable.dart';
import '../../models/models.dart';

/// Base state for order management
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

/// Initial state when order cubit is first created
class OrderInitial extends OrderState {
  const OrderInitial();
}

/// State when orders are being loaded
class OrderLoading extends OrderState {
  const OrderLoading();
}

/// State when orders are successfully loaded
class OrderLoaded extends OrderState {
  final List<OrderData> orders;
  final OrderPagination pagination;
  final OrderSummary summary;
  final String
      currentStatus; // 'all', '1' (pending), '2' (confirmed), '3' (delivered), '4' (cancelled)
  final bool isLoadingMore;

  const OrderLoaded({
    required this.orders,
    required this.pagination,
    required this.summary,
    required this.currentStatus,
    this.isLoadingMore = false,
  });

  /// Check if orders list is empty
  bool get isEmpty => orders.isEmpty;

  /// Check if orders list has items
  bool get isNotEmpty => orders.isNotEmpty;

  /// Check if there are more pages to load
  bool get hasMorePages => pagination.hasNext;

  /// Get orders count for current status
  int get ordersCount => orders.length;

  /// Create a copy of this state with updated fields
  OrderLoaded copyWith({
    List<OrderData>? orders,
    OrderPagination? pagination,
    OrderSummary? summary,
    String? currentStatus,
    bool? isLoadingMore,
  }) {
    return OrderLoaded(
      orders: orders ?? this.orders,
      pagination: pagination ?? this.pagination,
      summary: summary ?? this.summary,
      currentStatus: currentStatus ?? this.currentStatus,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        orders,
        pagination,
        summary,
        currentStatus,
        isLoadingMore,
      ];
}

/// State when there's an error with order operations
class OrderError extends OrderState {
  final String message;
  final String? errorCode;

  const OrderError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

/// State when refreshing orders
class OrderRefreshing extends OrderState {
  final List<OrderData> previousOrders;
  final String currentStatus;

  const OrderRefreshing({
    required this.previousOrders,
    required this.currentStatus,
  });

  @override
  List<Object?> get props => [previousOrders, currentStatus];
}
