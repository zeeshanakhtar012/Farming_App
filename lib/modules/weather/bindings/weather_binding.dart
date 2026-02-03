import 'package:get/get.dart';
import '../controllers/weather_controller.dart';

/// Weather Binding
class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherController>(() => WeatherController());
  }
}
