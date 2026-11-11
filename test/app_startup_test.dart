import 'package:flutter_test/flutter_test.dart';
import 'package:m_class/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('starts at splash screen after the student profile loads', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('M-Class'), findsOneWidget);
    expect(find.text('Menyiapkan sesi belajar...'), findsOneWidget);
    expect(find.text('Memuat profil siswa...'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a retryable error instead of a blank screen', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'student_profile': 'not-json'});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Profil gagal dimuat:'), findsOneWidget);
    expect(find.text('Coba lagi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
