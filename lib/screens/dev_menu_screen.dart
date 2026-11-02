import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'splash_screen.dart';
import 'onboarding_screen.dart'; // Tambahan Onboarding
import 'main_shell.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'auth/forgot_password_screen.dart';
import 'auth/otp_verification_screen.dart';
import 'auth/new_password_screen.dart';
import 'app/surat_izin_screen.dart';
import 'app/surat_izin_berhasil_screen.dart';
import 'app/notifikasi_screen.dart';
import 'app/scan_wajah_screen.dart';

class DevMenuScreen extends StatelessWidget {
  const DevMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <_DevPage>[
      _DevPage('🚀', 'Splash Screen', const SplashScreen()),
      _DevPage('📖', 'Onboarding', const OnboardingScreen()), // Tambahan
      _DevPage('🔐', 'Login', const LoginPage()),
      _DevPage('📝', 'Register', const RegisterPage()),
      _DevPage('🔑', 'Lupa Password', const ForgotPasswordPage()),
      _DevPage(
        '🔢',
        'OTP Verification',
        const OtpVerificationPage(email: 'test@student.mts.id'),
      ),
      _DevPage('🔒', 'Password Baru', const NewPasswordPage()),
      _DevPage('📊', 'Dashboard + Bottom Nav', const MainShell()),
      _DevPage('📄', 'Surat Izin (Form)', const SuratIzinScreen()),
      _DevPage('✅', 'Surat Izin Berhasil', const SuratIzinBerhasilScreen()),
      _DevPage('🔔', 'Notifikasi', const NotifikasiScreen()),
      _DevPage('📸', 'Scan Wajah', const ScanWajahScreen()),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '🛠️ Dev Menu',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: AppColors.primarySoft,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () {
            // Balik ke splash (mode normal)
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SplashScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: pages.length,
        // Perbaikan: (_, _) diganti jadi (_, __) agar tidak error
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final page = pages[index];
          return _buildMenuItem(context, page);
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _DevPage page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page.widget),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  page.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                page.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _DevPage {
  final String emoji;
  final String title;
  final Widget widget;

  _DevPage(this.emoji, this.title, this.widget);
}