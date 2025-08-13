import 'package:equatable/equatable.dart';

/// State for bottom navigation management
class NavigationState extends Equatable {
  final int currentIndex;
  final int cartItemCount;
  final int favoritesCount;

  const NavigationState({
    required this.currentIndex,
    required this.cartItemCount,
    required this.favoritesCount,
  });

  /// Initial state with default values
  const NavigationState.initial()
      : currentIndex = 0,
        cartItemCount = 0,
        favoritesCount = 0;

  /// Create a copy of this state with updated fields
  NavigationState copyWith({
    int? currentIndex,
    int? cartItemCount,
    int? favoritesCount,
  }) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      cartItemCount: cartItemCount ?? this.cartItemCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
    );
  }

  @override
  List<Object?> get props => [currentIndex, cartItemCount, favoritesCount];

  @override
  String toString() {
    return 'NavigationState(currentIndex: $currentIndex, cartItemCount: $cartItemCount, favoritesCount: $favoritesCount)';
  }
}
