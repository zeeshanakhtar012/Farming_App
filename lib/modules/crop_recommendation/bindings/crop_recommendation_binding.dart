import 'package:get/get.dart';
import '../controllers/crop_recommendation_controller.dart';

/// Crop Recommendation Binding
class CropRecommendationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CropRecommendationController>(
      () => CropRecommendationController(),
    );
  }
}
