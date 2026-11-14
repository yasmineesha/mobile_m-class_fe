import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

Uint8List buildAttendanceWorkbook(List<List<String>> rows) {
  final archive = Archive();

  void addXmlFile(String path, String content) {
    final bytes = utf8.encode(content);
    archive.addFile(ArchiveFile(path, bytes.length, bytes));
  }

  final sheetRows = rows.indexed.map((entry) {
    final rowIndex = entry.$1 + 1;
    final cells = entry.$2.indexed.map((cellEntry) {
      final columnName = _columnName(cellEntry.$1 + 1);
      final reference = '$columnName$rowIndex';
      final value = _escapeXml(cellEntry.$2);
      return '<c r="$reference" t="inlineStr"><is><t xml:space="preserve">$value</t></is></c>';
    }).join();
    return '<row r="$rowIndex">$cells</row>';
  }).join();

  addXmlFile(
    '[Content_Types].xml',
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
        '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
        '<Default Extension="xml" ContentType="application/xml"/>'
        '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
        '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
        '</Types>',
  );
  addXmlFile(
    '_rels/.rels',
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
        '</Relationships>',
  );
  addXmlFile(
    'xl/workbook.xml',
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
        '<sheets><sheet name="Rekap Kehadiran" sheetId="1" r:id="rId1"/></sheets>'
        '</workbook>',
  );
  addXmlFile(
    'xl/_rels/workbook.xml.rels',
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>'
        '</Relationships>',
  );
  addXmlFile(
    'xl/worksheets/sheet1.xml',
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
        '<sheetData>$sheetRows</sheetData>'
        '</worksheet>',
  );

  return Uint8List.fromList(ZipEncoder().encode(archive));
}

String _columnName(int column) {
  var remaining = column;
  var name = '';
  while (remaining > 0) {
    final letterIndex = (remaining - 1) % 26;
    name = String.fromCharCode(65 + letterIndex) + name;
    remaining = (remaining - 1) ~/ 26;
  }
  return name;
}

String _escapeXml(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');
