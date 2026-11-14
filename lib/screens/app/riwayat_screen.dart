import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../utils/attendance_workbook.dart';
import '../../utils/colors.dart';
import '../../widgets/app_header.dart';
import '../../widgets/blur_background.dart';
import '../../widgets/app_snackbar.dart';
import 'detail/presensi_detail_screen.dart';
import 'detail/riwayat_izin_detail_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key, this.onBackToHome});

  final VoidCallback? onBackToHome;

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  String _selectedMonth = 'Maret 2026';
  bool _isDownloading = false;

  static const _months = [
    'Januari 2026',
    'Februari 2026',
    'Maret 2026',
    'April 2026',
    'Mei 2026',
    'Juni 2026',
    'Juli 2026',
    'Agustus 2026',
    'September 2026',
    'Oktober 2026',
    'November 2026',
    'Desember 2026',
  ];

  List<_RiwayatItem> get _attendanceRecords => [
    _RiwayatItem(
      '21',
      'JUM',
      'Jumat, 21 Mar 2026',
      '06.50 - 15.30 WIB',
      'Hadir',
      'Tepat Waktu',
      AppColors.hadir,
      AppColors.hadirBg,
      false,
    ),
    _RiwayatItem(
      '20',
      'KAM',
      'Kamis, 20 Mar 2026',
      '06.42 - 15.35 WIB',
      'Hadir',
      'Tepat Waktu',
      AppColors.hadir,
      AppColors.hadirBg,
      false,
    ),
    _RiwayatItem(
      '19',
      'RAB',
      'Rabu, 19 Mar 2026',
      'Surat Terverifikasi',
      'Izin',
      'Olimpiade Sains Kota',
      AppColors.izin,
      AppColors.izinBg,
      false,
      'Dispensasi',
    ),
    _RiwayatItem(
      '18',
      'SEL',
      'Selasa, 18 Mar 2026',
      '07.02 - 15.30 WIB',
      'Hadir',
      'Tepat Waktu',
      AppColors.hadir,
      AppColors.hadirBg,
      false,
    ),
    _RiwayatItem(
      '17',
      'SEN',
      'Senin, 17 Mar 2026',
      'Surat Dokter Terlampir',
      'Sakit',
      '',
      AppColors.izin,
      AppColors.sakitBg,
      true,
      'Sakit',
    ),
    _RiwayatItem(
      '14',
      'JUM',
      'Jumat, 14 Mar 2026',
      '06.48 - 15.30 WIB',
      'Hadir',
      'Tepat Waktu',
      AppColors.hadir,
      AppColors.hadirBg,
      false,
    ),
  ];

  Future<void> _handleDownload() async {
    setState(() => _isDownloading = true);
    try {
      final rows = <List<String>>[
        ['Tanggal', 'Waktu / Keterangan', 'Status', 'Keterangan', 'Kategori'],
        for (final item in _attendanceRecords)
          [
            item.date,
            item.subtitle,
            item.status,
            item.statusDetail,
            item.kategori,
          ],
      ];
      final bytes = buildAttendanceWorkbook(rows);

      final monthFileName = _selectedMonth.replaceAll(' ', '_');
      final savedFile = await FilePicker.saveFile(
        fileName: 'Rekap_Presensi_$monthFileName.xlsx',
        bytes: bytes,
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        dialogTitle: 'Simpan Rekap Presensi Excel',
      );

      if (savedFile != null && mounted) {
        AppSnackBar.show(context, 'Rekap Excel berhasil disimpan.');
      }
    } on UnimplementedError {
      if (mounted) {
        AppSnackBar.show(
          context,
          'Fitur penyimpanan Excel tidak tersedia di perangkat ini.',
          isError: true,
        );
      }
    } on Exception catch (error) {
      if (mounted) {
        AppSnackBar.show(
          context,
          'Gagal menyimpan rekap Excel: $error',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
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
                subtitle: 'Riwayat',
                onBack: widget.onBackToHome,
                notificationFromTabIndex: 1,
              ),
              const SizedBox(height: 16),
              _buildTitleBar(),
              const SizedBox(height: 16),
              _buildTodayCard(context),
              const SizedBox(height: 20),
              const _StatistikSection(),
              const SizedBox(height: 20),
              _buildRecentList(context),
              const SizedBox(height: 20),
              _buildDownloadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Riwayat Presensi',
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Catatan kedisiplinan & rekap kehadiran',
                style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        // Dropdown Bulan yang lebih responsif
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedMonth,
              isDense: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primary,
                size: 20,
              ),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              borderRadius: BorderRadius.circular(12),
              items: _months
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedMonth = value);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ==== KARTU PRESENSI HARI INI ====
  Widget _buildTodayCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PresensiDetailScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.circle, size: 8, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'PRESENSI HARI INI',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'Senin, 24 Mar 2026',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Yasmine Shavira',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                // ==== BADGE STATUS DIPERBESAR ====
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.hadirBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.hadir,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Hadir Tepat Waktu',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.hadir,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 14,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6),
                Text(
                  'Gerbang Utama (GPS Valid • Radius 12m)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            // Jam masuk/pulang dihapus sesuai permintaan
          ],
        ),
      ),
    );
  }

  // ==== LIST RIWAYAT ====
  Widget _buildRecentList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.history_rounded,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                '7 Hari Terakhir',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              'Maret 2026',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._attendanceRecords.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RiwayatCard(
              item: item,
              onTap: () {
                // Jika statusnya Izin, masuk ke detail izin. Selain itu masuk ke detail presensi.
                if (item.status == 'Izin' || item.status == 'Sakit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RiwayatIzinDetailScreen(
                        kategori: item.kategori,
                        tanggal: item.date,
                        deskripsi: item.status == 'Izin'
                            ? item.statusDetail
                            : null,
                        lampiran: item.hasAttachment
                            ? 'Surat_Dokter_Klinik.pdf'
                            : null,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PresensiDetailScreen(),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // ==== TOMBOL UNDUH ====
  Widget _buildDownloadButton() {
    return ElevatedButton(
      onPressed: _isDownloading ? null : _handleDownload,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
        elevation: 8,
        shadowColor: AppColors.primary.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.buttonGradientStart,
              AppColors.buttonGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Center(
            child: _isDownloading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.table_chart_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Unduh Rekap Bulanan Excel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ======================= KOMPONEN STATISTIK =======================
class _StatistikSection extends StatelessWidget {
  const _StatistikSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistik Kehadiran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Periode aktif semester genap',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.trending_up, size: 12, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'Bulan Ini',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: CircularProgressIndicator(
                            value: 0.95,
                            strokeWidth: 8,
                            backgroundColor: AppColors.primarySoft.withValues(
                              alpha: 0.4,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '95%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              'Rating',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '95.2%',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Kehadiran',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Disiplin sangat baik! Tinggal 2 hari lagi untuk meraih...',
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _statBox(
                      'Hadir',
                      '20',
                      'Hari',
                      Icons.check_circle_outline,
                      AppColors.hadirBg,
                      AppColors.hadir,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statBox(
                      'Izin',
                      '1',
                      'Hari',
                      Icons.calendar_today_outlined,
                      AppColors.agendaBg,
                      AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _statBox(
                      'Sakit',
                      '1',
                      'Hari',
                      Icons.sick_outlined,
                      AppColors.sakitBg,
                      const Color(0xFF8B5A0F),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statBox(
                      'Alpa',
                      '0',
                      'Hari',
                      Icons.cancel_outlined,
                      AppColors.hadirBg,
                      AppColors.hadir,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statBox(
    String label,
    String value,
    String unit,
    IconData icon,
    Color bg,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: color,
                  height: 1,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================= KOMPONEN RIWAYAT =======================
class _RiwayatItem {
  final String day;
  final String dayName;
  final String date;
  final String subtitle;
  final String status;
  final String statusDetail;
  final Color statusColor;
  final Color statusBg;
  final bool hasAttachment;
  final String kategori;

  _RiwayatItem(
    this.day,
    this.dayName,
    this.date,
    this.subtitle,
    this.status,
    this.statusDetail,
    this.statusColor,
    this.statusBg,
    this.hasAttachment, [
    this.kategori = '',
  ]);
}

class _RiwayatCard extends StatelessWidget {
  final _RiwayatItem item;
  final VoidCallback onTap;

  const _RiwayatCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: item.statusBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    item.day,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: item.statusColor,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.dayName,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: item.statusColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.date,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: item.statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.status == 'Hadir'
                            ? Icons.check
                            : item.status == 'Izin'
                            ? Icons.calendar_today
                            : Icons.sick,
                        size: 10,
                        color: item.statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: item.statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.statusDetail.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.statusDetail,
                    style: TextStyle(
                      fontSize: 10,
                      color: item.statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (item.hasAttachment) ...[
                  const SizedBox(height: 4),
                  const Icon(
                    Icons.attach_file,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
