import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/dev_menu_screen.dart'; // ← Import Dev Menu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-Class',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0B6E4F),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      ),
      home: const DevMenuScreen(), // ← Ubah ke sini
    );
  }
}