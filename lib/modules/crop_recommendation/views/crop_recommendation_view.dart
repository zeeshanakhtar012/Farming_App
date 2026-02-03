import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/crop_recommendation_controller.dart';

/// Crop Recommendation View
/// Allows users to get crop recommendations based on location, soil type, and season
class CropRecommendationView extends StatelessWidget {
  const CropRecommendationView({super.key});

  @override
  Widget build(BuildContext context) {
    final CropRecommendationController controller =
        Get.find<CropRecommendationController>();

    return Scaffold(
      appBar: AppBar(title: Text('crop_recommendation'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Select Criteria',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),

                    // Soil Type Dropdown
                    Obx(
                      () => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'select_soil_type'.tr,
                          prefixIcon: const Icon(Icons.landscape),
                        ),
                        value: controller.selectedSoilType.value.isEmpty
                            ? null
                            : controller.selectedSoilType.value,
                        items: controller.soilTypes.map((soilType) {
                          return DropdownMenuItem(
                            value: soilType,
                            child: Text(soilType),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedSoilType.value = value ?? '';
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Season Dropdown
                    Obx(
                      () => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'select_season'.tr,
                          prefixIcon: const Icon(Icons.wb_sunny),
                        ),
                        value: controller.selectedSeason.value.isEmpty
                            ? null
                            : controller.selectedSeason.value,
                        items: controller.seasons.map((season) {
                          return DropdownMenuItem(
                            value: season,
                            child: Text(season),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedSeason.value = value ?? '';
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Get Recommendations Button
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.getRecommendations(),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text('get_recommendations'.tr),
                      ),
                    ),

                    // Error Message
                    Obx(
                      () => controller.errorMessage.value.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                controller.errorMessage.value,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Recommendations Section
            Obx(
              () => controller.recommendedCrops.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'recommended_crops'.tr,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        ...controller.recommendedCrops.map(
                          (crop) => _CropCard(crop: crop),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Crop Card Widget
class _CropCard extends StatelessWidget {
  final dynamic crop;

  const _CropCard({required this.crop});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: const Icon(Icons.eco, color: Colors.green),
        title: Text(
          crop.cropName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Growth Period: ${crop.growthPeriod} days'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (crop.description != null) ...[
                  Text(
                    crop.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                ],
                _InfoRow(label: 'expected_yield'.tr, value: crop.expectedYield),
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'water_requirement'.tr,
                  value: crop.waterRequirement,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'fertilizer_suggestions'.tr,
                  value: crop.fertilizers.join(', '),
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'Suitable Soil Types',
                  value: crop.soilTypes.join(', '),
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'Suitable Seasons',
                  value: crop.seasons.join(', '),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Info Row Widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
