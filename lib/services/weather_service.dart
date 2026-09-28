import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';

class WeatherService {
  // Base URL untuk Open-Meteo API
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// Mengambil data cuaca dari Open-Meteo API
  /// Menggunakan koordinat latitude dan longitude
  Future<Weather> getWeather(double latitude, double longitude) async {
    // Parameter yang diminta dari API
    final response = await http.get(
      Uri.parse('$_baseUrl?latitude=$latitude&longitude=$longitude&current_weather=true'),
    );

    if (response.statusCode == 200) {
      // Parse JSON response
      final Map<String, dynamic> data = json.decode(response.body);
      
      // Ambil data current_weather dari response
      final currentWeather = data['current_weather'] as Map<String, dynamic>;
      
      // Buat object Weather dari data API
      return Weather.fromJson(currentWeather);
    } else {
      throw Exception('Gagal mengambil data cuaca: ${response.statusCode}');
    }
  }
}
