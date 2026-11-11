import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:latlong2/latlong.dart' as osm;

import '../utils/colors.dart';

class SchoolLocationMap extends StatefulWidget {
  const SchoolLocationMap({
    super.key,
    required this.initialZoom,
    this.onLocationStatusChanged,
    this.onWithinSchoolRadiusChanged,
  });

  static const google_maps.LatLng schoolLocation = google_maps.LatLng(
    -7.8959,
    112.6693,
  );
  static const double attendanceRadiusMeters = 50;

  final double initialZoom;
  final ValueChanged<String>? onLocationStatusChanged;
  final ValueChanged<bool?>? onWithinSchoolRadiusChanged;

  @override
  State<SchoolLocationMap> createState() => _SchoolLocationMapState();
}

class _SchoolLocationMapState extends State<SchoolLocationMap> {
  google_maps.GoogleMapController? _mapController;
  google_maps.LatLng? _currentLocation;
  bool _hasLocationPermission = false;
  bool _isLoadingLocation = true;
  String? _locationError;

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  void initState() {
    super.initState();
    if (_isAndroid) {
      _loadCurrentLocation();
    } else {
      _isLoadingLocation = false;
      _locationError = 'Deteksi lokasi otomatis tersedia di aplikasi Android.';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.onLocationStatusChanged?.call(_locationError!);
        widget.onWithinSchoolRadiusChanged?.call(null);
      });
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    if (!_isAndroid) return;

    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _setLocationUnavailable(
          'Aktifkan layanan lokasi/GPS pada perangkat untuk mendeteksi posisi.',
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _setLocationUnavailable(
          permission == LocationPermission.deniedForever
              ? 'Izin lokasi ditolak. Aktifkan izin lokasi aplikasi melalui Pengaturan.'
              : 'Izin lokasi belum diberikan. Izinkan akses lokasi untuk melihat posisi.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      if (!mounted) return;

      final currentLocation = google_maps.LatLng(
        position.latitude,
        position.longitude,
      );
      final distanceToSchool = Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        SchoolLocationMap.schoolLocation.latitude,
        SchoolLocationMap.schoolLocation.longitude,
      );

      setState(() {
        _currentLocation = currentLocation;
        _hasLocationPermission = true;
        _isLoadingLocation = false;
      });
      widget.onLocationStatusChanged?.call(
        distanceToSchool <= SchoolLocationMap.attendanceRadiusMeters
            ? 'Lokasi terdeteksi • Dalam radius sekolah'
            : 'Lokasi terdeteksi • Di luar radius sekolah',
      );
      widget.onWithinSchoolRadiusChanged?.call(
        distanceToSchool <= SchoolLocationMap.attendanceRadiusMeters,
      );
      await _mapController?.animateCamera(
        google_maps.CameraUpdate.newLatLngZoom(
          currentLocation,
          widget.initialZoom,
        ),
      );
    } on TimeoutException {
      _setLocationUnavailable(
        'Waktu mendapatkan lokasi habis. Periksa GPS lalu coba lagi.',
      );
    } on Exception catch (error) {
      _setLocationUnavailable('Lokasi gagal dideteksi: $error');
    }
  }

  void _setLocationUnavailable(String message) {
    if (!mounted) return;
    setState(() {
      _hasLocationPermission = false;
      _isLoadingLocation = false;
      _locationError = message;
    });
    widget.onLocationStatusChanged?.call(message);
    widget.onWithinSchoolRadiusChanged?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    if (_isAndroid) return _buildGoogleMap();
    return _buildOpenStreetMap();
  }

  Widget _buildGoogleMap() {
    final initialTarget = _currentLocation ?? SchoolLocationMap.schoolLocation;

    return Stack(
      fit: StackFit.expand,
      children: [
        google_maps.GoogleMap(
          initialCameraPosition: google_maps.CameraPosition(
            target: initialTarget,
            zoom: widget.initialZoom,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
            final location = _currentLocation;
            if (location != null) {
              controller.animateCamera(
                google_maps.CameraUpdate.newLatLngZoom(
                  location,
                  widget.initialZoom,
                ),
              );
            }
          },
          myLocationEnabled: _hasLocationPermission,
          myLocationButtonEnabled: _hasLocationPermission,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          circles: {
            google_maps.Circle(
              circleId: const google_maps.CircleId('school_attendance_radius'),
              center: SchoolLocationMap.schoolLocation,
              radius: SchoolLocationMap.attendanceRadiusMeters,
              fillColor: AppColors.primary.withValues(alpha: 0.16),
              strokeColor: AppColors.primary,
              strokeWidth: 2,
            ),
          },
          markers: {
            google_maps.Marker(
              markerId: const google_maps.MarkerId('school'),
              position: SchoolLocationMap.schoolLocation,
              infoWindow: const google_maps.InfoWindow(
                title: 'MTs. Al-Ma\'arif 02',
              ),
              icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
                google_maps.BitmapDescriptor.hueGreen,
              ),
            ),
          },
        ),
        if (_isLoadingLocation)
          const ColoredBox(
            color: Color(0x55FFFFFF),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (_locationError != null)
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_off_outlined,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _locationError!,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _loadCurrentLocation,
                      tooltip: 'Coba deteksi lokasi lagi',
                      icon: const Icon(Icons.refresh, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOpenStreetMap() {
    const schoolLocation = osm.LatLng(-7.8959, 112.6693);
    return Stack(
      children: [
        flutter_map.FlutterMap(
          options: flutter_map.MapOptions(
            initialCenter: schoolLocation,
            initialZoom: widget.initialZoom,
          ),
          children: [
            flutter_map.TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.m_class',
            ),
            flutter_map.CircleLayer(
              circles: [
                flutter_map.CircleMarker(
                  point: schoolLocation,
                  radius: SchoolLocationMap.attendanceRadiusMeters,
                  useRadiusInMeter: true,
                  color: AppColors.primary.withValues(alpha: 0.16),
                  borderColor: AppColors.primary,
                  borderStrokeWidth: 2,
                ),
              ],
            ),
            flutter_map.MarkerLayer(
              markers: [
                flutter_map.Marker(
                  point: schoolLocation,
                  width: 40,
                  height: 48,
                  child: const Tooltip(
                    message: 'MTs. Al-Ma\'arif 02',
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
            flutter_map.SimpleAttributionWidget(
              alignment: Alignment.topRight,
              backgroundColor: Colors.white.withValues(alpha: 0.85),
              source: const Text(
                'OpenStreetMap contributors',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
        Positioned(
          top: 8,
          left: 8,
          right: 8,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _locationError!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
