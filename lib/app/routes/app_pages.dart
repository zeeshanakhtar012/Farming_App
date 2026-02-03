import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/register_view.dart';
import '../../modules/auth/views/forgot_password_view.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/crop_recommendation/bindings/crop_recommendation_binding.dart';
import '../../modules/crop_recommendation/views/crop_recommendation_view.dart';
import '../../modules/weather/bindings/weather_binding.dart';
import '../../modules/weather/views/weather_view.dart';
import '../../modules/disease_detection/bindings/disease_detection_binding.dart';
import '../../modules/disease_detection/views/disease_detection_view.dart';
import '../../modules/market_prices/bindings/market_prices_binding.dart';
import '../../modules/market_prices/views/market_prices_view.dart';
import '../../modules/calendar/bindings/calendar_binding.dart';
import '../../modules/calendar/views/calendar_view.dart';
import '../../modules/expense_tracker/bindings/expense_tracker_binding.dart';
import '../../modules/expense_tracker/views/expense_tracker_view.dart';
import '../../modules/splash/views/splash_view.dart';

/// Application Pages Configuration
/// Defines all routes and their corresponding views and bindings
class AppPages {
  AppPages._();

  static final List<GetPage> routes = [
    // Splash Screen
    GetPage(name: AppRoutes.SPLASH, page: () => const SplashView()),

    // Authentication Pages
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),

    // Home Page
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    // Feature Pages
    GetPage(
      name: AppRoutes.CROP_RECOMMENDATION,
      page: () => const CropRecommendationView(),
      binding: CropRecommendationBinding(),
    ),
    GetPage(
      name: AppRoutes.WEATHER,
      page: () => const WeatherView(),
      binding: WeatherBinding(),
    ),
    GetPage(
      name: AppRoutes.DISEASE_DETECTION,
      page: () => const DiseaseDetectionView(),
      binding: DiseaseDetectionBinding(),
    ),
    GetPage(
      name: AppRoutes.MARKET_PRICES,
      page: () => const MarketPricesView(),
      binding: MarketPricesBinding(),
    ),
    GetPage(
      name: AppRoutes.CALENDAR,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: AppRoutes.EXPENSE_TRACKER,
      page: () => const ExpenseTrackerView(),
      binding: ExpenseTrackerBinding(),
    ),
  ];
}
