import 'package:flutter/material.dart';

import '../../models/student_profile.dart';
import '../../utils/colors.dart';
import '../../utils/leave_attachment.dart';
import '../../widgets/blur_background.dart';
import '../../widgets/profile_avatar.dart';

class SuratIzinBerhasilScreen extends StatelessWidget {
  const SuratIzinBerhasilScreen({
    super.key,
    required this.kategori,
    required this.tanggalDari,
    required this.tanggalSampai,
    required this.alasan,
    required this.namaLampiran,
    required this.ukuranLampiranBytes,
  });

  final String kategori;
  final DateTime tanggalDari;
  final DateTime tanggalSampai;
  final String alasan;
  final String namaLampiran;
  final int ukuranLampiranBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlurBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Header(),
                const SizedBox(height: 16),
                const _StudentCard(),
                const SizedBox(height: 14),
                const _SuccessCard(),
                const SizedBox(height: 14),
                const _TrackerCard(),
                const SizedBox(height: 14),
                _DetailCard(
                  kategori: kategori,
                  tanggalDari: tanggalDari,
                  tanggalSampai: tanggalSampai,
                  alasan: alasan,
                  namaLampiran: namaLampiran,
                  ukuranLampiranBytes: ukuranLampiranBytes,
                ),
                const SizedBox(height: 14),
                _buildPrimaryButton(
                  context,
                  'Kembali ke Formulir',
                  filled: true,
                ),
                const SizedBox(height: 10),
                _buildPrimaryButton(
                  context,
                  'Kembali ke Beranda',
                  filled: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context,
    String text, {
    required bool filled,
  }) {
    return GestureDetector(
      onTap: () {
        if (text == 'Kembali ke Beranda') {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: filled
              ? const LinearGradient(
                  colors: [
                    AppColors.buttonGradientStart,
                    AppColors.buttonGradientEnd,
                  ],
                )
              : null,
          color: filled ? null : Colors.white,
          border: filled
              ? null
              : Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1.2,
                ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: filled ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.arrow_back, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'M-Class',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Beranda',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const ProfileAvatar(
          size: 36,
          borderColor: AppColors.primary,
          borderWidth: 1.5,
        ),
      ],
    );
  }
}

class _StudentCard extends StatelessWidget {
  const _StudentCard();

  @override
  Widget build(BuildContext context) {
    final student = StudentProfile.instance;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const ProfileAvatar(
                size: 56,
                borderColor: AppColors.primarySoft,
                borderWidth: 1,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: AppColors.primary,
                    size: 14,
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
                        student.grade,
                        style: TextStyle(
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
                  student.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'NISN: ${student.nisn}',
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
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F8A62), Color(0xFF0B6E4F)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 2,
              ),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 34),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 12),
                SizedBox(width: 6),
                Text(
                  'Pratinjau di perangkat',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Rincian Pengajuan Siap',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Data pada halaman ini mengikuti isian formulir. Pengajuan belum dikirim ke sekolah karena backend belum terhubung.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STATUS PENGAJUAN',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Belum dikirim ke server',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackerCard extends StatelessWidget {
  const _TrackerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Alur Pengajuan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _step(
            number: 1,
            isDone: true,
            isCurrent: false,
            isLast: false,
            title: 'Formulir selesai diisi',
            subtitle: 'Data isian dan berkas ditampilkan pada ringkasan.',
            badge: 'Selesai',
            badgeColor: AppColors.primary,
            badgeTextColor: Colors.white,
          ),
          _step(
            number: 2,
            isDone: false,
            isCurrent: true,
            isLast: false,
            title: 'Kirim ke server sekolah',
            subtitle: 'Belum dapat dilakukan. Integrasi backend diperlukan untuk menyimpan dan mengirim pengajuan.',
            badge: 'Belum tersedia',
            badgeColor: AppColors.izinBg,
            badgeTextColor: const Color(0xFF8B5A0F),
          ),
          _step(
            number: 3,
            isDone: false,
            isCurrent: false,
            isLast: true,
            title: 'Verifikasi oleh pihak sekolah',
            subtitle: 'Tahap ini tersedia setelah pengajuan diterima server.',
          ),
        ],
      ),
    );
  }

  Widget _step({
    required int number,
    required bool isDone,
    required bool isCurrent,
    required bool isLast,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isDone || isCurrent
                      ? const LinearGradient(
                          colors: [
                            AppColors.buttonGradientStart,
                            AppColors.buttonGradientEnd,
                          ],
                        )
                      : null,
                  color: isDone || isCurrent ? null : AppColors.inputFill,
                  border: isCurrent
                      ? Border.all(color: AppColors.primary, width: 3)
                      : null,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          '$number',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isCurrent
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone || isCurrent
                        ? AppColors.primary
                        : AppColors.inputBorder,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isDone || isCurrent
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: badgeTextColor ?? Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDone || isCurrent
                          ? AppColors.textSecondary
                          : AppColors.textHint,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.kategori,
    required this.tanggalDari,
    required this.tanggalSampai,
    required this.alasan,
    required this.namaLampiran,
    required this.ukuranLampiranBytes,
  });

  final String kategori;
  final DateTime tanggalDari;
  final DateTime tanggalSampai;
  final String alasan;
  final String namaLampiran;
  final int ukuranLampiranBytes;

  @override
  Widget build(BuildContext context) {
    final student = StudentProfile.instance;
    final extension = namaLampiran.split('.').last.toUpperCase();
    final durationDays = tanggalSampai.difference(tanggalDari).inDays + 1;
    final isImage = {'JPG', 'JPEG', 'PNG'}.contains(extension);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rincian Surat Izin',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Ringkasan isian • belum dikirim ke server',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Langkah 2/2\nSelesai',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Kartu siswa
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const ProfileAvatar(
                  size: 44,
                  borderColor: AppColors.primarySoft,
                  borderWidth: 1,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            student.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              student.grade,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'NISN: ${student.nisn} • Siswa Aktif',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Kategori & durasi
          Row(
            children: [
              Expanded(
                child: _infoTile(
                  label: 'KATEGORI IZIN',
                  value: kategori,
                  icon: Icons.medical_services_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _infoTile(
                  label: 'DURASI ABSEN',
                  value: '$durationDays Hari',
                  icon: Icons.schedule,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tanggal
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _dateCol('Dari Tanggal', _formatDate(tanggalDari)),
                ),
                Container(width: 1, height: 36, color: AppColors.inputBorder),
                Expanded(
                  child: _dateCol(
                    'Sampai Tanggal',
                    _formatDate(tanggalSampai),
                    align: CrossAxisAlignment.end,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          const Text(
            'ALASAN KETIDAKHADIRAN',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '"$alasan"',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'DOKUMEN TERLAMPIR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                '1 Berkas ($extension)',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.buttonGradientStart,
                        AppColors.buttonGradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isImage ? Icons.image_outlined : Icons.picture_as_pdf,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaLampiran,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '${formatLeaveAttachmentSize(ukuranLampiranBytes)} • Dipilih di perangkat',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Terpilih',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _infoTile({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.buttonGradientStart,
                      AppColors.buttonGradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateCol(
    String label,
    String date, {
    CrossAxisAlignment align = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 12,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              date,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
