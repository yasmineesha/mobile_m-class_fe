import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/colors.dart';
import '../../widgets/blur_background.dart';
import '../../widgets/label_required.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_snackbar.dart';
import 'new_password_screen.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final int _otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _handleKirim() {
    final otp = _controllers.map((c) => c.text).join();

    if (otp.length < _otpLength) {
      AppSnackBar.show(
        context,
        'Isi semua $_otpLength digit kode OTP',
        isError: true,
      );
      return;
    }

    if (otp != '123456') {
      AppSnackBar.show(context, 'Kode OTP salah. Coba lagi.', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NewPasswordPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 380;
    return Scaffold(
      body: BlurBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 16 : 24,
                vertical: 24,
              ),
              child: Container(
                padding: EdgeInsets.all(compact ? 20 : 28),
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
                      'Masukkan Kode OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dikirim ke: ${widget.email}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 28),

                    const LabelRequired(text: 'Kode OTP'),
                    const SizedBox(height: 12),

                    Row(
                      children: List.generate(_otpLength, (index) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index == _otpLength - 1 ? 0 : 8,
                            ),
                            child: SizedBox(
                              height: 56,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: AppColors.inputFill,
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.inputBorder,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty &&
                                      index < _otpLength - 1) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 32),

                    PrimaryButton(
                      text: 'Kirim',
                      icon: Icons.login,
                      isLoading: _isLoading,
                      onPressed: _handleKirim,
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: Text(
                        'Kode untuk testing: 123456',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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
