import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/services/weather_service.dart';
import '../models/weather_model.dart';

/// Weather Controller
/// Manages weather data and forecasts
class WeatherController extends GetxController {
  final WeatherService _weatherService = WeatherService();
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  // Observable state
  final RxBool isLoading = false.obs;
  final Rx<WeatherModel?> currentWeather = Rx<WeatherModel?>(null);
  final RxList<ForecastModel> forecast = <ForecastModel>[].obs;
  final RxString errorMessage = ''.obs;
  final RxString locationName = 'Loading...'.obs;

  // User location
  Position? _userPosition;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  /// Get user's current location
  Future<void> _getCurrentLocation() async {
    try {
      isLoading.value = true;

      // Check permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage.value = 'Location services are disabled';
        isLoading.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          errorMessage.value = 'Location permissions are denied';
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        errorMessage.value = 'Location permissions are permanently denied';
        isLoading.value = false;
        return;
      }

      // Get position
      _userPosition = await Geolocator.getCurrentPosition();

      // Fetch weather data
      await fetchWeather();
    } catch (e) {
      errorMessage.value = 'Error getting location: ${e.toString()}';
      isLoading.value = false;
    }
  }

  /// Fetch current weather
  Future<void> fetchWeather() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (_userPosition == null) {
        await _getCurrentLocation();
        return;
      }

      // Fetch current weather
      final weatherData = await _weatherService.getCurrentWeather(
        latitude: _userPosition!.latitude,
        longitude: _userPosition!.longitude,
      );

      currentWeather.value = WeatherModel.fromApi(weatherData);
      locationName.value = currentWeather.value?.cityName ?? 'Unknown Location';

      // Fetch forecast
      final forecastData = await _weatherService.getWeatherForecast(
        latitude: _userPosition!.latitude,
        longitude: _userPosition!.longitude,
      );

      if (forecastData['list'] != null) {
        final List<dynamic> list = forecastData['list'] as List<dynamic>;
        forecast.value = list
            .take(5) // Get next 5 forecasts
            .map((item) => ForecastModel.fromApi(item as Map<String, dynamic>))
            .toList();
      }

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Error fetching weather: ${e.toString()}';
      isLoading.value = false;
    }
  }

  /// Refresh weather data
  Future<void> refresh() async {
    await fetchWeather();
  }
}
