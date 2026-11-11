// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:m_class/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('app opens on the branded splash screen', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Menyiapkan sesi belajar...'), findsOneWidget);
    expect(find.textContaining('Dev Menu'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
