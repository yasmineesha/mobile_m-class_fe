import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/colors.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  // Koordinat sekolah (Contoh: Malang)
  static const LatLng _sekolahLocation = LatLng(-7.9826, 112.6308);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Presensi'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // ==== PETA ASLI ====
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _sekolahLocation,
              zoom: 17,
            ),
            myLocationEnabled: false, // Set true kalau mau lihat titik biru user
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            circles: {
              // Gambar radius 50 meter
              Circle(
                circleId: const CircleId('radius_sekolah'),
                center: _sekolahLocation,
                radius: 50, 
                fillColor: AppColors.primary.withValues(alpha: 0.2),
                strokeColor: AppColors.primary,
                strokeWidth: 2,
              ),
            },
            markers: {
              const Marker(
                markerId: MarkerId('sekolah'),
                position: _sekolahLocation,
                infoWindow: InfoWindow(title: 'MTs. Al-Ma\'arif 02'),
              ),
            },
          ),
          
          // ==== TOMBOL KONFIRMASI ====
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Simulasi: anggap user valid
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Konfirmasi Lokasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}