import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/blur_background.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  int _tabIndex = 0;
  final _tabs = ['Semua', 'Presensi', 'Pengumuman & Libur'];

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
                _buildTitleSection(),
                const SizedBox(height: 14),
                _buildFilterTabs(),
                const SizedBox(height: 16),
                _buildBanner(),
                const SizedBox(height: 14),
                _notifAbsen(),
                const SizedBox(height: 12),
                _notifPercobaan(),
                const SizedBox(height: 12),
                _notifSuratIzin(),
                const SizedBox(height: 12),
                _notifPulangCepat(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Pusat Notifikasi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 10),
                  _BadgeBaru(text: '3 Baru'),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Pantau konfirmasi presensi & kabar penting sekolah',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              children: [
                Icon(Icons.done_all, color: AppColors.primary, size: 16),
                SizedBox(height: 2),
                Text(
                  'Baca\nSemua',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = i == _tabIndex;
          return Padding(
            padding: EdgeInsets.only(right: i < _tabs.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(
                          colors: [
                            AppColors.buttonGradientStart,
                            AppColors.buttonGradientEnd,
                          ],
                        )
                      : null,
                  color: selected ? null : AppColors.inputFill,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      i == 0
                          ? Icons.crop_square
                          : i == 1
                              ? Icons.how_to_reg_outlined
                              : Icons.campaign_outlined,
                      size: 14,
                      color: selected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_tabs[i]}${i == 0 ? ' (5)' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0F8A62), Color(0xFF0B6E4F)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_user,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Presensi Hari Ini Lengkap!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '14 hari berturut-turut hadir tepat waktu. Pertahankan!',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.auto_awesome,
              color: Colors.white.withValues(alpha: 0.7), size: 20),
        ],
      ),
    );
  }

  // ====== CARD: Absensi Berhasil ======
  Widget _notifAbsen() {
    return _NotifCard(
      borderColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline,
                    color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Absensi Masuk Berhasil!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Text(
                '15 mnt lalu',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Hari ini, pukul 06.45 WIB tercatat tepat waktu. Wajah terverifikasi cocok 99.4% & GPS berada di zona gerbang utama.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip('Match 99.4%', Icons.face_retouching_natural),
              const SizedBox(width: 8),
              _chip('Radius 12m (Aman)', Icons.location_on_outlined),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Tepat Waktu',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Icon(Icons.download_outlined,
                  size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
            ],
          ),
        ],
      ),
    );
  }

  // ====== CARD: Percobaan Luar Radius ======
  Widget _notifPercobaan() {
    return _NotifCard(
      borderColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_off,
                    color: AppColors.error, size: 16),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Percobaan Presensi di Luar Radius',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Text(
                'Kemarin 07.12',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              children: [
                TextSpan(
                    text:
                        'Gagal rekam presensi otomatis karena perangkat terdeteksi berada '),
                TextSpan(
                  text: '850 meter',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                    text: ' dari koordinat resmi MTs. Al-Ma\'arif 02'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.priority_high,
                      color: Colors.white, size: 10),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tips Lokasi GPS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Pastikan GPS akurasi tinggi aktif dan Anda telah masuk area pos satpam atau lobi sekolah.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.map_outlined,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Cek Radius Sekolah',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Icon(Icons.download_outlined,
                  size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
            ],
          ),
        ],
      ),
    );
  }

  // ====== CARD: Surat Izin Disetujui ======
  Widget _notifSuratIzin() {
    return _NotifCard(
      borderColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.izinBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.assignment_turned_in_outlined,
                    color: Color(0xFF8B5A0F), size: 16),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Surat Izin Disetujui Walikelas',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Text(
                '2 hari lalu',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Pengajuan dispensasi untuk agenda Lomba OSN Matematika telah diverifikasi dan disahkan oleh Bpk. Hendra S.Pd. Status: Dispensasi Resmi.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8CC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.school_outlined,
                    size: 11, color: Color(0xFF8B5A0F)),
                SizedBox(width: 4),
                Text(
                  'Akademik / Prestasi',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8B5A0F),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.visibility_outlined,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Lihat Salinan Surat',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Icon(Icons.download_outlined,
                  size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
            ],
          ),
        ],
      ),
    );
  }

  // ====== CARD: Jadwal Pulang Lebih Awal ======
  Widget _notifPulangCepat() {
    return _NotifCard(
      borderColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.alarm,
                    color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Jadwal Pulang Lebih Awal',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Text(
                '4 hari lalu',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Khusus hari Jumat, Kegiatan Belajar Mengajar (KBM) berakhir pada pukul 11.30 WIB sehubungan dengan persiapan simulasi Asesmen Nasional.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.info_outline,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Presensi Pulang: 11.30 – 12.30 WIB',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Icon(Icons.download_outlined,
                  size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primarySoft.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 11, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;

  const _NotifCard({required this.child, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.55),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back,
              color: AppColors.primary, size: 22),
        ),
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
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none,
              color: AppColors.primary, size: 24),
        ),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 1.5),
            image: const DecorationImage(
              image: NetworkImage('https://i.pravatar.cc/150?img=47'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class _BadgeBaru extends StatelessWidget {
  final String text;

  const _BadgeBaru({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}