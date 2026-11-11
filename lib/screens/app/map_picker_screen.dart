import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/school_location_map.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  bool? _withinSchoolRadius;

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
          SchoolLocationMap(
            initialZoom: 17,
            onWithinSchoolRadiusChanged: (withinRadius) {
              if (mounted && _withinSchoolRadius != withinRadius) {
                setState(() => _withinSchoolRadius = withinRadius);
              }
            },
          ),

          // ==== TOMBOL KONFIRMASI ====
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _withinSchoolRadius == true
                  ? () {
                      Navigator.pop(context, true);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _withinSchoolRadius == true
                    ? 'Konfirmasi Lokasi'
                    : _withinSchoolRadius == false
                    ? 'Kamu di luar radius sekolah'
                    : 'Menunggu deteksi lokasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
