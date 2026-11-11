import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:m_class/models/student_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('saves and reloads student profile details', () async {
    SharedPreferences.setMockInitialValues({});
    final profile = StudentProfile.instance;
    await profile.load();

    await profile.saveDetails(
      grade: '8',
      attendanceNumber: '12',
      phoneNumber: '081234567890',
      guardianPhone: '081198765432',
      address: 'Jl. Merdeka',
    );

    expect(profile.grade, '8');
    expect(profile.attendanceNumber, '12');
    expect(profile.phoneNumber, '081234567890');
    expect(profile.guardianPhone, '081198765432');
    expect(profile.address, 'Jl. Merdeka');

    final preferences = await SharedPreferences.getInstance();
    final stored = jsonDecode(
      preferences.getString('student_profile')!,
    ) as Map<String, dynamic>;
    expect(stored['grade'], '8');
    expect(stored['address'], 'Jl. Merdeka');
  });
}
