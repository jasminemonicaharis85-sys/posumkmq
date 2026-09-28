/// Model untuk data cuaca dari Open-Meteo API
class Weather {
  final double temperature;
  final double windspeed;
  final int weathercode;

  Weather({
    required this.temperature,
    required this.windspeed,
    required this.weathercode,
  });

  /// Mengubah JSON dari API menjadi object Weather
  /// JSON yang diterima memiliki struktur:
  /// {
  ///   "temperature": 31.2,
  ///   "windspeed": 12.5,
  ///   "weathercode": 2
  /// }
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      windspeed: (json['windspeed'] as num?)?.toDouble() ?? 0.0,
      weathercode: json['weathercode'] as int? ?? 0,
    );
  }

  /// Mengubah object Weather menjadi JSON (untuk debugging atau testing)
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'windspeed': windspeed,
      'weathercode': weathercode,
    };
  }
}
