import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/blur_background.dart';
import 'onboarding_screen.dart'; // Import halaman baru

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _loadingController;
  late Animation<double> _logoScale;
  late Animation<double> _textFade;
  late Animation<double> _loadingProgress;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.65, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _loadingProgress = CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    );
    _loadingController.forward();

    _navigationTimer = Timer(const Duration(milliseconds: 4500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, _, _) => const OnboardingScreen(),
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlurBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 190,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ScaleTransition(
                      scale: _logoScale,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'lib/assets/images/logo m-class.png',
                            width: 112,
                            height: 112,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              FadeTransition(
                opacity: _textFade,
                child: const Column(
                  children: [
                    Text(
                      'M-Class',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Smart Campus & Presensi Digital',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 42),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedBuilder(
                        animation: _loadingProgress,
                        builder: (context, _) => ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: _loadingProgress.value,
                            minHeight: 11,
                            backgroundColor: const Color(0xFFDCE3FF),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sync_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Menyiapkan sesi belajar...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
