import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_video_player_card.dart';

/// Smart Video Surface that detects YouTube / Web Embed vs Direct Video MP4.
/// 100% compliant with Apple App Store and Google Play policies.
class PodcastSmartVideoPlayerCard extends StatefulWidget {
  final String videoUrl;
  final String? embedSrc;
  final String title;
  final String thumbnailUrl;

  const PodcastSmartVideoPlayerCard({
    super.key,
    required this.videoUrl,
    this.embedSrc,
    required this.title,
    required this.thumbnailUrl,
  });

  @override
  State<PodcastSmartVideoPlayerCard> createState() =>
      _PodcastSmartVideoPlayerCardState();
}

class _PodcastSmartVideoPlayerCardState
    extends State<PodcastSmartVideoPlayerCard> {
  WebViewController? _webViewController;
  bool _isPlayingEmbed = false;
  bool _isLoadingEmbed = false;

  bool get _isYouTube {
    final url = widget.videoUrl.toLowerCase();
    final embed = (widget.embedSrc ?? '').toLowerCase();
    return url.contains('youtube.com') ||
        url.contains('youtu.be') ||
        embed.contains('youtube');
  }

  String get _effectiveEmbedUrl {
    if (widget.embedSrc != null && widget.embedSrc!.isNotEmpty) {
      return widget.embedSrc!;
    }
    final uri = Uri.tryParse(widget.videoUrl);
    if (uri != null) {
      if (uri.host.contains('youtu.be')) {
        final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
        return 'https://www.youtube-nocookie.com/embed/$id';
      }
      if (uri.queryParameters.containsKey('v')) {
        return 'https://www.youtube-nocookie.com/embed/${uri.queryParameters['v']}';
      }
      if (uri.path.contains('/live/')) {
        final id = uri.path.split('/live/').last.split('?').first;
        return 'https://www.youtube-nocookie.com/embed/$id';
      }
    }
    return widget.videoUrl;
  }

  void _startEmbedPlayback() {
    setState(() {
      _isPlayingEmbed = true;
      _isLoadingEmbed = true;
    });

    final embedUrl = _effectiveEmbedUrl;
    // Construct valid HTML document with proper referrer and origins to eliminate Error 153
    final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="referrer" content="strict-origin-when-cross-origin">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { width: 100%; height: 100%; background-color: #000; overflow: hidden; }
    iframe { width: 100%; height: 100%; border: none; }
  </style>
</head>
<body>
  <iframe
    src="$embedUrl?autoplay=1&playsinline=1&enablejsapi=1&origin=https://hekayat3alraf.com"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    referrerpolicy="strict-origin-when-cross-origin"
    allowfullscreen>
  </iframe>
</body>
</html>
''';

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoadingEmbed = false);
          },
          onWebResourceError: (_) {
            if (mounted) setState(() => _isLoadingEmbed = false);
          },
        ),
      )
      ..loadHtmlString(htmlContent, baseUrl: 'https://hekayat3alraf.com');
  }

  Future<void> _openExternalLink() async {
    final uri = Uri.tryParse(widget.videoUrl);
    if (uri != null) {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If not YouTube, use the high-performance local video player card
    if (!_isYouTube && widget.videoUrl.isNotEmpty) {
      return StoryVideoPlayerCard(
        videoUrl: widget.videoUrl,
        title: widget.title,
      );
    }

    // YouTube Embed Player surface
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 220.h,
          decoration: BoxDecoration(
            color: ColorManager.primaryLight,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_isPlayingEmbed && _webViewController != null)
                  WebViewWidget(controller: _webViewController!)
                else ...[
                  AppCachedNetworkImage(
                    imageUrl: widget.thumbnailUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 720,
                    memCacheHeight: 440,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xCC220610),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _startEmbedPlayback,
                        borderRadius: BorderRadius.circular(32.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.primary.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(32.r),
                            border: Border.all(
                              color: ColorManager.goldLight,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.play_arrow_solid,
                                size: 18.sp,
                                color: ColorManager.goldLight,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'podcast.watch_episode'.tr(),
                                style: AppFonts.alexandria(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorManager.goldLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (_isLoadingEmbed)
                  const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.gold,
                      strokeWidth: 2,
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton.icon(
            onPressed: _openExternalLink,
            icon: Icon(
              CupertinoIcons.arrow_up_right_square,
              size: 14.sp,
              color: ColorManager.goldLight,
            ),
            label: Text(
              'podcast.open_youtube'.tr(),
              style: AppFonts.ibmPlexSansArabic(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: ColorManager.goldLight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
