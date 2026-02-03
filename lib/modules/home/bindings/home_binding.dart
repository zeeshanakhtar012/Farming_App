import 'package:get/get.dart';
import '../controllers/home_controller.dart';

/// Home Binding
/// Provides HomeController to views
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
