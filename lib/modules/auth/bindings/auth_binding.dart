import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// Authentication Binding
/// Provides AuthController to views
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
