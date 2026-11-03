import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapScreen({super.key, required this.latitude, required this.longitude});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Controller untuk mengatur tampilan peta
  final MapController _mapController = MapController();

  // Mengembalikan peta ke koordinat lokasi awal
  void _backToCurrentLocation() {
    final location = LatLng(widget.latitude, widget.longitude);

    _mapController.move(location, 16);
  }

  @override
  Widget build(BuildContext context) {
    // Mengubah koordinat menjadi objek LatLng
    final location = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      appBar: AppBar(title: const Text('Peta Lokasi')),
      body: Stack(
        children: [
          // Menampilkan peta OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: location, initialZoom: 16),
            children: [
              // Mengambil gambar peta dari OpenStreetMap
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.lokasi_saya',
              ),

              // Menampilkan marker lokasi
              MarkerLayer(
                markers: [
                  Marker(
                    point: location,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 45,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tombol kembali ke lokasi awal
          Positioned(
            right: 16,
            top: 16,
            child: FloatingActionButton.small(
              heroTag: 'back_to_location',
              onPressed: _backToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),

          // Tombol kontrol zoom
          Positioned(
            right: 16,
            bottom: 24,
            child: Column(
              children: [
                // Memperbesar peta
                FloatingActionButton.small(
                  heroTag: 'zoom_in',
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1,
                    );
                  },
                  child: const Icon(Icons.add),
                ),

                const SizedBox(height: 8),

                // Memperkecil peta
                FloatingActionButton.small(
                  heroTag: 'zoom_out',
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1,
                    );
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
