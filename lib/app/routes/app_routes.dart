/// Application Routes
/// Contains all route names as constants for type-safe navigation
class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // Initial Routes
  static const String SPLASH = '/splash';
  static const String ONBOARDING = '/onboarding';

  // Authentication Routes
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String FORGOT_PASSWORD = '/forgot-password';

  // Main App Routes
  static const String HOME = '/home';
  static const String DASHBOARD = '/dashboard';

  // Feature Routes
  static const String CROP_RECOMMENDATION = '/crop-recommendation';
  static const String WEATHER = '/weather';
  static const String DISEASE_DETECTION = '/disease-detection';
  static const String MARKET_PRICES = '/market-prices';
  static const String CALENDAR = '/calendar';
  static const String EXPENSE_TRACKER = '/expense-tracker';

  // Profile & Settings
  static const String PROFILE = '/profile';
  static const String SETTINGS = '/settings';
}
