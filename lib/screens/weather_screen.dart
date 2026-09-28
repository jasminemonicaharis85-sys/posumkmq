import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Koordinat kota-kota di Indonesia
  final Map<String, Map<String, double>> cities = {
    'Jakarta': {
      'latitude': -6.2088,
      'longitude': 106.8456,
    },
    'Bandung': {
      'latitude': -6.9175,
      'longitude': 107.6191,
    },
    'Surabaya': {
      'latitude': -7.2575,
      'longitude': 112.7521,
    },
    'Yogyakarta': {
      'latitude': -7.7956,
      'longitude': 110.3695,
    },
  };

  // State untuk menyimpan data cuaca
  Weather? weather;
  String selectedCity = 'Jakarta';
  bool isLoading = false;
  String? errorMessage;
  DateTime? lastUpdated;

  // Instance WeatherService untuk mengambil data dari API
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    // Saat aplikasi pertama kali dibuka, ambil data cuaca kota default (Jakarta)
    _fetchWeather();
  }

  /// Mengambil data cuaca dari API
  /// Future digunakan karena ini operasi asynchronous
  /// async karena kita menggunakan await
  Future<void> _fetchWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Ambil koordinat kota yang dipilih
      final cityData = cities[selectedCity]!;
      final latitude = cityData['latitude']!;
      final longitude = cityData['longitude']!;

      // Request data cuaca dari API
      // await menunggu response sebelum melanjutkan
      final weatherData = await _weatherService.getWeather(latitude, longitude);

      setState(() {
        weather = weatherData;
        lastUpdated = DateTime.now();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  /// Mengubah weather code menjadi deskripsi yang mudah dipahami
  /// Berdasarkan kode WMO (World Meteorological Organization)
  String _getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return 'Cerah';
      case 1:
        return 'Sebagian Cerah';
      case 2:
        return 'Berawan Sebagian';
      case 3:
        return 'Mendung';
      case 45:
      case 48:
        return 'Berkabut';
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return 'Gerimis';
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        return 'Hujan';
      case 71:
      case 73:
      case 75:
      case 77:
        return 'Salju';
      case 80:
      case 81:
      case 82:
        return 'Hujan Singkat';
      case 85:
      case 86:
        return 'Salju Singkat';
      case 95:
        return 'Badai Petir';
      case 96:
      case 99:
        return 'Badai Petir dengan Hujan Es';
      default:
        return 'Kondisi cuaca tidak diketahui';
    }
  }

  /// Mengubah icon berdasarkan weather code
  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.cloud;
    if (code <= 48) return Icons.cloud_queue;
    if (code <= 67) return Icons.water_drop;
    if (code <= 77) return Icons.ac_unit;
    if (code <= 82) return Icons.grain;
    if (code <= 86) return Icons.severe_cold;
    return Icons.thunderstorm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Check'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Weather Check',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Cek cuaca sebelum berangkat sekolah',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Dropdown pemilihan kota
              const Text(
                'Pilih Kota',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedCity,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                items: cities.keys.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: isLoading
                    ? null
                    : (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCity = newValue;
                          });
                          // Refresh data cuaca saat kota diganti
                          _fetchWeather();
                        }
                      },
              ),
              const SizedBox(height: 24),

              // Loading state
              if (isLoading)
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Mengambil data cuaca...'),
                    ],
                  ),
                ),

              // Error state
              if (!isLoading && errorMessage != null)
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Data cuaca tidak dapat dimuat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Periksa koneksi internet kamu\n dan coba lagi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _fetchWeather,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Weather card (data cuaca)
              if (!isLoading && errorMessage == null && weather != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Icon cuaca
                        Icon(
                          _getWeatherIcon(weather!.weathercode),
                          size: 64,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 16),

                        // Nama kota
                        Text(
                          selectedCity,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Suhu (informasi utama)
                        Text(
                          '${weather!.temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Deskripsi cuaca
                        Text(
                          _getWeatherDescription(weather!.weathercode),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Kecepatan angin
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.air, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              '${weather!.windspeed.toStringAsFixed(1)} km/h',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Weather code
                        Text(
                          'Weather Code: ${weather!.weathercode}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Waktu terakhir diperbarui
              if (!isLoading && errorMessage == null && lastUpdated != null)
                Center(
                  child: Text(
                    'Terakhir diperbarui: ${lastUpdated!.hour.toString().padLeft(2, '0')}:${lastUpdated!.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Tombol refresh
              ElevatedButton.icon(
                onPressed: isLoading ? null : _fetchWeather,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Data'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
