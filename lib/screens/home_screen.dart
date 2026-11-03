import 'package:flutter/material.dart';

import '../services/location_service.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService _locationService = LocationService();

  String _message = 'Tekan tombol untuk memeriksa izin lokasi.';
  bool _isLoading = false;
  double? _latitude;
  double? _longitude;
  String? _address;

  Future<void> _checkLocationPermission() async {
    setState(() {
      _isLoading = true;
      _message = 'Mengambil koordinat lokasi...';
    });

    try {
      final position = await _locationService.getCurrentPosition();

      if (!mounted) return;

      if (position != null) {
        final address = await _locationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (!mounted) return;

        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _address = address;

          _message = address != null
              ? 'Lokasi berhasil ditemukan.'
              : 'Koordinat berhasil diperoleh, tetapi alamat tidak tersedia.';
        });
      } else {
        setState(() {
          _message = 'Lokasi belum tersedia. Periksa layanan dan izin lokasi.';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _message = 'Gagal mengambil informasi lokasi.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Saya'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                'Pemeriksaan Izin Lokasi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              if (_latitude != null && _longitude != null) ...[
                const SizedBox(height: 20),
                Text(
                  'Latitude: ${_latitude!.toStringAsFixed(6)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Longitude: ${_longitude!.toStringAsFixed(6)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
              if (_address != null) ...[
                const SizedBox(height: 20),
                const Text(
                  'Alamat:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _address!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
              if (_latitude != null && _longitude != null)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          latitude: _latitude!,
                          longitude: _longitude!,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('Lihat Lokasi pada Peta'),
                ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _checkLocationPermission,
                icon: const Icon(Icons.my_location),
                label: const Text('Periksa Izin Lokasi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
              if (_isLoading) ...[
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
