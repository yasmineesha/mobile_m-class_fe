import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../../utils/colors.dart';
import '../../widgets/app_snackbar.dart';
import 'tinjau_foto_wajah_screen.dart';

class ScanWajahScreen extends StatefulWidget {
  const ScanWajahScreen({super.key});

  @override
  State<ScanWajahScreen> createState() => _ScanWajahScreenState();
}

class _ScanWajahScreenState extends State<ScanWajahScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _controller = null;
      if (mounted) setState(() => _isCameraInitialized = false);
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final previousController = _controller;
    _controller = null;
    await previousController?.dispose();
    if (!mounted) return;

    setState(() {
      _isCameraInitialized = false;
      _cameraError = null;
    });

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw StateError('Tidak ada kamera.');

      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _controller = controller;
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      await _controller?.dispose();
      _controller = null;
      if (!mounted) return;
      setState(() => _cameraError = 'Gagal membuka kamera: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);

    try {
      final image = await _controller!.takePicture();
      final imageBytes = await image.readAsBytes();

      await _controller?.dispose();
      _controller = null;

      if (!mounted) return;

      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (_) => TinjauFotoWajahScreen(imageBytes: imageBytes),
        ),
      );

      if (mounted) {
        setState(() {
          _isCapturing = false;
          _isCameraInitialized = false;
        });
        _initializeCamera();
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(context, 'Gagal mengambil foto: $e', isError: true);
      setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ==== KAMERA PREVIEW (DIPERBAIKI AGAR TIDAK DESKOT) ====
            if (_cameraError != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.no_photography_outlined,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _cameraError!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _initializeCamera,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_isCameraInitialized && _controller != null)
              Center(
                child: AspectRatio(
                  // Kunci rasio 3:4 (Standar Portrait HP)
                  aspectRatio: 3 / 4,
                  child: CameraPreview(_controller!),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),

            // ==== OVERLAY LINGKARAN WAJAH ====
            Center(
              child: Container(
                width: 280,
                height: 360,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 3),
                  borderRadius: BorderRadius.circular(160),
                ),
              ),
            ),

            // ==== TOMBOL CLOSE ====
            Positioned(
              top: 20,
              left: 16,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),

            // ==== INSTRUKSI & TOMBOL SHUTTER ====
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Pastikan wajah tidak terhalang (lepas masker/kacamata)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _isCameraInitialized ? _takePicture : null,
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _isCameraInitialized
                              ? AppColors.primary
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: _isCapturing
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
