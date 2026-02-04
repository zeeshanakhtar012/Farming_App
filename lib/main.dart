import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'core/utils/app_translations.dart';
import 'modules/auth/controllers/auth_controller.dart';

/// Main entry point of the application
/// Initializes Firebase, GetStorage, and sets up the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for local storage
  await GetStorage.init();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Firebase Service
  await Get.putAsync(() => FirebaseService().init());

  // Initialize Notification Service
  await NotificationService().init();
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Farming App',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Localization Configuration
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      translations: AppTranslations(),
      supportedLocales: const [Locale('en', 'US'), Locale('ur', 'PK')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Routing Configuration
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,

      // Default Transition
      defaultTransition: Transition.cupertino,
    );
  }
}
