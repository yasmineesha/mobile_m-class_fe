import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/blur_background.dart';
import 'scan_wajah_screen.dart';

class PanduanScanWajahScreen extends StatelessWidget {
  const PanduanScanWajahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlurBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Panduan Presensi',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),

                // Ilustrasi Wajah
                Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.face_retouching_natural,
                        size: 90,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Sebelum Memulai',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pastikan Anda memenuhi syarat berikut agar wajah dapat terdeteksi dengan baik oleh sistem AI.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // List Tata Cara
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      _RuleItem(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Pencahayaan Cukup',
                        desc: 'Pastikan wajah terkena cahaya, tidak gelap.',
                      ),
                      _RuleItem(
                        icon: Icons.visibility_off_outlined,
                        title: 'Lepas Penghalang',
                        desc: 'Lepas masker, kacamata, atau aksesoris penutup wajah.',
                      ),
                      _RuleItem(
                        icon: Icons.face_retouching_natural,
                        title: 'Hadap Lurus',
                        desc: 'Posisikan wajah di dalam lingkaran kamera.',
                      ),
                      _RuleItem(
                        icon: Icons.no_photography_outlined,
                        title: 'Tidak Blur',
                        desc: 'Tahan HP dengan stabil saat mengambil foto.',
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Tombol Mulai
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ScanWajahScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_front_rounded, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Mulai Scan Wajah',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget Bantuan untuk List Tata Cara
class _RuleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final bool isLast;

  const _RuleItem({
    required this.icon,
    required this.title,
    required this.desc,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
