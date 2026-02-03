import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firebase_service.dart';
import '../models/crop_model.dart';

/// Crop Recommendation Controller
/// Manages crop recommendation logic and state
class CropRecommendationController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  // Observable state
  final RxBool isLoading = false.obs;
  final RxList<CropModel> recommendedCrops = <CropModel>[].obs;
  final RxString selectedLocation = ''.obs;
  final RxString selectedSoilType = ''.obs;
  final RxString selectedSeason = ''.obs;
  final RxString errorMessage = ''.obs;

  // Available options
  final List<String> soilTypes = [
    'Loamy',
    'Clay',
    'Sandy',
    'Silty',
    'Peaty',
    'Chalky',
  ];

  final List<String> seasons = ['Spring', 'Summer', 'Monsoon', 'Winter'];

  /// Get crop recommendations based on inputs
  Future<void> getRecommendations() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate inputs
      if (selectedSoilType.value.isEmpty || selectedSeason.value.isEmpty) {
        errorMessage.value = 'Please select soil type and season';
        isLoading.value = false;
        return;
      }

      // Fetch all crops from Firestore
      final QuerySnapshot snapshot = await _firebaseService.getCollection(
        'crop_recommendations',
      );

      // Filter crops based on soil type and season
      final List<CropModel> filteredCrops = [];

      for (var doc in snapshot.docs) {
        final crop = CropModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );

        // Check if crop matches selected criteria
        if (crop.soilTypes.contains(selectedSoilType.value) &&
            crop.seasons.contains(selectedSeason.value)) {
          filteredCrops.add(crop);
        }
      }

      // If no crops found in Firestore, use mock data
      if (filteredCrops.isEmpty) {
        recommendedCrops.value = _getMockRecommendations();
      } else {
        recommendedCrops.value = filteredCrops;
      }

      isLoading.value = false;
    } catch (e) {
      // Use mock data if Firestore fails
      recommendedCrops.value = _getMockRecommendations();
      isLoading.value = false;
    }
  }

  /// Get mock crop recommendations (for demo)
  List<CropModel> _getMockRecommendations() {
    return [
      CropModel(
        cropId: '1',
        cropName: 'Wheat',
        soilTypes: ['Loamy', 'Clay'],
        seasons: ['Winter', 'Spring'],
        expectedYield: '40-50 quintals/hectare',
        fertilizers: ['Urea', 'DAP', 'Potash'],
        waterRequirement: 'Moderate',
        growthPeriod: 120,
        description: 'Wheat is a staple crop suitable for winter season.',
      ),
      CropModel(
        cropId: '2',
        cropName: 'Rice',
        soilTypes: ['Clay', 'Silty'],
        seasons: ['Monsoon', 'Summer'],
        expectedYield: '50-60 quintals/hectare',
        fertilizers: ['Urea', 'Super Phosphate'],
        waterRequirement: 'High',
        growthPeriod: 150,
        description:
            'Rice requires plenty of water and is ideal for monsoon season.',
      ),
      CropModel(
        cropId: '3',
        cropName: 'Cotton',
        soilTypes: ['Loamy', 'Sandy'],
        seasons: ['Summer', 'Monsoon'],
        expectedYield: '15-20 quintals/hectare',
        fertilizers: ['Urea', 'DAP', 'Zinc'],
        waterRequirement: 'Moderate',
        growthPeriod: 180,
        description: 'Cotton is a cash crop suitable for warm climates.',
      ),
      CropModel(
        cropId: '4',
        cropName: 'Sugarcane',
        soilTypes: ['Loamy', 'Clay'],
        seasons: ['Spring', 'Summer'],
        expectedYield: '700-800 quintals/hectare',
        fertilizers: ['Urea', 'DAP', 'Potash'],
        waterRequirement: 'High',
        growthPeriod: 365,
        description:
            'Sugarcane is a long-duration crop requiring consistent water supply.',
      ),
    ];
  }

  /// Clear selections
  void clearSelections() {
    selectedLocation.value = '';
    selectedSoilType.value = '';
    selectedSeason.value = '';
    recommendedCrops.clear();
    errorMessage.value = '';
  }
}
