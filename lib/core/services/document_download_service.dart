import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

/// Service responsible for downloading and caching PDF documents locally.
///
/// Ensures offline access, fast re-opening, and isolates network I/O
/// from UI components.
class DocumentDownloadService {
  final Dio _dio;

  DocumentDownloadService({Dio? dio}) : _dio = dio ?? Dio();

  /// Returns the local [File] path for the cached [documentUrl].
  /// If it doesn't exist, downloads it with [onProgress] reporting.
  Future<File> getOrDownloadDocument({
    required String documentUrl,
    required String fileKey,
    void Function(int received, int total)? onProgress,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final cacheDir = Directory('${tempDir.path}/documents');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    // Determine extension from URL or content-disposition
    String extension = 'bin';
    final uriPath = Uri.tryParse(documentUrl)?.path.toLowerCase() ?? '';
    if (uriPath.endsWith('.docx')) {
      extension = 'docx';
    } else if (uriPath.endsWith('.pdf')) {
      extension = 'pdf';
    } else if (uriPath.endsWith('.doc')) {
      extension = 'doc';
    }

    // Sanitize filename: use clean readable title or fallback to key
    final cleanName = fileKey.replaceAll(RegExp(r'[^a-zA-Z0-9_\-\u0600-\u06FF]'), '_');
    final safeFileName = '$cleanName.$extension';
    var targetFile = File('${cacheDir.path}/$safeFileName');

    // Return cached file if valid and not empty
    if (await targetFile.exists() && await targetFile.length() > 0) {
      return targetFile;
    }

    // Download to a temporary partial file first to avoid corrupted reads
    final partialFile = File('${targetFile.path}.part');
    if (await partialFile.exists()) {
      await partialFile.delete();
    }

    final response = await _dio.download(
      documentUrl,
      partialFile.path,
      onReceiveProgress: onProgress,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
      ),
    );

    // If extension wasn't in URL, detect from Content-Type or Content-Disposition
    if (extension == 'bin') {
      final contentType = response.headers.value('content-type')?.toLowerCase() ?? '';
      final disposition = response.headers.value('content-disposition')?.toLowerCase() ?? '';
      if (contentType.contains('pdf') || disposition.contains('.pdf')) {
        extension = 'pdf';
      } else if (contentType.contains('word') || contentType.contains('openxmlformats') || disposition.contains('.docx')) {
        extension = 'docx';
      } else if (disposition.contains('.doc')) {
        extension = 'doc';
      } else {
        // Inspect magic bytes
        final bytes = await partialFile.openRead(0, 4).first;
        if (bytes.length >= 4 && bytes[0] == 0x25 && bytes[1] == 0x50 && bytes[2] == 0x44 && bytes[3] == 0x46) {
          extension = 'pdf'; // %PDF
        } else if (bytes.length >= 4 && bytes[0] == 0x50 && bytes[1] == 0x4B) {
          extension = 'docx'; // PK (zip)
        }
      }
      final newSafeName = '$cleanName.$extension';
      targetFile = File('${cacheDir.path}/$newSafeName');
    }

    // Atomically rename once download succeeds
    await partialFile.rename(targetFile.path);
    return targetFile;
  }
}

