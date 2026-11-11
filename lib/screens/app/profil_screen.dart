import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/student_profile.dart';
import '../../utils/colors.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/blur_background.dart';
import '../../widgets/logout_dialog.dart';
import '../../widgets/profile_avatar.dart';
import '../auth/login_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key, this.onBackToHome});

  final VoidCallback? onBackToHome;

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  // Controllers
  final _nomorAbsenController = TextEditingController(
    text: StudentProfile.instance.attendanceNumber,
  );
  final _waController = TextEditingController(
    text: StudentProfile.instance.phoneNumber,
  );
  final _kontakWaliController = TextEditingController(
    text: StudentProfile.instance.guardianPhone,
  );
  final _alamatController = TextEditingController(
    text: StudentProfile.instance.address,
  );

  String _selectedKelas = StudentProfile.instance.grade;
  static const _kelasOptions = ['7', '8', '9'];

  @override
  void dispose() {
    _nomorAbsenController.dispose();
    _waController.dispose();
    _kontakWaliController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  bool _isNumeric(TextEditingController controller) =>
      RegExp(r'^\d+$').hasMatch(controller.text);

  Future<void> _handleSave() async {
    setState(() {});
    if (!_isNumeric(_nomorAbsenController) ||
        !_isNumeric(_waController) ||
        !_isNumeric(_kontakWaliController)) {
      AppSnackBar.show(
        context,
        'Periksa kembali nomor absen dan nomor telepon.',
        isError: true,
      );
      return;
    }

    try {
      await StudentProfile.instance.saveDetails(
        grade: _selectedKelas,
        attendanceNumber: _nomorAbsenController.text,
        phoneNumber: _waController.text,
        guardianPhone: _kontakWaliController.text,
        address: _alamatController.text,
      );
      if (mounted) {
        AppSnackBar.show(context, 'Perubahan data berhasil disimpan');
      }
    } on Exception catch (error) {
      if (mounted) {
        AppSnackBar.show(
          context,
          'Data profil gagal disimpan: $error',
          isError: true,
        );
      }
    }
  }

  Future<void> _changeProfilePhoto() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image == null) return;

      await StudentProfile.instance.savePhoto(await image.readAsBytes());
      if (mounted) {
        AppSnackBar.show(context, 'Foto profil berhasil diperbarui');
      }
    } on PlatformException catch (error) {
      if (mounted) {
        AppSnackBar.show(
          context,
          'Galeri tidak dapat dibuka: ${error.message ?? error.code}',
          isError: true,
        );
      }
    } on Exception catch (error) {
      if (mounted) {
        AppSnackBar.show(
          context,
          'Foto profil gagal disimpan: $error',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlurBackground(
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppHeader(
                title: 'M-Class',
                subtitle: 'Profil',
                onBack: widget.onBackToHome,
                notificationFromTabIndex: 4,
              ),
              const SizedBox(height: 16),
              _buildTitleBar(),
              const SizedBox(height: 16),
              _buildStudentCard(),
              const SizedBox(height: 16),
              _buildDataSection(),
              const SizedBox(height: 18),
              _buildSaveButton(),
              const SizedBox(height: 12),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil Siswa',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Kelola data identitas dan kehadiran',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ProfileAvatar(
                size: 64,
                borderColor: AppColors.primarySoft,
                borderWidth: 2,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Material(
                  color: AppColors.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: _changeProfilePhoto,
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.edit, color: Colors.white, size: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Siswa Aktif',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _selectedKelas,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  StudentProfile.instance.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'NISN: ${StudentProfile.instance.nisn}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Data Akademik & Pribadi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Status: Siap Diperbarui',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // NISN readonly
          _readonlyField(
            label: 'NISN (Nomor Induk Siswa Nasional)',
            value: '0064892104',
          ),
          const SizedBox(height: 8),
          const Text(
            'Terkunci otomatis. Perubahan melalui Operator TU Sekolah.',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Kelas dropdown + Nomor absen
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _dropdownField(
                  label: 'Kelas',
                  value: _selectedKelas,
                  items: _kelasOptions,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedKelas = value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _inputField(
                  label: 'Nomor Absen',
                  controller: _nomorAbsenController,
                  keyboardType: TextInputType.number,
                  numericOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _inputField(
            label: 'Nomor WhatsApp Siswa',
            controller: _waController,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            numericOnly: true,
          ),
          const SizedBox(height: 16),

          _inputField(
            label: 'Nomor Telepon Orang Tua / Wali',
            controller: _kontakWaliController,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            numericOnly: true,
          ),
          const SizedBox(height: 16),

          _inputField(
            label: 'Alamat Domisili Siswa',
            controller: _alamatController,
            icon: Icons.location_on_outlined,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool numericOnly = false,
  }) {
    final hasInvalidNumber = numericOnly && !_isNumeric(controller);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasInvalidNumber ? AppColors.error : AppColors.inputBorder,
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  onChanged: numericOnly ? (_) => setState(() {}) : null,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasInvalidNumber) ...[
          const SizedBox(height: 5),
          const Text(
            'Harus diisi angka.',
            style: TextStyle(
              color: AppColors.error,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, AppColors.inputFill],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              borderRadius: BorderRadius.circular(16),
              dropdownColor: Colors.white,
              menuMaxHeight: 240,
              elevation: 8,
              icon: const Icon(
                Icons.expand_more_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              items: items.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Row(
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 17,
                        color: e == value
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 10),
                      Text('Kelas $e'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _readonlyField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.badge_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(Icons.verified, size: 16, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _handleSave,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.buttonGradientStart,
              AppColors.buttonGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_outlined, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Simpan Perubahan Data',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final confirmed = await showLogoutDialog(context);
        if (!context.mounted) return;
        if (confirmed) {
          AppSnackBar.show(context, 'Berhasil keluar dari akun');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE0E0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: AppColors.error, size: 18),
            SizedBox(width: 8),
            Text(
              'Keluar dari Akun',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
