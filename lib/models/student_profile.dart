import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProfile extends ChangeNotifier {
  StudentProfile._();

  static final StudentProfile instance = StudentProfile._();

  static const _storageKey = 'student_profile';
  final String name = 'Yasmine Shavira';
  final String nisn = '0064892104';

  String _grade = '7';
  String _attendanceNumber = '28';
  String _phoneNumber = '081234567890';
  String _guardianPhone = '081198765432';
  String _address = 'Jl. Soekarno Hatta';
  Uint8List? _photoBytes;

  String get grade => _grade;
  String get attendanceNumber => _attendanceNumber;
  String get phoneNumber => _phoneNumber;
  String get guardianPhone => _guardianPhone;
  String get address => _address;
  Uint8List? get photoBytes => _photoBytes;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final storedProfile = preferences.getString(_storageKey);
    if (storedProfile == null) return;

    final data = jsonDecode(storedProfile) as Map<String, dynamic>;
    _grade = data['grade'] as String? ?? _grade;
    _attendanceNumber =
        data['attendanceNumber'] as String? ?? _attendanceNumber;
    _phoneNumber = data['phoneNumber'] as String? ?? _phoneNumber;
    _guardianPhone = data['guardianPhone'] as String? ?? _guardianPhone;
    _address = data['address'] as String? ?? _address;
    final encodedPhoto = data['photo'] as String?;
    _photoBytes = encodedPhoto == null ? null : base64Decode(encodedPhoto);
  }

  Future<void> saveDetails({
    required String grade,
    required String attendanceNumber,
    required String phoneNumber,
    required String guardianPhone,
    required String address,
  }) async {
    final updated = _profileJson(
      grade: grade,
      attendanceNumber: attendanceNumber,
      phoneNumber: phoneNumber,
      guardianPhone: guardianPhone,
      address: address,
    );
    final preferences = await SharedPreferences.getInstance();
    if (!await preferences.setString(_storageKey, jsonEncode(updated))) {
      throw Exception('Data profil gagal disimpan.');
    }

    _grade = grade;
    _attendanceNumber = attendanceNumber;
    _phoneNumber = phoneNumber;
    _guardianPhone = guardianPhone;
    _address = address;
    notifyListeners();
  }

  Future<void> savePhoto(Uint8List photoBytes) async {
    final updated = _profileJson(photo: base64Encode(photoBytes));
    final preferences = await SharedPreferences.getInstance();
    if (!await preferences.setString(_storageKey, jsonEncode(updated))) {
      throw Exception('Foto profil gagal disimpan.');
    }

    _photoBytes = photoBytes;
    notifyListeners();
  }

  Map<String, Object?> _profileJson({
    String? grade,
    String? attendanceNumber,
    String? phoneNumber,
    String? guardianPhone,
    String? address,
    String? photo,
  }) {
    return {
      'grade': grade ?? _grade,
      'attendanceNumber': attendanceNumber ?? _attendanceNumber,
      'phoneNumber': phoneNumber ?? _phoneNumber,
      'guardianPhone': guardianPhone ?? _guardianPhone,
      'address': address ?? _address,
      'photo':
          photo ?? (_photoBytes == null ? null : base64Encode(_photoBytes!)),
    };
  }
}
