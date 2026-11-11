import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'profile_avatar.dart';

// Menampilkan bottom-sheet konfirmasi logout.
Future<bool> showLogoutDialog(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.primary.withValues(
      alpha: 0.35,
    ), // ← hijau transparan
    builder: (context) => const _LogoutSheet(),
  );
  return result ?? false;
}

class _LogoutSheet extends StatelessWidget {
  const _LogoutSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 24),

            // Icon logout merah dalam lingkaran
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFEBEE),
                border: Border.all(color: const Color(0xFFFFCDD2), width: 2),
              ),
              child: const Icon(Icons.logout, color: AppColors.error, size: 32),
            ),
            const SizedBox(height: 20),

            const Text(
              'Keluar dari Akun?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: 'Apakah Anda yakin ingin keluar dari akun '),
                  TextSpan(
                    text: 'M-Class',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: '? Anda harus masuk kembali dengan NISN dan kata sandi untuk mengakses profil Anda.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Kartu siswa
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const ProfileAvatar(
                        size: 50,
                        borderColor: AppColors.primarySoft,
                        borderWidth: 1,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: AppColors.primary,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _Badge(text: '7C', isPrimary: true),
                            SizedBox(width: 6),
                            _Badge(text: 'Siswa Aktif'),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Yasmine Shavira',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'NISN: 0064892104',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Tombol Ya Keluar
            GestureDetector(
              onTap: () => Navigator.pop(context, true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDEDE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: AppColors.error, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Ya, Keluar dari Akun',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Tombol Batal
            GestureDetector(
              onTap: () => Navigator.pop(context, false),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: const Center(
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final bool isPrimary;

  const _Badge({required this.text, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primary : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isPrimary ? Colors.white : AppColors.primary,
        ),
      ),
    );
  }
}
