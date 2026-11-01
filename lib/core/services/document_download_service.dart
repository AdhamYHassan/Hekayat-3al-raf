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

    // Sanitize filename
    final safeFileName = '${fileKey.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_')}.pdf';
    final targetFile = File('${cacheDir.path}/$safeFileName');

    // Return cached file if valid and not empty
    if (await targetFile.exists() && await targetFile.length() > 0) {
      return targetFile;
    }

    // Download to a temporary partial file first to avoid corrupted reads
    final partialFile = File('${targetFile.path}.part');
    if (await partialFile.exists()) {
      await partialFile.delete();
    }

    await _dio.download(
      documentUrl,
      partialFile.path,
      onReceiveProgress: onProgress,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
      ),
    );

    // Atomically rename once download succeeds
    await partialFile.rename(targetFile.path);
    return targetFile;
  }
}

