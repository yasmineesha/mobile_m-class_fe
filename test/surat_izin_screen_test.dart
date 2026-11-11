import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m_class/screens/app/surat_izin_screen.dart';
import 'package:m_class/utils/colors.dart';

void main() {
  testWidgets('renders its form when pushed from another screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const SuratIzinScreen(),
                  ),
                );
              },
              child: const Text('Buka Surat Izin'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Buka Surat Izin'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Formulir Surat Izin'), findsOneWidget);
    expect(find.text('PDF/JPG/PNG • Maks. 10 MB'), findsOneWidget);
    expect(find.text('Surat_Keterangan.pdf'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses a white and green date picker theme', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SuratIzinScreen()));

    await tester.tap(find.text('Pilih Tanggal').first);
    await tester.pumpAndSettle();

    final dialog = find.byType(DatePickerDialog);
    expect(dialog, findsOneWidget);
    final theme = DatePickerTheme.of(tester.element(dialog));
    expect(theme.backgroundColor, Colors.white);
    expect(theme.surfaceTintColor, Colors.transparent);
    expect(theme.headerBackgroundColor, AppColors.primary);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selects the requested initial category', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SuratIzinScreen(initialIndex: 1)),
    );

    final selectedCategory = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const ValueKey('leave-category-1')),
        matching: find.text('Keperluan'),
      ),
    );
    final unselectedCategory = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const ValueKey('leave-category-0')),
        matching: find.text('Sakit'),
      ),
    );
    expect(selectedCategory.style?.color, Colors.white);
    expect(unselectedCategory.style?.color, AppColors.textSecondary);
    expect(tester.takeException(), isNull);
  });
}
