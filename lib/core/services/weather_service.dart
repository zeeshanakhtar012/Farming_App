import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

/// Weather Service
/// Fetches weather data from OpenWeather API
class WeatherService {
  final GetStorage _storage = GetStorage();
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // API Key - Should be stored securely in production
  // For demo, you can set it via storage or environment variable
  String get _apiKey => _storage.read('weather_api_key') ?? 'your_api_key_here';

  /// Get current weather by coordinates
  /// [latitude] - Latitude of the location
  /// [longitude] - Longitude of the location
  Future<Map<String, dynamic>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final String url =
          '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw 'Failed to load weather data: ${response.statusCode}';
      }
    } catch (e) {
      // Return mock data if API fails (for demo purposes)
      return _getMockWeatherData();
    }
  }

  /// Get weather forecast (5 days)
  /// [latitude] - Latitude of the location
  /// [longitude] - Longitude of the location
  Future<Map<String, dynamic>> getWeatherForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final String url =
          '$_baseUrl/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw 'Failed to load forecast data: ${response.statusCode}';
      }
    } catch (e) {
      // Return mock data if API fails
      return _getMockForecastData();
    }
  }

  /// Get weather by city name
  /// [cityName] - Name of the city
  Future<Map<String, dynamic>> getWeatherByCity(String cityName) async {
    try {
      final String url =
          '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw 'Failed to load weather data: ${response.statusCode}';
      }
    } catch (e) {
      return _getMockWeatherData();
    }
  }

  /// Mock weather data (for demo when API is not available)
  Map<String, dynamic> _getMockWeatherData() {
    return {
      'main': {
        'temp': 28.5,
        'feels_like': 30.2,
        'temp_min': 26.0,
        'temp_max': 32.0,
        'pressure': 1013,
        'humidity': 65,
      },
      'weather': [
        {'main': 'Clear', 'description': 'clear sky', 'icon': '01d'},
      ],
      'wind': {'speed': 3.5, 'deg': 180},
      'clouds': {'all': 10},
      'dt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'name': 'Sample City',
    };
  }

  /// Mock forecast data
  Map<String, dynamic> _getMockForecastData() {
    return {
      'list': [
        {
          'dt':
              DateTime.now()
                  .add(const Duration(days: 1))
                  .millisecondsSinceEpoch ~/
              1000,
          'main': {'temp': 29.0, 'humidity': 60},
          'weather': [
            {'main': 'Clouds', 'description': 'partly cloudy'},
          ],
          'pop': 0.2, // Probability of precipitation
        },
        {
          'dt':
              DateTime.now()
                  .add(const Duration(days: 2))
                  .millisecondsSinceEpoch ~/
              1000,
          'main': {'temp': 27.5, 'humidity': 70},
          'weather': [
            {'main': 'Rain', 'description': 'light rain'},
          ],
          'pop': 0.6,
        },
      ],
    };
  }

  /// Set API Key
  void setApiKey(String apiKey) {
    _storage.write('weather_api_key', apiKey);
  }
}
