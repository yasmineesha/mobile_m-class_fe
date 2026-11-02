import 'package:flutter/material.dart';
import '../widgets/floating_bottom_nav.dart';
import 'app/dashboard_screen.dart';
import 'app/riwayat_screen.dart';
import 'app/surat_izin_screen.dart';
import 'app/profil_screen.dart';
import 'app/kalender_screen.dart';   // ← comment dulu

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const RiwayatScreen(),
    const KalenderScreen(),   // ← comment dulu
    const SuratIzinScreen(),
    const ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: FloatingBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}