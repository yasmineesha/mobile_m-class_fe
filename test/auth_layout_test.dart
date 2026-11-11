import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m_class/screens/auth/forgot_password_screen.dart';
import 'package:m_class/screens/auth/login_screen.dart';
import 'package:m_class/screens/auth/otp_verification_screen.dart';
import 'package:m_class/screens/auth/register_screen.dart';
import 'package:m_class/screens/onboarding_screen.dart';

void main() {
  testWidgets(
    'OTP fields stay separated without overflowing on narrow screens',
    (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: OtpVerificationPage(email: 'student@student.mts.id'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(6));
      final firstBox = tester.getRect(find.byType(TextField).at(0));
      final secondBox = tester.getRect(find.byType(TextField).at(1));
      expect(secondBox.left - firstBox.right, greaterThan(0));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'forgot-password flow opens the OTP screen for a valid student email',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ForgotPasswordPage()));

      await tester.enterText(find.byType(TextField), 'student@student.mts.id');
      await tester.tap(find.text('Kirim Kode'));
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pumpAndSettle();

      expect(find.text('Masukkan Kode OTP'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(6));
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    },
  );

  testWidgets('login, registration, and onboarding render the shared logo', (
    tester,
  ) async {
    for (final screen in const [
      LoginPage(),
      RegisterPage(),
      OnboardingScreen(),
    ]) {
      await tester.pumpWidget(MaterialApp(home: screen));
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
