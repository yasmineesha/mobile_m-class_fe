import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../utils/colors.dart';
import '../../widgets/app_snackbar.dart';

class ScanWajahScreen extends StatefulWidget {
  const ScanWajahScreen({super.key});

  @override
  State<ScanWajahScreen> createState() => _ScanWajahScreenState();
}

class _ScanWajahScreenState extends State<ScanWajahScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
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
      if (cameras.isEmpty) {
        throw StateError('Tidak ada kamera yang tersedia di perangkat ini.');
      }

      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isCapturing) return;

    setState(() => _isCapturing = true);
    
    try {
      await _controller!.takePicture();
      
      // Di sini nanti kamu bisa kirim 'image' ke backend/AI.
      // Untuk sekarang kita simulasi berhasil:
      await Future.delayed(const Duration(milliseconds: 800)); // Simulasi loading AI
      
      if (!mounted) return;
      Navigator.pop(context); // Kembali ke dashboard setelah scan
      AppSnackBar.show(context, 'Wajah terverifikasi! Absensi berhasil.');
      
    } catch (e) {
      AppSnackBar.show(context, 'Gagal mengambil foto', isError: true);
      if (!mounted) return;
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
            // ==== KAMERA PREVIEW ====
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
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CameraPreview(_controller!),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),

            // ==== OVERLAY LINGKARAN WAJAH ====
            Center(
              child: Container(
                width: 260,
                height: 320,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Posisikan wajah di dalam lingkaran',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _takePicture,
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
                          color: _isCapturing ? Colors.grey : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: _isCapturing 
                          ? const Center(child: CircularProgressIndicator(color: Colors.white))
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