import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/order_state.dart';
import '../../models/models.dart';
import '../../APIs/order_list_api_service.dart';

/// Cubit for managing orders list and operations
class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderInitial());

  /// Load orders for a specific status
  Future<void> loadOrders({
    required String status,
    int? customerId,
    int page = 1,
    bool isRefresh = false,
  }) async {
    final currentState = state;
    
    // Show appropriate loading state
    if (isRefresh && currentState is OrderLoaded) {
      emit(OrderRefreshing(
        previousOrders: currentState.orders,
        currentStatus: status,
      ));
    } else if (page == 1) {
      emit(const OrderLoading());
    } else if (currentState is OrderLoaded) {
      emit(currentState.copyWith(isLoadingMore: true));
    }

    try {
      // Use provided customerId or default to 1 for development
      final customerIdToUse = customerId ?? 1;

      // Make API call to get orders
      final apiResponse = await OrderListApiService.getOrdersByStatus(
        customerId: customerIdToUse,
        status: status,
        page: page,
        limit: 20,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final orderListData = apiResponse.data!;
        
        // Handle pagination - append or replace orders
        List<OrderData> finalOrders;
        if (page == 1 || isRefresh) {
          // First page or refresh - replace all orders
          finalOrders = orderListData.orders;
        } else {
          // Load more - append to existing orders
          final existingOrders = currentState is OrderLoaded 
              ? currentState.orders 
              : <OrderData>[];
          finalOrders = [...existingOrders, ...orderListData.orders];
        }

        emit(OrderLoaded(
          orders: finalOrders,
          pagination: orderListData.pagination,
          summary: orderListData.summary,
          currentStatus: status,
        ));
      } else {
        // API call failed
        emit(OrderError(message: apiResponse.message));
      }
    } catch (e) {
      emit(OrderError(message: 'Failed to load orders: ${e.toString()}'));
    }
  }

  /// Load all orders
  Future<void> loadAllOrders({int? customerId, bool isRefresh = false}) async {
    await loadOrders(
      status: 'all',
      customerId: customerId,
      isRefresh: isRefresh,
    );
  }

  /// Load pending orders
  Future<void> loadPendingOrders({int? customerId, bool isRefresh = false}) async {
    await loadOrders(
      status: '1',
      customerId: customerId,
      isRefresh: isRefresh,
    );
  }

  /// Load delivered orders
  Future<void> loadDeliveredOrders({int? customerId, bool isRefresh = false}) async {
    await loadOrders(
      status: '2',
      customerId: customerId,
      isRefresh: isRefresh,
    );
  }

  /// Load cancelled orders
  Future<void> loadCancelledOrders({int? customerId, bool isRefresh = false}) async {
    await loadOrders(
      status: '3',
      customerId: customerId,
      isRefresh: isRefresh,
    );
  }

  /// Load more orders (pagination)
  Future<void> loadMoreOrders({int? customerId}) async {
    final currentState = state;
    if (currentState is OrderLoaded && currentState.hasMorePages && !currentState.isLoadingMore) {
      await loadOrders(
        status: currentState.currentStatus,
        customerId: customerId,
        page: currentState.pagination.currentPage + 1,
      );
    }
  }

  /// Refresh current orders
  Future<void> refreshOrders({int? customerId}) async {
    final currentState = state;
    if (currentState is OrderLoaded) {
      await loadOrders(
        status: currentState.currentStatus,
        customerId: customerId,
        isRefresh: true,
      );
    } else {
      // Default to all orders if no current state
      await loadAllOrders(customerId: customerId, isRefresh: true);
    }
  }

  /// Switch to a different status tab
  Future<void> switchToStatus(String status, {int? customerId}) async {
    await loadOrders(
      status: status,
      customerId: customerId,
    );
  }
}
