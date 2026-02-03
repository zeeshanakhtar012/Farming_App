import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/firebase_service.dart';

/// Splash Screen
/// Shows app logo and checks authentication state
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  /// Check authentication state and navigate accordingly
  Future<void> _checkAuthState() async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Show splash for 2 seconds

    final FirebaseService firebaseService = Get.find<FirebaseService>();
    final user = firebaseService.currentUser;

    if (user != null) {
      // User is logged in, go to home
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      // User is not logged in, go to login
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Icon(Icons.agriculture, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            // App Name
            Text(
              'Smart Farming',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
