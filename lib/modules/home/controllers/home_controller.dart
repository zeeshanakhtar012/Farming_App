import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

/// Home Controller
/// Manages home screen state and navigation
class HomeController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  // Current page index for bottom navigation
  final RxInt currentIndex = 0.obs;

  // Get current user
  get currentUser => _authController.currentUser.value;

  /// Change bottom navigation index
  void changeIndex(int index) {
    currentIndex.value = index;
  }

  /// Logout user
  Future<void> logout() async {
    await _authController.signOut();
  }
}
