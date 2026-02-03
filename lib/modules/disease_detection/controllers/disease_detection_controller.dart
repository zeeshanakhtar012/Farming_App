import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/firebase_service.dart';
import '../models/disease_model.dart';

/// Disease Detection Controller
/// Handles image capture/upload and disease detection logic
class DiseaseDetectionController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final ImagePicker _imagePicker = ImagePicker();

  // Observable state
  final RxBool isLoading = false.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<DiseaseModel?> detectedDisease = Rx<DiseaseModel?>(null);
  final RxString errorMessage = ''.obs;

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        detectedDisease.value = null;
        errorMessage.value = '';
      }
    } catch (e) {
      errorMessage.value = 'Error picking image: ${e.toString()}';
    }
  }

  /// Capture image from camera
  Future<void> captureImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        detectedDisease.value = null;
        errorMessage.value = '';
      }
    } catch (e) {
      errorMessage.value = 'Error capturing image: ${e.toString()}';
    }
  }

  /// Detect disease from image
  /// This is a rule-based/mock detection system
  Future<void> detectDisease() async {
    try {
      if (selectedImage.value == null) {
        errorMessage.value = 'Please select or capture an image first';
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      // Upload image to Firebase Storage
      final imageBytes = await selectedImage.value!.readAsBytes();
      final userId = _firebaseService.currentUser?.uid ?? 'anonymous';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'disease_$userId\_$timestamp.jpg';

      String imageUrl;
      try {
        imageUrl = await _firebaseService.uploadFile(
          'disease_images',
          fileName,
          imageBytes,
        );
      } catch (e) {
        // If upload fails, continue with mock detection
        imageUrl = '';
      }

      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Rule-based disease detection (mock)
      // In a real app, this would use ML model
      var disease = _detectDiseaseRuleBased();

      // Update with image URL if upload was successful
      if (imageUrl.isNotEmpty) {
        disease = DiseaseModel(
          diseaseId: disease.diseaseId,
          diseaseName: disease.diseaseName,
          severity: disease.severity,
          treatmentRecommendations: disease.treatmentRecommendations,
          description: disease.description,
          imageUrl: imageUrl,
          confidence: disease.confidence,
        );
      }

      detectedDisease.value = disease;

      // Save detection result to Firestore
      try {
        await _firebaseService.addDocument('disease_detections', {
          'userId': userId,
          'diseaseName': disease.diseaseName,
          'severity': disease.severity,
          'imageUrl': imageUrl,
          'confidence': disease.confidence,
          'detectedAt': DateTime.now(),
        });
      } catch (e) {
        // Continue even if Firestore save fails
        print('Error saving detection: $e');
      }

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Error detecting disease: ${e.toString()}';
      isLoading.value = false;
    }
  }

  /// Rule-based disease detection (mock)
  /// In production, this would use a trained ML model
  DiseaseModel _detectDiseaseRuleBased() {
    // Mock detection - randomly selects a disease
    // In real implementation, this would analyze the image
    final mockDiseases = [
      DiseaseModel(
        diseaseId: '1',
        diseaseName: 'Leaf Rust',
        severity: 'Medium',
        treatmentRecommendations: [
          'Apply fungicide containing propiconazole',
          'Remove and destroy infected leaves',
          'Ensure proper spacing for air circulation',
          'Water plants at the base, avoid wetting leaves',
        ],
        description:
            'Leaf rust appears as small, orange-brown pustules on the upper surface of leaves.',
        confidence: 0.75,
      ),
      DiseaseModel(
        diseaseId: '2',
        diseaseName: 'Powdery Mildew',
        severity: 'Low',
        treatmentRecommendations: [
          'Apply sulfur-based fungicide',
          'Increase air circulation',
          'Reduce humidity around plants',
          'Remove affected plant parts',
        ],
        description:
            'Powdery mildew appears as white or gray powdery spots on leaves and stems.',
        confidence: 0.68,
      ),
      DiseaseModel(
        diseaseId: '3',
        diseaseName: 'Bacterial Blight',
        severity: 'High',
        treatmentRecommendations: [
          'Apply copper-based bactericide',
          'Remove and destroy infected plants',
          'Avoid overhead watering',
          'Practice crop rotation',
        ],
        description:
            'Bacterial blight causes water-soaked lesions that turn brown and necrotic.',
        confidence: 0.82,
      ),
      DiseaseModel(
        diseaseId: '4',
        diseaseName: 'Healthy Leaf',
        severity: 'None',
        treatmentRecommendations: [
          'Continue regular care',
          'Monitor for any changes',
          'Maintain proper watering schedule',
        ],
        description: 'The leaf appears healthy with no signs of disease.',
        confidence: 0.90,
      ),
    ];

    // Return a random disease (in real app, this would be ML prediction)
    return mockDiseases[DateTime.now().millisecond % mockDiseases.length];
  }

  /// Clear selected image and detection result
  void clearDetection() {
    selectedImage.value = null;
    detectedDisease.value = null;
    errorMessage.value = '';
  }
}
