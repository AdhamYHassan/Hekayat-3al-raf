import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_shimmer.dart';

/// Production-grade cached network image widget adhering strictly to:
/// - CLAUDE.md Section B.8 (Memory & Image Decoding Optimization: memCacheWidth / memCacheHeight)
/// - Device pixel ratio awareness (prevents blurry rendering on 2x/3x screens while stopping OOM on 2-3GB devices)
/// - Beautiful custom shimmer placeholder and fallback error widget
class AppCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.memCacheWidth,
    this.memCacheHeight,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.trim().isEmpty) {
      return _buildErrorWidget(context);
    }

    // Determine target decoding resolution:
    // Multiply layout logical pixels by devicePixelRatio (capped at 2.5x to prevent excessive RAM pressure on high-density devices).
    // Safely check for isFinite (prevents double.infinity or NaN crash on round()).
    final dpr = MediaQuery.devicePixelRatioOf(context).clamp(1.0, 2.5);
    final targetMemWidth = memCacheWidth ??
        ((width != null && width!.isFinite) ? (width! * dpr).round() : null);
    final targetMemHeight = memCacheHeight ??
        ((height != null && height!.isFinite) ? (height! * dpr).round() : null);

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      memCacheWidth: targetMemWidth,
      memCacheHeight: targetMemHeight,
      fadeInDuration: const Duration(milliseconds: 180),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholderFadeInDuration: Duration.zero,
      placeholder: (context, url) => placeholder ?? _buildPlaceholder(context),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(context),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return RepaintBoundary(
      child: imageWidget,
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ColorManager.primaryLight.withValues(alpha: 0.35),
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.25),
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.photo,
          color: ColorManager.goldLight.withValues(alpha: 0.35),
          size: 24.sp,
        ),
      ),
    );
  }
}
