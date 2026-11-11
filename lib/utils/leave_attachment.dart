const maxLeaveAttachmentBytes = 10 * 1024 * 1024;

const supportedLeaveAttachmentExtensions = {'pdf', 'jpg', 'jpeg', 'png'};

String? validateLeaveAttachment({
  required String? extension,
  required int sizeBytes,
}) {
  if (extension == null ||
      !supportedLeaveAttachmentExtensions.contains(extension.toLowerCase())) {
    return 'Format berkas harus PDF, JPG, JPEG, atau PNG.';
  }
  if (sizeBytes > maxLeaveAttachmentBytes) {
    return 'Ukuran berkas melebihi batas maksimal 10 MB.';
  }
  return null;
}

String formatLeaveAttachmentSize(int sizeBytes) {
  final sizeInMb = sizeBytes / (1024 * 1024);
  return '${sizeInMb.toStringAsFixed(1)} MB';
}
