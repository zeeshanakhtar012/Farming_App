import 'package:get/get.dart';
import '../controllers/disease_detection_controller.dart';

/// Disease Detection Binding
class DiseaseDetectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiseaseDetectionController>(() => DiseaseDetectionController());
  }
}
