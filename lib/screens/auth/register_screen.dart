import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/auth_brand_header.dart';
import 'face_registration_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _nisnController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureKonfirmasi = true;
  bool _isLoading = false;

  // ==== STATE UNTUK PASSWORD STRENGTH ====
  double _passwordStrength = 0.0; // 0.0 sampai 1.0
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.transparent;

  // Simulasi daftar NISN yang sudah terdaftar
  final List<String> _registeredNisn = ['1234567890', '0987654321'];

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    // Listener untuk cek kekuatan password setiap kali diketik
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _passwordController.removeListener(_checkPasswordStrength);
    _namaController.dispose();
    _nisnController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  // ==== LOGIKA PASSWORD STRENGTH ====
  void _checkPasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;

    if (password.isEmpty) {
      strength = 0.0;
    } else if (password.length < 6) {
      strength = 0.33; // Lemah
    } else {
      // Cek apakah ada huruf besar, huruf kecil, angka, dan simbol
      final hasUppercase = password.contains(RegExp(r'[A-Z]'));
      final hasDigits = password.contains(RegExp(r'[0-9]'));
      final hasLowercase = password.contains(RegExp(r'[a-z]'));
      final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      final typesCount = [
        hasUppercase,
        hasDigits,
        hasLowercase,
        hasSpecial,
      ].where((e) => e).length;

      if (typesCount >= 3 && password.length >= 8) {
        strength = 1.0; // Kuat
      } else {
        strength = 0.66; // Sedang
      }
    }

    setState(() {
      _passwordStrength = strength;
      if (strength == 0.0) {
        _passwordStrengthText = '';
        _passwordStrengthColor = Colors.transparent;
      } else if (strength == 0.33) {
        _passwordStrengthText = 'Lemah';
        _passwordStrengthColor = Colors.red;
      } else if (strength == 0.66) {
        _passwordStrengthText = 'Sedang';
        _passwordStrengthColor = Colors.orange;
      } else {
        _passwordStrengthText = 'Kuat';
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  Future<void> _handleRegister() async {
    // Validasi Form (Wajib isi)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validasi tambahan: Minimal password "Sedang"
    if (_passwordStrength < 0.66) {
      AppSnackBar.show(
        context,
        'Password terlalu lemah. Mohon gunakan kombinasi huruf dan angka.',
        isError: true,
      );
      return;
    }

    final nisn = _nisnController.text.trim();

    if (_registeredNisn.contains(nisn)) {
      AppSnackBar.show(
        context,
        'NISN ini sudah terdaftar. Silakan login.',
        isError: true,
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final faceStepCompleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FaceRegistrationScreen()),
    );
    if (!mounted || faceStepCompleted != true) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);

    AppSnackBar.show(
      context,
      'Simulasi selesai. Data belum disimpan ke server. Silakan login.',
    );

    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFC8E6C9);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: 20,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: Stack(
        children: [
          // ==== LAYER 1: HEADER ====
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: const AuthBrandHeader(
                  title: 'Buat Akun\nM-Class',
                  description:
                      'Langkah 1 dari 2: lengkapi data untuk foto wajah.',
                ),
              ),
            ),
          ),

          // ==== LAYER 2: PANEL PUTIH ====
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.buttonGradientStart,
                      AppColors.buttonGradientEnd,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 2, left: 1.5, right: 1.5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(38),
                      topRight: Radius.circular(38),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ==== INPUT NAMA ====
                          _buildLabel('Nama Lengkap'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _namaController,
                            hint: 'Contoh: Yasmine Shavira',
                            icon: Icons.person_outline,
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                ? 'Wajib di isi'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // ==== INPUT NISN ====
                          _buildLabel('NISN'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _nisnController,
                            hint: 'Masukkan 10 Digit NISN',
                            icon: Icons.badge_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Wajib di isi';
                              }
                              if (value.trim().length != 10) {
                                return 'NISN harus 10 digit';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // ==== INPUT EMAIL ====
                          _buildLabel('Email'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _emailController,
                            hint: 'akukeren@student.mts.id',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Wajib di isi';
                              }
                              if (!value.contains('@')) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // ==== INPUT PASSWORD ====
                          _buildLabel('Password Baru'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Masukkan Kata Sandi',
                            icon: Icons.lock_outline,
                            obscure: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Wajib di isi';
                              }
                              if (value.trim().length < 6) {
                                return 'Minimal 6 karakter';
                              }
                              return null;
                            },
                          ),

                          // ==== INDIKATOR PASSWORD STRENGTH ====
                          if (_passwordController.text.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _passwordStrength,
                                      backgroundColor: Colors.grey.shade200,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _passwordStrengthColor,
                                      ),
                                      minHeight: 6,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _passwordStrengthText,
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: _passwordStrengthColor,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 16),

                          // ==== INPUT KONFIRMASI PASSWORD ====
                          _buildLabel('Konfirmasi Password'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _konfirmasiController,
                            hint: 'Masukkan Ulang Kata Sandi',
                            icon: Icons.lock_outline,
                            obscure: _obscureKonfirmasi,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureKonfirmasi
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscureKonfirmasi = !_obscureKonfirmasi,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Wajib di isi';
                              }
                              if (value != _passwordController.text) {
                                return 'Password tidak cocok';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),

                          // ==== TOMBOL REGISTER ====
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'Daftar Sekarang',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ==== LINK LOGIN ====
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Sudah punya akun? ",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          color: Colors.grey,
          fontSize: 13,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F7F6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        suffixIcon: suffixIcon,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorStyle: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
    );
  }
}
