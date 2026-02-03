import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

/// Calendar Binding
class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarController>(() => CalendarController());
  }
}
