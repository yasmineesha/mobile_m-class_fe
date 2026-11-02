import 'package:flutter/material.dart';
import '../utils/colors.dart';

// Menampilkan dialog peringatan terlambat (auto muncul kalau belum absen).
Future<void> showAttendanceReminderDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.primary.withValues(alpha: 0.25),  // ← hijau transparan
    builder: (context) => const _AttendanceReminderDialog(),
  );
}

class _AttendanceReminderDialog extends StatefulWidget {
  const _AttendanceReminderDialog();

  @override
  State<_AttendanceReminderDialog> createState() =>
      _AttendanceReminderDialogState();
}

class _AttendanceReminderDialogState extends State<_AttendanceReminderDialog> {
  int _selectedReason = 0;
  final _reasons = [
    'Macet Lalu Lintas',
    'Kendala Kendaraan',
    'Keperluan Keluarga',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tombol close
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close,
                        color: AppColors.textPrimary, size: 22),
                  ),
                ),
              ),

              // Judul
              const Text(
                'Tecatat Terlambat!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'PERINGATAN DISIPLIN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.error,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 20),

              // Info waktu
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  children: [
                    _timeRow('Waktu Presensi', '07.28', 'WIB'),
                    const Divider(height: 1, color: AppColors.inputBorder),
                    _timeRow('Batas Toleransi', '07.15', 'WIB'),
                    const Divider(height: 1, color: AppColors.inputBorder),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Selisih Keterlambatan',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE8CC),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Terlambat 13 Menit',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF8B5A0F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Peringatan poin
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [ 
                    Icon(Icons.warning_amber_rounded,
                        color: Color(0xFF8B5A0F), size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(text: 'Poin kedisiplinan '),
                            TextSpan(
                              text: '-2 poin',
                              style: TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '. Notifikasi otomatis telah dikirimkan ke WhatsApp Wali Murid (Bpk. H. Budi Santoso)',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Klasifikasi
              Row(
                children: [
                  const Icon(Icons.edit_note,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  const Text(
                    'Klarifikasi Alasan Keterlambatan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...List.generate(_reasons.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedReason = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedReason == i
                              ? AppColors.primary
                              : AppColors.inputBorder,
                          width: _selectedReason == i ? 1.8 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedReason == i
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: _selectedReason == i
                                ? AppColors.primary
                                : AppColors.textHint,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _reasons[i],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: _selectedReason == i
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),

              // Tombol konfirmasi gradient
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.buttonGradientStart,
                        AppColors.buttonGradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Konfirmasi & Kirim Alasan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeRow(String label, String time, String tz) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            tz,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}