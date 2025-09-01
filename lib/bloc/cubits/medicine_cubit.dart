import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/medicine_state.dart';
import '../../models/models.dart';
import '../../APIs/product_api_service.dart';

/// Cubit for managing medicine list, search, and filtering
class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit() : super(const MedicineInitial());

  /// Load medicines data
  Future<void> loadMedicines() async {
    emit(const MedicineLoading());

    try {
      // Call the real API to get all products
      final response = await ProductApiService.getAllProducts(limit: 50);

      if (response.success && response.data != null) {
        final medicines = response.data!.products;
        final brands = _extractBrands(medicines);

        emit(MedicineLoaded(
          medicines: medicines,
          brands: brands,
        ));
      } else {
        // If API fails, fall back to sample data for development
        final medicines = _getSampleMedicines();
        final brands = _extractBrands(medicines);

        emit(MedicineLoaded(
          medicines: medicines,
          brands: brands,
        ));
      }
    } catch (e) {
      // If API fails, fall back to sample data for development
      final medicines = _getSampleMedicines();
      final brands = _extractBrands(medicines);

      emit(MedicineLoaded(
        medicines: medicines,
        brands: brands,
      ));
    }
  }

  /// Refresh medicines data
  Future<void> refreshMedicines() async {
    final currentState = state;
    if (currentState is MedicineLoaded) {
      emit(currentState.copyWith(isRefreshing: true));

      try {
        // Call the real API to refresh data
        final response = await ProductApiService.getAllProducts(limit: 50);

        if (response.success && response.data != null) {
          final medicines = response.data!.products;
          final brands = _extractBrands(medicines);

          emit(currentState.copyWith(
            medicines: medicines,
            brands: brands,
            isRefreshing: false,
          ));
        } else {
          // If API fails, keep current data and stop refreshing
          emit(currentState.copyWith(isRefreshing: false));
        }
      } catch (e) {
        // If API fails, keep current data and stop refreshing
        emit(currentState.copyWith(isRefreshing: false));
      }
    } else {
      // If not loaded, just load normally
      await loadMedicines();
    }
  }

  /// Update search query
  void updateSearchQuery(String query) {
    final currentState = state;
    if (currentState is MedicineLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  /// Search medicines by query using API
  Future<void> searchMedicines(String query) async {
    final currentState = state;
    if (currentState is MedicineLoaded) {
      if (query.isEmpty) {
        // Reset to all medicines - reload from API
        await loadMedicines();
      } else {
        // Search using API
        try {
          final response =
              await ProductApiService.searchProductsByQuery(query, limit: 50);

          if (response.success && response.data != null) {
            final medicines = response.data!.products;
            final brands = _extractBrands(medicines);
            emit(currentState.copyWith(
              medicines: medicines,
              brands: brands,
              searchQuery: query,
            ));
          } else {
            // If API fails, fall back to local filtering
            final filtered = currentState.medicines.where((medicine) {
              return medicine.name
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  medicine.brand.toLowerCase().contains(query.toLowerCase()) ||
                  medicine.description
                      .toLowerCase()
                      .contains(query.toLowerCase());
            }).toList();

            emit(currentState.copyWith(
              medicines: filtered,
              searchQuery: query,
            ));
          }
        } catch (e) {
          // If API fails, fall back to local filtering
          final filtered = currentState.medicines.where((medicine) {
            return medicine.name.toLowerCase().contains(query.toLowerCase()) ||
                medicine.brand.toLowerCase().contains(query.toLowerCase()) ||
                medicine.description
                    .toLowerCase()
                    .contains(query.toLowerCase());
          }).toList();

          emit(currentState.copyWith(
            medicines: filtered,
            searchQuery: query,
          ));
        }
      }
    }
  }

  /// Update selected brand filter
  void updateBrandFilter(String? brand) {
    final currentState = state;
    if (currentState is MedicineLoaded) {
      emit(currentState.copyWith(selectedBrand: brand));
    }
  }

  /// Update selected letter filter
  void updateLetterFilter(String? letter) {
    final currentState = state;
    if (currentState is MedicineLoaded) {
      emit(currentState.copyWith(selectedLetter: letter));
    }
  }

  /// Clear brand filter
  void clearBrandFilter() {
    final currentState = state;
    if (currentState is MedicineLoaded) {
      emit(currentState.copyWith(clearBrand: true));
    }
  }

  /// Clear letter filter
  void clearLetterFilter() {
    final currentState = state;
    if (currentState is MedicineLoaded) {
      emit(currentState.copyWith(clearLetter: true));
    }
  }

  /// Clear all filters
  void clearAllFilters() {
    final currentState = state;
    if (currentState is MedicineLoaded) {
      emit(currentState.copyWith(
        searchQuery: '',
        clearBrand: true,
        clearLetter: true,
      ));
    }
  }

  /// Get sample medicines data
  List<Medicine> _getSampleMedicines() {
    return [
      const Medicine(
        id: '1',
        name: 'Tablet- Acipro',
        quantity: 'Box',
        brand: 'Square',
        regularPrice: 500.00,
        discountPrice: 410.00,
        imageUrl:
            'https://via.placeholder.com/150x150/E3F2FD/1976D2?text=ACIPRO',
        description: 'Pain relief and fever reducer',
        requiresPrescription: false,
        quantityOptions: [1, 2, 3, 5, 10, 15, 20, 30],
      ),
      const Medicine(
        id: '2',
        name: 'Tablet- Amox',
        quantity: 'Box',
        brand: 'Square',
        regularPrice: 630.00,
        discountPrice: 360.00,
        imageUrl: 'https://via.placeholder.com/150x150/FFF3E0/F57C00?text=AMOX',
        description: 'Antibiotic for bacterial infections',
        requiresPrescription: true,
        quantityOptions: [1, 2, 3, 5, 10],
      ),
      const Medicine(
        id: '3',
        name: 'Syrup- Asthalin',
        quantity: 'Bottle',
        brand: 'Renata',
        regularPrice: 360.00,
        discountPrice: 230.00,
        imageUrl:
            'https://via.placeholder.com/150x150/E8F5E8/4CAF50?text=SYRUP',
        description: 'Antihistamine for allergies',
        requiresPrescription: false,
        quantityOptions: [1, 2, 3, 4, 5, 6],
      ),
      const Medicine(
        id: '4',
        name: 'Capsule- Amoxicillin',
        quantity: 'Strip',
        brand: 'Beximco',
        regularPrice: 600.00,
        discountPrice: 410.00,
        imageUrl: 'https://via.placeholder.com/150x150/FFF8E1/FFC107?text=CAPS',
        description: 'Proton pump inhibitor for acid reflux',
        requiresPrescription: false,
        quantityOptions: [1, 2, 3, 4, 5, 10, 15, 20],
      ),
      const Medicine(
        id: '5',
        name: 'Tablet- Napa',
        quantity: 'Box',
        brand: 'Beximco',
        regularPrice: 50.00,
        imageUrl: 'https://via.placeholder.com/150x150/E1F5FE/0277BD?text=NAPA',
        description: 'Paracetamol for pain and fever',
        requiresPrescription: false,
        quantityOptions: [1, 3, 5, 10, 20, 30, 50],
      ),
      const Medicine(
        id: '6',
        name: 'Syrup- Reneta-B',
        quantity: 'Bottle',
        brand: 'Renata',
        regularPrice: 630.00,
        discountPrice: 500.00,
        imageUrl:
            'https://via.placeholder.com/150x150/FCE4EC/E91E63?text=SYRUP',
        description: 'Vitamin B complex syrup',
        requiresPrescription: false,
        quantityOptions: [1, 2, 3, 4, 5],
      ),
      const Medicine(
        id: '7',
        name: 'Tablet- Vitamin D3',
        quantity: 'Bottle',
        brand: 'HealthKart',
        regularPrice: 1250.00,
        discountPrice: 990.00,
        imageUrl: 'https://via.placeholder.com/150x150/FFF9C4/F9A825?text=VIT',
        description: 'Vitamin D3 supplement',
        requiresPrescription: false,
        quantityOptions: [1, 2, 3, 6, 12],
      ),
      const Medicine(
        id: '8',
        name: 'Tablet- Ace',
        quantity: 'Box',
        brand: 'Square',
        regularPrice: 410.00,
        imageUrl: 'https://via.placeholder.com/150x150/F3E5F5/8E24AA?text=ACE',
        description: 'ACE inhibitor for blood pressure',
        requiresPrescription: true,
        quantityOptions: [1, 2, 3, 4, 5, 6, 10],
      ),
    ];
  }

  /// Extract unique brands from medicines list
  List<String> _extractBrands(List<Medicine> medicines) {
    final brands = medicines.map((medicine) => medicine.brand).toSet().toList();
    brands.sort();
    return brands;
  }
}
