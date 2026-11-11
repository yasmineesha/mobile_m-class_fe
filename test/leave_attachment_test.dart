import 'package:flutter_test/flutter_test.dart';
import 'package:m_class/utils/leave_attachment.dart';

void main() {
  test('accepts supported files up to and including 10 MB', () {
    expect(
      validateLeaveAttachment(
        extension: 'pdf',
        sizeBytes: maxLeaveAttachmentBytes,
      ),
      isNull,
    );
    expect(validateLeaveAttachment(extension: 'JPG', sizeBytes: 1), isNull);
  });

  test('rejects files larger than 10 MB and unsupported extensions', () {
    expect(
      validateLeaveAttachment(
        extension: 'png',
        sizeBytes: maxLeaveAttachmentBytes + 1,
      ),
      contains('10 MB'),
    );
    expect(
      validateLeaveAttachment(extension: 'docx', sizeBytes: 1),
      contains('PDF, JPG'),
    );
  });

  test('formats selected attachment sizes in MB', () {
    expect(formatLeaveAttachmentSize(1024 * 1024), '1.0 MB');
  });
}
