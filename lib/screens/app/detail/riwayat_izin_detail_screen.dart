import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/blur_background.dart';

class RiwayatIzinDetailScreen extends StatelessWidget {
  const RiwayatIzinDetailScreen({
    super.key,
    this.kategori = 'Sakit',
    this.tanggal = '17 Maret 2026',
    this.status = 'Disetujui Wali Kelas',
    this.deskripsi,
    this.lampiran = 'Surat_Dokter_Klinik.pdf',
    this.notificationFromTabIndex = 1,
  });

  final String kategori;
  final String tanggal;
  final String status;
  final String? deskripsi;
  final String? lampiran;
  final int notificationFromTabIndex;

  String get _judul =>
      kategori == 'Sakit' ? 'Surat Izin Sakit' : 'Surat $kategori';

  @override
  Widget build(BuildContext context) {
    return BlurBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppHeader(
                  title: 'M-Class',
                  subtitle: 'Bukti $_judul',
                  notificationFromTabIndex: notificationFromTabIndex,
                  onBack: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
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
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDE68A),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                kategori == 'Sakit'
                                    ? Icons.medical_services_outlined
                                    : Icons.assignment_outlined,
                                size: 30,
                                color: const Color(0xFF8B5A0F),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _judul,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildRow('Kategori', kategori),
                            if (deskripsi != null) ...[
                              const Divider(
                                color: AppColors.inputFill,
                                height: 1,
                              ),
                              _buildRow('Keperluan', deskripsi!),
                            ],
                            const Divider(
                              color: AppColors.inputFill,
                              height: 1,
                            ),
                            _buildRow('Tanggal', tanggal),
                            const Divider(
                              color: AppColors.inputFill,
                              height: 1,
                            ),
                            _buildRow('Status', status, isGreen: true),
                          ],
                        ),
                      ),
                      if (lampiran != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
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
                              const Text(
                                'Lampiran Surat',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Membuka lampiran surat...',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputFill,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.inputBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          lampiran!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
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

  Widget _buildRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isGreen ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
