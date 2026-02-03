import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firebase_service.dart';
import '../models/market_price_model.dart';

/// Market Prices Controller
/// Manages market price data and filtering
class MarketPricesController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  // Observable state
  final RxBool isLoading = false.obs;
  final RxList<MarketPriceModel> prices = <MarketPriceModel>[].obs;
  final RxList<MarketPriceModel> filteredPrices = <MarketPriceModel>[].obs;
  final RxString selectedCropFilter = 'All'.obs;
  final RxString selectedLocationFilter = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxString errorMessage = ''.obs;

  // Available filters
  final List<String> cropTypes = [
    'All',
    'Wheat',
    'Rice',
    'Cotton',
    'Sugarcane',
    'Corn',
    'Potato',
  ];
  final List<String> locations = [
    'All',
    'Lahore',
    'Karachi',
    'Islamabad',
    'Faisalabad',
    'Multan',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchPrices();
  }

  /// Fetch market prices from Firestore
  Future<void> fetchPrices() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Try to fetch from Firestore
      try {
        final QuerySnapshot snapshot = await _firebaseService.getCollection(
          'market_prices',
        );

        if (snapshot.docs.isNotEmpty) {
          prices.value = snapshot.docs.map((doc) {
            return MarketPriceModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        } else {
          // Use mock data if Firestore is empty
          prices.value = _getMockPrices();
        }
      } catch (e) {
        // Use mock data if Firestore fails
        prices.value = _getMockPrices();
      }

      applyFilters();
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Error fetching prices: ${e.toString()}';
      prices.value = _getMockPrices();
      applyFilters();
      isLoading.value = false;
    }
  }

  /// Apply filters to prices
  void applyFilters() {
    filteredPrices.value = prices.where((price) {
      // Crop filter
      if (selectedCropFilter.value != 'All' &&
          price.cropName != selectedCropFilter.value) {
        return false;
      }

      // Location filter
      if (selectedLocationFilter.value != 'All' &&
          price.location != selectedLocationFilter.value) {
        return false;
      }

      // Search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        if (!price.cropName.toLowerCase().contains(query) &&
            !price.location.toLowerCase().contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Update crop filter
  void setCropFilter(String crop) {
    selectedCropFilter.value = crop;
    applyFilters();
  }

  /// Update location filter
  void setLocationFilter(String location) {
    selectedLocationFilter.value = location;
    applyFilters();
  }

  /// Update search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  /// Get mock market prices (for demo)
  List<MarketPriceModel> _getMockPrices() {
    final now = DateTime.now();
    return [
      MarketPriceModel(
        priceId: '1',
        cropName: 'Wheat',
        price: 3500.0,
        unit: 'per quintal',
        location: 'Lahore',
        date: now,
      ),
      MarketPriceModel(
        priceId: '2',
        cropName: 'Rice',
        price: 180.0,
        unit: 'per kg',
        location: 'Karachi',
        date: now,
      ),
      MarketPriceModel(
        priceId: '3',
        cropName: 'Cotton',
        price: 8500.0,
        unit: 'per maund',
        location: 'Multan',
        date: now,
      ),
      MarketPriceModel(
        priceId: '4',
        cropName: 'Sugarcane',
        price: 200.0,
        unit: 'per maund',
        location: 'Faisalabad',
        date: now,
      ),
      MarketPriceModel(
        priceId: '5',
        cropName: 'Corn',
        price: 120.0,
        unit: 'per kg',
        location: 'Lahore',
        date: now,
      ),
      MarketPriceModel(
        priceId: '6',
        cropName: 'Potato',
        price: 60.0,
        unit: 'per kg',
        location: 'Islamabad',
        date: now,
      ),
      MarketPriceModel(
        priceId: '7',
        cropName: 'Wheat',
        price: 3450.0,
        unit: 'per quintal',
        location: 'Karachi',
        date: now,
      ),
      MarketPriceModel(
        priceId: '8',
        cropName: 'Rice',
        price: 175.0,
        unit: 'per kg',
        location: 'Lahore',
        date: now,
      ),
    ];
  }
}
