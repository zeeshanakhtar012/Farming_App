/// Crop Model
/// Represents crop recommendation data
class CropModel {
  final String cropId;
  final String cropName;
  final List<String> soilTypes;
  final List<String> seasons;
  final String expectedYield;
  final List<String> fertilizers;
  final String waterRequirement;
  final int growthPeriod; // in days
  final String? description;
  final String? imageUrl;

  CropModel({
    required this.cropId,
    required this.cropName,
    required this.soilTypes,
    required this.seasons,
    required this.expectedYield,
    required this.fertilizers,
    required this.waterRequirement,
    required this.growthPeriod,
    this.description,
    this.imageUrl,
  });

  /// Create CropModel from Firestore document
  factory CropModel.fromFirestore(Map<String, dynamic> data, String cropId) {
    return CropModel(
      cropId: cropId,
      cropName: data['cropName'] ?? '',
      soilTypes: List<String>.from(data['soilType'] ?? []),
      seasons: List<String>.from(data['season'] ?? []),
      expectedYield: data['expectedYield'] ?? '',
      fertilizers: List<String>.from(data['fertilizer'] ?? []),
      waterRequirement: data['waterRequirement'] ?? '',
      growthPeriod: data['growthPeriod'] ?? 0,
      description: data['description'],
      imageUrl: data['imageUrl'],
    );
  }

  /// Convert CropModel to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'cropName': cropName,
      'soilType': soilTypes,
      'season': seasons,
      'expectedYield': expectedYield,
      'fertilizer': fertilizers,
      'waterRequirement': waterRequirement,
      'growthPeriod': growthPeriod,
      if (description != null) 'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
