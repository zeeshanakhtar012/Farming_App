/// Disease Model
/// Represents crop disease detection result
class DiseaseModel {
  final String diseaseId;
  final String diseaseName;
  final String severity; // Low, Medium, High
  final List<String> treatmentRecommendations;
  final String? description;
  final String? imageUrl;
  final double confidence; // 0.0 to 1.0

  DiseaseModel({
    required this.diseaseId,
    required this.diseaseName,
    required this.severity,
    required this.treatmentRecommendations,
    this.description,
    this.imageUrl,
    required this.confidence,
  });

  /// Create DiseaseModel from Firestore
  factory DiseaseModel.fromFirestore(
    Map<String, dynamic> data,
    String diseaseId,
  ) {
    return DiseaseModel(
      diseaseId: diseaseId,
      diseaseName: data['diseaseName'] ?? '',
      severity: data['severity'] ?? 'Low',
      treatmentRecommendations: List<String>.from(data['treatment'] ?? []),
      description: data['description'],
      imageUrl: data['imageUrl'],
      confidence: (data['confidence'] ?? 0.0) as double,
    );
  }

  /// Convert DiseaseModel to Map
  Map<String, dynamic> toMap() {
    return {
      'diseaseName': diseaseName,
      'severity': severity,
      'treatment': treatmentRecommendations,
      if (description != null) 'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'confidence': confidence,
    };
  }
}
