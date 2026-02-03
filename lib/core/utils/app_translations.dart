import 'package:get/get.dart';

/// Application Translations
/// Handles multi-language support (English and Urdu)
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // App Name
      'app_name': 'Smart Farming',

      // Authentication
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'already_have_account': 'Already have an account?',
      'dont_have_account': "Don't have an account?",
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'logout': 'Logout',

      // Home
      'home': 'Home',
      'dashboard': 'Dashboard',
      'welcome': 'Welcome',

      // Features
      'crop_recommendation': 'Crop Recommendation',
      'weather_forecast': 'Weather Forecast',
      'disease_detection': 'Disease Detection',
      'market_prices': 'Market Prices',
      'farming_calendar': 'Farming Calendar',
      'expense_tracker': 'Expense Tracker',

      // Common
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'search': 'Search',
      'filter': 'Filter',
      'submit': 'Submit',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'ok': 'OK',

      // Crop Recommendation
      'select_location': 'Select Location',
      'select_soil_type': 'Select Soil Type',
      'select_season': 'Select Season',
      'get_recommendations': 'Get Recommendations',
      'recommended_crops': 'Recommended Crops',
      'expected_yield': 'Expected Yield',
      'fertilizer_suggestions': 'Fertilizer Suggestions',

      // Weather
      'temperature': 'Temperature',
      'humidity': 'Humidity',
      'rain_probability': 'Rain Probability',
      'weather_alerts': 'Weather Alerts',

      // Disease Detection
      'upload_image': 'Upload Image',
      'capture_image': 'Capture Image',
      'disease_name': 'Disease Name',
      'severity': 'Severity',
      'treatment': 'Treatment',

      // Market Prices
      'crop_name': 'Crop Name',
      'price': 'Price',
      'location': 'Location',
      'compare_prices': 'Compare Prices',

      // Calendar
      'sowing': 'Sowing',
      'fertilizing': 'Fertilizing',
      'irrigation': 'Irrigation',
      'harvesting': 'Harvesting',
      'add_event': 'Add Event',
      'event_title': 'Event Title',
      'event_date': 'Event Date',

      // Expense Tracker
      'total_cost': 'Total Cost',
      'estimated_profit': 'Estimated Profit',
      'seeds_cost': 'Seeds Cost',
      'fertilizer_cost': 'Fertilizer Cost',
      'labor_cost': 'Labor Cost',
      'other_costs': 'Other Costs',
    },
    'ur_PK': {
      // App Name
      'app_name': 'ذہین کاشتکاری',

      // Authentication
      'login': 'لاگ ان',
      'register': 'رجسٹر کریں',
      'email': 'ای میل',
      'password': 'پاس ورڈ',
      'confirm_password': 'پاس ورڈ کی تصدیق کریں',
      'forgot_password': 'پاس ورڈ بھول گئے؟',
      'already_have_account': 'پہلے سے اکاؤنٹ ہے؟',
      'dont_have_account': 'اکاؤنٹ نہیں ہے؟',
      'sign_in': 'سائن ان',
      'sign_up': 'سائن اپ',
      'logout': 'لاگ آؤٹ',

      // Home
      'home': 'ہوم',
      'dashboard': 'ڈیش بورڈ',
      'welcome': 'خوش آمدید',

      // Features
      'crop_recommendation': 'فصل کی سفارش',
      'weather_forecast': 'موسمی پیشین گوئی',
      'disease_detection': 'بیماری کی تشخیص',
      'market_prices': 'مارکیٹ کی قیمتیں',
      'farming_calendar': 'کاشتکاری کیلنڈر',
      'expense_tracker': 'خرچ ٹریکر',

      // Common
      'save': 'محفوظ کریں',
      'cancel': 'منسوخ',
      'delete': 'حذف کریں',
      'edit': 'ترمیم',
      'add': 'شامل کریں',
      'search': 'تلاش',
      'filter': 'فلٹر',
      'submit': 'جمع کریں',
      'loading': 'لوڈ ہو رہا ہے...',
      'error': 'خرابی',
      'success': 'کامیابی',
      'ok': 'ٹھیک ہے',

      // Crop Recommendation
      'select_location': 'مقام منتخب کریں',
      'select_soil_type': 'مٹی کی قسم منتخب کریں',
      'select_season': 'موسم منتخب کریں',
      'get_recommendations': 'سفارشات حاصل کریں',
      'recommended_crops': 'تجویز کردہ فصلیں',
      'expected_yield': 'متوقع پیداوار',
      'fertilizer_suggestions': 'کھاد کی تجاویز',

      // Weather
      'temperature': 'درجہ حرارت',
      'humidity': 'نمی',
      'rain_probability': 'بارش کی امکان',
      'weather_alerts': 'موسمی انتباہات',

      // Disease Detection
      'upload_image': 'تصویر اپ لوڈ کریں',
      'capture_image': 'تصویر لیں',
      'disease_name': 'بیماری کا نام',
      'severity': 'شدت',
      'treatment': 'علاج',

      // Market Prices
      'crop_name': 'فصل کا نام',
      'price': 'قیمت',
      'location': 'مقام',
      'compare_prices': 'قیمتوں کا موازنہ',

      // Calendar
      'sowing': 'بونے',
      'fertilizing': 'کھاد ڈالنا',
      'irrigation': 'آبپاشی',
      'harvesting': 'کٹائی',
      'add_event': 'ایونٹ شامل کریں',
      'event_title': 'ایونٹ کا عنوان',
      'event_date': 'ایونٹ کی تاریخ',

      // Expense Tracker
      'total_cost': 'کل لاگت',
      'estimated_profit': 'متوقع منافع',
      'seeds_cost': 'بیجوں کی لاگت',
      'fertilizer_cost': 'کھاد کی لاگت',
      'labor_cost': 'مزدوری کی لاگت',
      'other_costs': 'دیگر اخراجات',
    },
  };
}
