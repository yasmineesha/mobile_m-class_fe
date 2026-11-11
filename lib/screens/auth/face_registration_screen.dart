import 'dart:math' as math;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/app_snackbar.dart';

class FaceRegistrationScreen extends StatefulWidget {
  const FaceRegistrationScreen({super.key});

  @override
  State<FaceRegistrationScreen> createState() => _FaceRegistrationScreenState();
}

class _FaceRegistrationScreenState extends State<FaceRegistrationScreen> {
  static const List<_FacePose> _poses = [
    _FacePose(
      title: 'Hadap ke depan',
      instruction:
          'Posisikan seluruh wajah di tengah oval dan lihat ke kamera.',
      icon: Icons.face_retouching_natural_rounded,
    ),
    _FacePose(
      title: 'Hadap ke kanan',
      instruction: 'Putar kepala perlahan ke kanan, tetap di dalam oval.',
      icon: Icons.turn_right_rounded,
    ),
    _FacePose(
      title: 'Hadap ke kiri',
      instruction: 'Putar kepala perlahan ke kiri, tetap di dalam oval.',
      icon: Icons.turn_left_rounded,
    ),
  ];

  final List<Uint8List> _photos = [];
  CameraController? _cameraController;
  int _currentPose = 0;
  bool _hasConsented = false;
  bool _cameraStarted = false;
  bool _isCameraInitialized = false;
  bool _isInitializingCamera = false;
  bool _isCapturing = false;
  String? _cameraError;

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _startCamera() async {
    setState(() => _cameraStarted = true);
    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final previousController = _cameraController;
    _cameraController = null;
    await previousController?.dispose();
    if (!mounted) return;

    setState(() {
      _isCameraInitialized = false;
      _isInitializingCamera = true;
      _cameraError = null;
    });

    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.where(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      if (frontCamera.isEmpty) {
        throw StateError('Kamera depan tidak tersedia di perangkat ini.');
      }

      final controller = CameraController(
        frontCamera.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      _cameraController = controller;
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _isCameraInitialized = true);
    } catch (error) {
      await _cameraController?.dispose();
      _cameraController = null;
      if (!mounted) return;
      setState(() => _cameraError = _cameraErrorMessage(error));
    } finally {
      if (mounted) {
        setState(() => _isInitializingCamera = false);
      }
    }
  }

  String _cameraErrorMessage(Object error) {
    final details = error.toString();
    final normalized = details.toLowerCase();
    if (normalized.contains('permission') ||
        normalized.contains('denied') ||
        normalized.contains('notallowederror')) {
      return 'Izin kamera belum diberikan. Izinkan kamera untuk localhost di '
          'pengaturan situs browser, lalu tekan "Coba lagi".';
    }
    return 'Kamera tidak dapat dibuka: $details';
  }

  Future<void> _capturePhoto() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);
    try {
      final image = await controller.takePicture();
      final bytes = await image.readAsBytes();
      final isLastPose = _currentPose == _poses.length - 1;
      if (isLastPose) {
        await controller.dispose();
      }
      if (!mounted) return;

      setState(() {
        _photos.add(bytes);
        _currentPose++;
        _isCapturing = false;
        if (isLastPose) {
          _cameraController = null;
          _isCameraInitialized = false;
        }
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isCapturing = false);
      AppSnackBar.show(context, 'Gagal mengambil foto: $error', isError: true);
    }
  }

  Future<void> _retakeFrom(int poseIndex) async {
    setState(() {
      _photos.removeRange(poseIndex, _photos.length);
      _currentPose = poseIndex;
    });
    await _initializeCamera();
  }

  void _finish() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: AppColors.primary,
                  ),
                  const Expanded(
                    child: Text(
                      'Langkah 2 dari 2',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Row(
                children: List.generate(_poses.length, (index) {
                  final isComplete = index < _photos.length;
                  final isCurrent = index == _currentPose && _cameraStarted;
                  return Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(
                        right: index == _poses.length - 1 ? 0 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: isComplete || isCurrent
                            ? AppColors.primary
                            : const Color(0xFFDCE6E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: !_cameraStarted
                  ? _buildIntroduction()
                  : _currentPose == _poses.length
                  ? _buildCompletion()
                  : _buildCaptureStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroduction() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.face_retouching_natural_rounded,
              color: AppColors.primary,
              size: 96,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Foto wajah',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ambil tiga foto sesuai arahan: menghadap depan, kanan, lalu kiri. '
            'Pastikan wajah terlihat jelas dan pencahayaan cukup.',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2EBE5)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Mode prototipe: foto hanya disimpan sementara di memori '
                    'selama proses ini. Foto tidak diunggah atau disimpan, '
                    'dan pose wajah belum dideteksi maupun diverifikasi otomatis.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _hasConsented,
            onChanged: (value) {
              setState(() => _hasConsented = value ?? false);
            },
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.primary,
            title: const Text(
              'Saya memahami bahwa ini hanya simulasi pengambilan foto.',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                height: 1.4,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _hasConsented ? _startCamera : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFB7C9C0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Lanjut ke kamera',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureStep() {
    final pose = _poses[_currentPose];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(pose.icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Foto ${_currentPose + 1}: ${pose.title}',
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_cameraError != null)
                    Container(
                      color: const Color(0xFF15221C),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.no_photography_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _cameraError!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: _isInitializingCamera
                                ? null
                                : _initializeCamera,
                            child: const Text('Coba lagi'),
                          ),
                        ],
                      ),
                    )
                  else if (_isCameraInitialized && _cameraController != null)
                    Positioned.fill(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width:
                              _cameraController!.value.previewSize?.height ??
                              480,
                          height:
                              _cameraController!.value.previewSize?.width ??
                              640,
                          child: CameraPreview(_cameraController!),
                        ),
                      ),
                    )
                  else
                    const ColoredBox(
                      color: Color(0xFF15221C),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  if (_isCameraInitialized)
                    const Positioned.fill(
                      child: IgnorePointer(child: _FaceGuideOverlay()),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            pose.instruction,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _isCameraInitialized && !_isCapturing
                  ? _capturePhoto
                  : null,
              icon: _isCapturing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.camera_alt_rounded),
              label: Text(_isCapturing ? 'Mengambil foto...' : 'Ambil foto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletion() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.primary,
            size: 64,
          ),
          const SizedBox(height: 12),
          const Text(
            'Tiga foto sudah diambil',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ketuk foto untuk mengambil ulang. Jika mengulang, foto setelahnya '
            'akan diminta kembali.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: List.generate(_poses.length, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == _poses.length - 1 ? 0 : 8,
                    ),
                    child: InkWell(
                      onTap: () => _retakeFrom(index),
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.memory(
                                _photos[index],
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _poses[index].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _finish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Selesaikan simulasi',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Foto hanya tersimpan sementara dan akan hilang saat halaman ditutup.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FaceGuideOverlay extends StatelessWidget {
  const _FaceGuideOverlay();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(280.0, constraints.maxWidth * 0.9);
        final height = math.min(360.0, constraints.maxHeight * 0.82);
        final oval = Rect.fromCenter(
          center: Offset(constraints.maxWidth / 2, constraints.maxHeight / 2),
          width: width,
          height: height,
        );

        return CustomPaint(painter: _FaceGuidePainter(oval));
      },
    );
  }
}

class _FaceGuidePainter extends CustomPainter {
  final Rect oval;

  const _FaceGuidePainter(this.oval);

  @override
  void paint(Canvas canvas, Size size) {
    final outsideOval = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addOval(oval);
    canvas.drawPath(outsideOval, Paint()..color = const Color(0xFFF4F8F5));
    canvas.drawOval(
      oval,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.95)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_FaceGuidePainter oldDelegate) => oldDelegate.oval != oval;
}

class _FacePose {
  final String title;
  final String instruction;
  final IconData icon;

  const _FacePose({
    required this.title,
    required this.instruction,
    required this.icon,
  });
}
