import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_snackbar.dart';
import '../../widgets/blur_background.dart';
import 'surat_izin_berhasil_screen.dart';

class SuratIzinScreen extends StatefulWidget {
  const SuratIzinScreen({super.key});

  @override
  State<SuratIzinScreen> createState() => _SuratIzinScreenState();
}

class _SuratIzinScreenState extends State<SuratIzinScreen> {
  final _scrollController = ScrollController();
  final _formKey = GlobalKey();
  final _alasanController = TextEditingController();

  int _selectedKategori = 0;
  DateTime? _tanggalDari;
  DateTime? _tanggalSampai;
  bool _isLoading = false;
  bool _hasLampiran = false;

  final _kategori = ['Sakit', 'Keperluan', 'Dispensasi'];
  final _kategoriIcons = [
    Icons.medical_services_outlined,
    Icons.groups_outlined,
    Icons.emoji_events_outlined,
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _alasanController.dispose();
    super.dispose();
  }

  // Scroll ke form
  void _scrollToForm() {
    final context = _formKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // Format tanggal
  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih Tanggal';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Date picker
  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (_tanggalDari ?? DateTime.now())
          : (_tanggalSampai ?? _tanggalDari ?? DateTime.now()),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _tanggalDari = picked;
          if (_tanggalSampai != null && _tanggalSampai!.isBefore(picked)) {
            _tanggalSampai = null;
          }
        } else {
          _tanggalSampai = picked;
        }
      });
    }
  }

  // Durasi
  int get _durasiHari {
    if (_tanggalDari == null || _tanggalSampai == null) return 0;
    return _tanggalSampai!.difference(_tanggalDari!).inDays + 1;
  }

  // Submit
  void _handleSubmit() {
    if (_tanggalDari == null) {
      AppSnackBar.show(context, 'Tanggal mulai belum dipilih', isError: true);
      return;
    }
    if (_tanggalSampai == null) {
      AppSnackBar.show(context, 'Tanggal selesai belum dipilih', isError: true);
      return;
    }
    if (_alasanController.text.trim().isEmpty) {
      AppSnackBar.show(context, 'Keterangan / alasan tidak boleh kosong',
          isError: true);
      return;
    }
    if (!_hasLampiran) {
      AppSnackBar.show(context, 'Lampiran bukti resmi wajib diunggah',
          isError: true);
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SuratIzinBerhasilScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlurBackground(
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppHeader(title: 'M-Class', subtitle: 'Surat Izin'),
              const SizedBox(height: 16),
              _buildRangkumanCard(),
              const SizedBox(height: 16),
              // Anchor untuk scroll
              Container(key: _formKey),
              _buildFormHeader(),
              const SizedBox(height: 14),

              // Kategori
              const Text(
                'Kategori Izin',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(_kategori.length, (i) {
                  final selected = i == _selectedKategori;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedKategori = i),
                      child: Container(
                        margin: EdgeInsets.only(
                            right: i == _kategori.length - 1 ? 0 : 8),
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _kategoriIcons[i],
                              size: 20,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _kategori[i],
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
              const SizedBox(height: 18),

              // Periode
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Periode Tanggal Izin',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (_durasiHari > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Durasi: $_durasiHari Hari',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _dateField(
                      label: 'Dari',
                      date: _tanggalDari,
                      onTap: () => _pickDate(isFrom: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _dateField(
                      label: 'Sampai',
                      date: _tanggalSampai,
                      onTap: () => _pickDate(isFrom: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Keterangan
              const Text(
                'Keterangan / Alasan Lengkap',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: TextField(
                  controller: _alasanController,
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                  decoration: const InputDecoration(
                    hintText:
                        'Contoh: Mengalami demam dan disarankan istirahat oleh dokter klinik...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Lampiran
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Lampiran Bukti Resmi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Text(
                    'PDF/JPG Max 5MB',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() => _hasLampiran = true);
                  AppSnackBar.show(context, 'Lampiran berhasil diunggah');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: _hasLampiran
                        ? AppColors.primarySoft.withValues(alpha: 0.4)
                        : AppColors.inputFill,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _hasLampiran
                          ? AppColors.primary
                          : AppColors.inputBorder,
                      width: _hasLampiran ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _hasLampiran
                              ? AppColors.primary
                              : AppColors.primarySoft,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _hasLampiran
                              ? Icons.check
                              : Icons.upload_file,
                          color: _hasLampiran
                              ? Colors.white
                              : AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _hasLampiran
                            ? 'Surat_Keterangan.pdf'
                            : 'Unggah Surat Dokter / Surat Wali',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _hasLampiran
                            ? '1.4 MB • Terverifikasi'
                            : 'Foto berkas dengan pencahayaan jelas',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (!_hasLampiran) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  size: 14, color: AppColors.primary),
                              SizedBox(width: 6),
                              Text(
                                'Pilih Berkas / Foto',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Notifikasi WA
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chat_outlined,
                          color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifikasi WhatsApp Wali Murid',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '0812-3456-7890 (Ibu Hendriani)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.verified,
                        color: AppColors.primary, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Tombol Kirim
              GestureDetector(
                onTap: _isLoading ? null : _handleSubmit,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
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
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send,
                                  color: Colors.white, size: 18),
                              SizedBox(width: 10),
                              Text(
                                'Kirim Permohonan Izin',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    final isEmpty = date == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isEmpty ? AppColors.inputBorder : AppColors.primary,
            width: isEmpty ? 1 : 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 12,
                    color: isEmpty
                        ? AppColors.textHint
                        : AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _formatDate(date),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isEmpty
                          ? AppColors.textHint
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangkumanCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'RINGKASAN SURAT IZIN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Semester Genap',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _stat('Sisa Kuota', '3', 'Hari')),
              const SizedBox(width: 10),
              Expanded(child: _stat('Sakit', '1', 'Hari')),
              const SizedBox(width: 10),
              Expanded(child: _stat('Menunggu', '1', 'Berkas')),
            ],
          ),
          const SizedBox(height: 16),
          // ==== Tombol yang scroll ke form ====
          GestureDetector(
            onTap: _scrollToForm,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline,
                      color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Ajukan Surat Izin Baru',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
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

  Widget _stat(String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.edit_document,
              size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'Formulir Surat Izin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Langkah 1/2',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}