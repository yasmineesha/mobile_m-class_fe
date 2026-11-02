import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/app_header.dart';
import '../../widgets/blur_background.dart';
import 'detail/pengumuman_detail_screen.dart';

class KalenderScreen extends StatefulWidget {
  const KalenderScreen({super.key});

  @override
  State<KalenderScreen> createState() => _KalenderScreenState();
}

class _KalenderScreenState extends State<KalenderScreen> {
  static const int _baseYear = 2026;
  static const int _baseMonth = 3;
  int _monthOffset = 0;

  static const _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  DateTime get _currentDate => DateTime(_baseYear, _baseMonth + _monthOffset);
  String get _monthLabel => '${_monthNames[_currentDate.month - 1]} ${_currentDate.year}';
  int get _daysInMonth => DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
  int get _firstWeekday => DateTime(_currentDate.year, _currentDate.month, 1).weekday;

  void _prevMonth() => setState(() => _monthOffset--);
  void _nextMonth() => setState(() => _monthOffset++);

  @override
  Widget build(BuildContext context) {
    return BlurBackground(
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppHeader(title: 'M-Class', subtitle: 'Kalender'),
              const SizedBox(height: 14),
              _buildMonthSwitcher(),
              const SizedBox(height: 14),
              _buildStatRow(),
              const SizedBox(height: 14),
              _buildCalendarCard(),
              const SizedBox(height: 20),
              _buildPengumumanSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSwitcher() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _prevMonth,
            icon: const Icon(Icons.chevron_left, color: AppColors.primary, size: 24),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  _monthLabel,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: const Icon(Icons.chevron_right, color: AppColors.primary, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow() {
    return Row(
      children: [
        Expanded(child: _statPill('20', 'Hadir', AppColors.hadirBg, AppColors.hadir)),
        const SizedBox(width: 8),
        Expanded(child: _statPill('2', 'Izin/Sakit', AppColors.izinBg, const Color(0xFF8B5A0F))),
        const SizedBox(width: 8),
        Expanded(child: _statPill('3', 'Libur', AppColors.liburBg, AppColors.libur)),
        const SizedBox(width: 8),
        Expanded(child: _statPill('0', 'Agenda', AppColors.hadirBg, AppColors.hadir)),
      ],
    );
  }

  Widget _statPill(String value, String label, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color, height: 1)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    final leadingEmpty = _firstWeekday - 1;
    final totalCells = leadingEmpty + _daysInMonth;
    final totalRows = (totalCells / 7).ceil();

    return Container(
      padding: const EdgeInsets.all(14),
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
            children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: (d == 'Sab' || d == 'Min') ? AppColors.libur : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          ...List.generate(totalRows, (row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: List.generate(7, (col) {
                  final cellIndex = row * 7 + col;
                  final day = cellIndex - leadingEmpty + 1;
                  if (day < 1 || day > _daysInMonth) return const Expanded(child: SizedBox(height: 40));
                  return Expanded(child: _buildDayCell(day));
                }),
              ),
            );
          }),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(14)),
            child: Wrap(
              spacing: 14,
              runSpacing: 8,
              children: [
                _legend(AppColors.hadir, 'Hadir'),
                _legend(AppColors.izin, 'Izin/Sakit'),
                _legend(AppColors.libur, 'Libur'),
                _legend(AppColors.primary, 'Agenda'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(int day) {
    final isToday = _monthOffset == 0 && day == 24;
    final weekdayCol = (day + _firstWeekday - 2) % 7;
    final isWeekend = weekdayCol == 5 || weekdayCol == 6;

    Color? dotColor;
    if (isWeekend) {
      dotColor = AppColors.libur;
    } else if (day % 7 == 0 || day % 11 == 0) {
      dotColor = AppColors.izin;
    } else if (day <= 24) {
      dotColor = AppColors.hadir;
    }

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: isToday ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$day',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
              color: isToday ? Colors.white : isWeekend ? AppColors.libur : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor == null ? Colors.transparent : isToday ? Colors.white : dotColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildPengumumanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.campaign_outlined, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Pengumuman Sekolah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const Text('3 Pengumuman Baru', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildPengumumanCard(
          context,
          tag: 'Libur Nasional',
          tagColor: AppColors.libur,
          tagBg: AppColors.liburBg,
          date: '22 Mar 2026',
          title: 'Libur Bersama Awal Ramadhan 1446 H',
          subtitle: 'Pelaksanaan: 29 - 31 Maret 2026',
          body: 'Seluruh kegiatan belajar mengajar tatap muka ditiadakan. Siswa diimbau memanfaatkan waktu...',
          source: 'Kesiswaan & Kurikulum',
        ),
        const SizedBox(height: 12),
        _buildPengumumanCard(
          context,
          tag: 'Akademik',
          tagColor: AppColors.primary,
          tagBg: AppColors.primarySoft,
          date: '20 Mar 2026',
          title: 'Penilaian Tengah Semester (PTS) Genap',
          subtitle: 'Mulai: 10 April 2026',
          body: 'Syarat Keikutsertaan: Presensi wajib minimal 90% dan bebas tanggungan administrasi.',
          source: 'Waka Kurikulum',
        ),
      ],
    );
  }

  Widget _buildPengumumanCard(
    BuildContext context, {
    required String tag,
    required Color tagColor,
    required Color tagBg,
    required String date,
    required String title,
    required String subtitle,
    required String body,
    required String source,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PengumumanDetailScreen(
              tag: tag,
              tagColor: tagColor,
              tagBg: tagBg,
              date: date,
              title: title,
              subtitle: subtitle,
              body: body,
              source: source,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(Icons.campaign_outlined, size: 10, color: tagColor),
                      const SizedBox(width: 4),
                      Text(tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: tagColor)),
                    ],
                  ),
                ),
                const Spacer(),
                Text(date, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.3)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(subtitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF3A3A3A), Color(0xFF1A1A1A)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(child: Icon(Icons.image_outlined, color: Colors.white38, size: 40)),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(source, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    children: [
                      Text('Baca Selengkapnya', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 12, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}