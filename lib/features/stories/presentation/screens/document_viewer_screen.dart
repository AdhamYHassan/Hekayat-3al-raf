import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/services/document_download_service.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';

/// Full-screen high-performance PDF Viewer for document-type stories.
///
/// Features:
/// - Uses native platform PDFKit (iOS) & AndroidPdfViewer (Android) via [PDFView].
/// - Zero external permission requirements (100% Apple & Google Store compliant).
/// - Native Export/Share Sheet to save to Files/Drive or share externally.
/// - Disk cached for instant opening.
/// - Live page counter and smooth pinch-to-zoom.
class DocumentViewerScreen extends StatefulWidget {
  final String title;
  final String documentUrl;
  final String documentKey;

  const DocumentViewerScreen({
    super.key,
    required this.title,
    required this.documentUrl,
    required this.documentKey,
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  final DocumentDownloadService _downloadService = DocumentDownloadService();

  File? _pdfFile;
  bool _isLoading = true;
  String? _errorMessage;

  int _totalPages = 0;
  int _currentPage = 0;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final file = await _downloadService.getOrDownloadDocument(
        documentUrl: widget.documentUrl,
        fileKey: widget.documentKey,
      );
      if (mounted) {
        setState(() {
          _pdfFile = file;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'document.download_failed'.tr();
        });
      }
    }
  }

  Future<void> _shareDocument() async {
    if (_pdfFile == null || !await _pdfFile!.exists()) return;
    if (!mounted) return;

    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(_pdfFile!.path, mimeType: 'application/pdf', name: '${widget.title}.pdf')],
        subject: widget.title,
        sharePositionOrigin: origin,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ColorManager.paper100),
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.font16WhiteBold.copyWith(
            color: ColorManager.paper100,
          ),
        ),
        actions: [
          if (_isReady && _totalPages > 0)
            Padding(
              padding: EdgeInsetsDirectional.only(end: 8.w),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: ColorManager.gold.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'document.page_count'.tr(namedArgs: {
                      'current': '${_currentPage + 1}',
                      'total': '$_totalPages',
                    }),
                    style: TextStyles.font12GoldBold,
                  ),
                ),
              ),
            ),
          if (_pdfFile != null)
            IconButton(
              icon: const Icon(Icons.share_outlined, color: ColorManager.gold),
              tooltip: 'document.share_document'.tr(),
              onPressed: _shareDocument,
            ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: ColorManager.gold),
            SizedBox(height: 16.h),
            Text(
              'document.downloading'.tr(),
              style: TextStyles.font14TextRegular.copyWith(
                color: ColorManager.paper300,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null || _pdfFile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.sp,
              color: ColorManager.error,
            ),
            SizedBox(height: 12.h),
            Text(
              _errorMessage ?? 'document.download_failed'.tr(),
              style: TextStyles.font14TextRegular.copyWith(
                color: ColorManager.paper100,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: _loadFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.gold,
                foregroundColor: ColorManager.primaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text('common.retry'.tr()),
            ),
          ],
        ),
      );
    }

    return RepaintBoundary(
      child: PDFView(
        filePath: _pdfFile!.path,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
        fitEachPage: true,
        backgroundColor: ColorManager.primaryDark,
        onRender: (pages) {
          setState(() {
            _totalPages = pages ?? 0;
            _isReady = true;
          });
        },
        onPageChanged: (page, total) {
          setState(() {
            _currentPage = page ?? 0;
            _totalPages = total ?? _totalPages;
          });
        },
        onError: (error) {
          setState(() {
            _errorMessage = error.toString();
          });
        },
      ),
    );
  }
}
