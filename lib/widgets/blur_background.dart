import 'package:flutter/material.dart';

/// Background warna solid hijau muda (#C8E6C9).
/// Ini adalah versi paling ringan untuk performa (Zero GPU/Blur Load).
class BlurBackground extends StatelessWidget {
  final Widget child;

  const BlurBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFC8E6C9), // Hijau mint muda
      child: child,
    );
  }
}