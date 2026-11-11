import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m_class/screens/app/detail/riwayat_izin_detail_screen.dart';
import 'package:m_class/screens/app/riwayat_screen.dart';
import 'package:m_class/widgets/app_header.dart';

void main() {
  testWidgets('opens the selected leave record with its own category', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: RiwayatScreen())),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Olimpiade Sains Kota'));
    await tester.tap(find.text('Olimpiade Sains Kota'));
    await tester.pumpAndSettle();

    expect(find.text('Surat Dispensasi'), findsOneWidget);
    expect(find.text('Sakit'), findsNothing);
    expect(find.text('Lomba OSN Matematika'), findsNothing);
    expect(find.text('Olimpiade Sains Kota'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the provided category in the leave detail', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RiwayatIzinDetailScreen(
          kategori: 'Dispensasi',
          tanggal: '19 Maret 2026',
          deskripsi: 'Lomba OSN Matematika',
          lampiran: null,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Surat Dispensasi'), findsOneWidget);
    expect(find.text('Dispensasi'), findsOneWidget);
    expect(find.text('19 Maret 2026'), findsOneWidget);
    expect(find.text('Lomba OSN Matematika'), findsOneWidget);
    expect(find.text('Lampiran Surat'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('notification button opens and returns from notifications', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: AppNotificationButton())),
      ),
    );

    await tester.tap(find.byType(AppNotificationButton));
    await tester.pumpAndSettle();
    expect(find.text('Notifikasi'), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(AppNotificationButton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
