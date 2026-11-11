import 'package:flutter/material.dart';

import '../widgets/floating_bottom_nav.dart';
import 'app/dashboard_screen.dart';
import 'app/riwayat_screen.dart';
import 'app/surat_izin_screen.dart';
import 'app/profil_screen.dart';
import 'app/kalender_screen.dart'; // ← comment dulu

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _screens = [
      const DashboardScreen(),
      RiwayatScreen(onBackToHome: _goToHome),
      KalenderScreen(onBackToHome: _goToHome),
      SuratIzinScreen(onBackToHome: _goToHome),
      ProfilScreen(onBackToHome: _goToHome),
    ];
  }

  void _goToHome() {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: FloatingBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
