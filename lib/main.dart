import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/student_profile.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _profileLoad;

  @override
  void initState() {
    super.initState();
    _profileLoad = StudentProfile.instance.load();
  }

  void _retryProfileLoad() {
    setState(() {
      _profileLoad = StudentProfile.instance.load();
    });
  }

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
      home: FutureBuilder<void>(
        future: _profileLoad,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _StartupScreen(
              icon: const Icon(
                Icons.error_outline,
                size: 40,
                color: Color(0xFFD32F2F),
              ),
              message: 'Profil gagal dimuat:\n${snapshot.error}',
              action: FilledButton(
                onPressed: _retryProfileLoad,
                child: const Text('Coba lagi'),
              ),
            );
          }
          return const SplashScreen();
        },
      ),
    );
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen({
    required this.icon,
    required this.message,
    this.action,
  });

  final Widget icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC8E6C9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF0A2E24)),
              ),
              if (action != null) ...[const SizedBox(height: 16), action!],
            ],
          ),
        ),
      ),
    );
  }
}
