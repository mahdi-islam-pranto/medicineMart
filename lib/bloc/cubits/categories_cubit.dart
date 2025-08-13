import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/categories_state.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';

/// Cubit for managing medicine categories
class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(const CategoriesInitial());

  /// Load categories data
  Future<void> loadCategories() async {
    emit(const CategoriesLoading());
    
    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Load sample categories data - In a real app, this would come from an API
      final categories = _getSampleCategories();
      
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(CategoriesError(message: 'Failed to load categories: ${e.toString()}'));
    }
  }

  /// Update search query for categories
  void updateSearchQuery(String query) {
    final currentState = state;
    if (currentState is CategoriesLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  /// Clear search query
  void clearSearch() {
    final currentState = state;
    if (currentState is CategoriesLoaded) {
      emit(currentState.copyWith(searchQuery: ''));
    }
  }

  /// Refresh categories data
  Future<void> refreshCategories() async {
    final currentState = state;
    if (currentState is CategoriesLoaded) {
      try {
        // Simulate API call delay
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Reload data
        final categories = _getSampleCategories();
        
        emit(currentState.copyWith(categories: categories));
      } catch (e) {
        emit(CategoriesError(message: 'Failed to refresh categories: ${e.toString()}'));
      }
    } else {
      // If not loaded, just load normally
      await loadCategories();
    }
  }

  /// Get sample categories data
  List<MedicineCategory> _getSampleCategories() {
    return [
      MedicineCategory(
        id: '1',
        name: 'Pain Relief',
        description: 'Analgesics & Anti-inflammatory',
        icon: Icons.healing,
        color: AppColors.error.withOpacity(0.1),
        itemCount: 45,
      ),
      MedicineCategory(
        id: '2',
        name: 'Antibiotics',
        description: 'Bacterial infection treatment',
        icon: Icons.medication,
        color: AppColors.primary.withOpacity(0.1),
        itemCount: 32,
      ),
      MedicineCategory(
        id: '3',
        name: 'Vitamins',
        description: 'Supplements & Nutrients',
        icon: Icons.eco,
        color: AppColors.success.withOpacity(0.1),
        itemCount: 28,
      ),
      MedicineCategory(
        id: '4',
        name: 'Heart Care',
        description: 'Cardiovascular medicines',
        icon: Icons.favorite,
        color: AppColors.error.withOpacity(0.1),
        itemCount: 23,
      ),
      MedicineCategory(
        id: '5',
        name: 'Diabetes',
        description: 'Blood sugar management',
        icon: Icons.water_drop,
        color: AppColors.info.withOpacity(0.1),
        itemCount: 19,
      ),
      MedicineCategory(
        id: '6',
        name: 'Skin Care',
        description: 'Dermatological treatments',
        icon: Icons.face,
        color: AppColors.warning.withOpacity(0.1),
        itemCount: 34,
      ),
      MedicineCategory(
        id: '7',
        name: 'Respiratory',
        description: 'Breathing & lung care',
        icon: Icons.air,
        color: AppColors.secondary.withOpacity(0.1),
        itemCount: 27,
      ),
      MedicineCategory(
        id: '8',
        name: 'Digestive',
        description: 'Stomach & digestive health',
        icon: Icons.restaurant,
        color: AppColors.accent.withOpacity(0.1),
        itemCount: 31,
      ),
      MedicineCategory(
        id: '9',
        name: 'Eye Care',
        description: 'Ophthalmic medicines',
        icon: Icons.visibility,
        color: AppColors.primary.withOpacity(0.1),
        itemCount: 16,
      ),
      MedicineCategory(
        id: '10',
        name: 'Women\'s Health',
        description: 'Gynecological medicines',
        icon: Icons.woman,
        color: AppColors.accent.withOpacity(0.1),
        itemCount: 22,
      ),
      MedicineCategory(
        id: '11',
        name: 'Mental Health',
        description: 'Psychiatric medicines',
        icon: Icons.psychology,
        color: AppColors.info.withOpacity(0.1),
        itemCount: 18,
      ),
      MedicineCategory(
        id: '12',
        name: 'Child Care',
        description: 'Pediatric medicines',
        icon: Icons.child_care,
        color: AppColors.warning.withOpacity(0.1),
        itemCount: 25,
      ),
    ];
  }
}
