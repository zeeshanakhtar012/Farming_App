/// Weather Model
/// Represents weather data structure
class WeatherModel {
  final double temperature;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final int humidity;
  final int pressure;
  final String description;
  final String mainCondition;
  final String icon;
  final double windSpeed;
  final int? rainProbability;
  final DateTime dateTime;
  final String? cityName;

  WeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.pressure,
    required this.description,
    required this.mainCondition,
    required this.icon,
    required this.windSpeed,
    this.rainProbability,
    required this.dateTime,
    this.cityName,
  });

  /// Create WeatherModel from API response
  factory WeatherModel.fromApi(Map<String, dynamic> data) {
    final main = data['main'] as Map<String, dynamic>;
    final weather = (data['weather'] as List).first as Map<String, dynamic>;
    final wind = data['wind'] as Map<String, dynamic>?;

    return WeatherModel(
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      minTemp: (main['temp_min'] as num).toDouble(),
      maxTemp: (main['temp_max'] as num).toDouble(),
      humidity: main['humidity'] as int,
      pressure: main['pressure'] as int,
      description: weather['description'] as String,
      mainCondition: weather['main'] as String,
      icon: weather['icon'] as String,
      windSpeed: wind != null ? (wind['speed'] as num).toDouble() : 0.0,
      rainProbability: data['pop'] as int?,
      dateTime: DateTime.fromMillisecondsSinceEpoch((data['dt'] as int) * 1000),
      cityName: data['name'] as String?,
    );
  }

  /// Get weather alert based on conditions
  String? getWeatherAlert() {
    if (rainProbability != null && rainProbability! > 70) {
      return 'Heavy rain expected. Avoid field work.';
    }
    if (temperature > 40) {
      return 'Extreme heat warning. Ensure proper irrigation.';
    }
    if (temperature < 5) {
      return 'Frost warning. Protect sensitive crops.';
    }
    if (windSpeed > 15) {
      return 'Strong winds expected. Secure farm equipment.';
    }
    return null;
  }
}

/// Forecast Model
/// Represents weather forecast data
class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final int humidity;
  final String description;
  final int? rainProbability;

  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.humidity,
    required this.description,
    this.rainProbability,
  });

  factory ForecastModel.fromApi(Map<String, dynamic> data) {
    final main = data['main'] as Map<String, dynamic>;
    final weather = (data['weather'] as List).first as Map<String, dynamic>;

    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch((data['dt'] as int) * 1000),
      temperature: (main['temp'] as num).toDouble(),
      humidity: main['humidity'] as int,
      description: weather['description'] as String,
      rainProbability: (data['pop'] as num?)?.toInt(),
    );
  }
}
