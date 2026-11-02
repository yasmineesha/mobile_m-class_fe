import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/blur_background.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/label_required.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_snackbar.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleKirim() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      AppSnackBar.show(context, 'Email tidak boleh kosong', isError: true);
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      AppSnackBar.show(context, 'Format email tidak valid', isError: true);
      return;
    }

    if (!email.endsWith('@student.mts.id')) {
      AppSnackBar.show(
        context,
        'Email tidak terdaftar di sistem M-Class',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AppSnackBar.show(context, 'Kode OTP telah dikirim ke $email');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationPage(email: email),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Lupa Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masukkan email yang terdaftar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),

                    const LabelRequired(text: 'Email'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _emailController,
                      hint: 'akukeren@student.mts.id',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Ingat Password? ',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    PrimaryButton(
                      text: 'Kirim Kode',
                      icon: Icons.login,
                      isLoading: _isLoading,
                      onPressed: _handleKirim,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}