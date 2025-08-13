import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/navigation_state.dart';

/// Cubit for managing bottom navigation state
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState.initial());

  /// Change the current navigation index
  void changeTab(int index) {
    if (index != state.currentIndex && index >= 0 && index <= 4) {
      emit(state.copyWith(currentIndex: index));
    }
  }

  /// Update cart item count badge
  void updateCartItemCount(int count) {
    if (count != state.cartItemCount && count >= 0) {
      emit(state.copyWith(cartItemCount: count));
    }
  }

  /// Update favorites count badge
  void updateFavoritesCount(int count) {
    if (count != state.favoritesCount && count >= 0) {
      emit(state.copyWith(favoritesCount: count));
    }
  }

  /// Update both badge counts at once
  void updateBadgeCounts({int? cartItemCount, int? favoritesCount}) {
    bool shouldUpdate = false;
    int? newCartCount;
    int? newFavoritesCount;

    if (cartItemCount != null && cartItemCount != state.cartItemCount && cartItemCount >= 0) {
      newCartCount = cartItemCount;
      shouldUpdate = true;
    }

    if (favoritesCount != null && favoritesCount != state.favoritesCount && favoritesCount >= 0) {
      newFavoritesCount = favoritesCount;
      shouldUpdate = true;
    }

    if (shouldUpdate) {
      emit(state.copyWith(
        cartItemCount: newCartCount,
        favoritesCount: newFavoritesCount,
      ));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(const NavigationState.initial());
  }

  /// Navigate to home tab
  void goToHome() => changeTab(0);

  /// Navigate to categories tab
  void goToCategories() => changeTab(1);

  /// Navigate to cart tab
  void goToCart() => changeTab(2);

  /// Navigate to favorites tab
  void goToFavorites() => changeTab(3);

  /// Navigate to profile tab
  void goToProfile() => changeTab(4);

  /// Get tab name by index
  String getTabName(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Categories';
      case 2:
        return 'Cart';
      case 3:
        return 'Favorites';
      case 4:
        return 'Profile';
      default:
        return 'Unknown';
    }
  }

  /// Check if current tab is home
  bool get isHomeTab => state.currentIndex == 0;

  /// Check if current tab is categories
  bool get isCategoriesTab => state.currentIndex == 1;

  /// Check if current tab is cart
  bool get isCartTab => state.currentIndex == 2;

  /// Check if current tab is favorites
  bool get isFavoritesTab => state.currentIndex == 3;

  /// Check if current tab is profile
  bool get isProfileTab => state.currentIndex == 4;
}
