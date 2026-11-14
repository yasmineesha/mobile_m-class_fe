import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m_class/utils/attendance_workbook.dart';

void main() {
  test('creates an XLSX workbook with escaped attendance rows', () {
    final bytes = buildAttendanceWorkbook([
      ['Tanggal', 'Status'],
      ['Senin & Selasa', '<Hadir>'],
    ]);

    final workbook = ZipDecoder().decodeBytes(bytes);
    expect(workbook.findFile('xl/workbook.xml'), isNotNull);

    final sheet = workbook.findFile('xl/worksheets/sheet1.xml');
    expect(sheet, isNotNull);

    final sheetXml = utf8.decode(sheet!.content);
    expect(sheetXml, contains('A1'));
    expect(sheetXml, contains('B2'));
    expect(sheetXml, contains('Senin &amp; Selasa'));
    expect(sheetXml, contains('&lt;Hadir&gt;'));
  });
}
