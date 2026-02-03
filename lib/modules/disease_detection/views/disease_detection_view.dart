import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/disease_detection_controller.dart';

/// Disease Detection View
/// Allows users to upload/capture images for disease detection
class DiseaseDetectionView extends StatelessWidget {
  const DiseaseDetectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final DiseaseDetectionController controller =
        Get.find<DiseaseDetectionController>();

    return Scaffold(
      appBar: AppBar(title: Text('disease_detection'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Capture or upload a clear image of the affected leaf for disease detection.',
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Image Selection Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.pickImageFromGallery(),
                    icon: const Icon(Icons.photo_library),
                    label: Text('upload_image'.tr),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.captureImageFromCamera(),
                    icon: const Icon(Icons.camera_alt),
                    label: Text('capture_image'.tr),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Selected Image Preview
            Obx(
              () => controller.selectedImage.value != null
                  ? Card(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              controller.selectedImage.value!,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.detectDisease(),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Detect Disease'),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No image selected',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 24),

            // Error Message
            Obx(
              () => controller.errorMessage.value.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // Detection Result
            Obx(
              () => controller.detectedDisease.value != null
                  ? _DiseaseResultCard(
                      disease: controller.detectedDisease.value!,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Disease Result Card Widget
class _DiseaseResultCard extends StatelessWidget {
  final dynamic disease;

  const _DiseaseResultCard({required this.disease});

  @override
  Widget build(BuildContext context) {
    Color severityColor;
    switch (disease.severity.toLowerCase()) {
      case 'high':
        severityColor = Colors.red;
        break;
      case 'medium':
        severityColor = Colors.orange;
        break;
      case 'low':
        severityColor = Colors.yellow.shade700;
        break;
      default:
        severityColor = Colors.green;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bug_report, color: severityColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    disease.diseaseName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    disease.severity,
                    style: TextStyle(
                      color: severityColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Confidence: ${(disease.confidence * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (disease.description != null) ...[
              const SizedBox(height: 16),
              Text(
                disease.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Text('treatment'.tr, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...disease.treatmentRecommendations.map(
              (treatment) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(treatment)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
