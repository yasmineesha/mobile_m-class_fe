import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m_class/screens/app/surat_izin_berhasil_screen.dart';

void main() {
  testWidgets('shows the values received from the leave form', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SuratIzinBerhasilScreen(
          kategori: 'Keperluan',
          tanggalDari: DateTime(2026, 6, 5),
          tanggalSampai: DateTime(2026, 6, 6),
          alasan: 'Mengikuti kegiatan keluarga.',
          namaLampiran: 'Izin_Keluarga.pdf',
          ukuranLampiranBytes: 1024 * 1024,
        ),
      ),
    );

    expect(find.text('Keperluan'), findsOneWidget);
    expect(find.text('2 Hari'), findsOneWidget);
    expect(find.text('5 Jun 2026'), findsOneWidget);
    expect(find.text('6 Jun 2026'), findsOneWidget);
    expect(find.text('"Mengikuti kegiatan keluarga."'), findsOneWidget);
    expect(find.text('Izin_Keluarga.pdf'), findsOneWidget);
    expect(find.text('1.0 MB • Dipilih di perangkat'), findsOneWidget);
    expect(find.text('Belum dikirim ke server'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
