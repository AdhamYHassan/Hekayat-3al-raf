import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class ForcedUpdateDialog extends StatelessWidget {
  static const String defaultAppStoreUrl =
      'https://apps.apple.com/us/app/hekayat-3al-raf/id6836494928';

  final String? updateUrl;

  const ForcedUpdateDialog({super.key, this.updateUrl});

  /// Displays the un-dismissible update dialog.
  static Future<void> show(BuildContext context, {String? updateUrl}) {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ForcedUpdateDialog(updateUrl: updateUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return PopScope(
      canPop: false,
      child: CupertinoAlertDialog(
        title: Text(
          isArabic ? 'تحديث إجباري' : 'Update Required',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            isArabic
                ? 'يتوفر إصدار جديد من تطبيق حكايات على الرف. يرجى تحديث التطبيق للمتابعة.'
                : 'A new version of Hekayat 3al Raf is available. Please update the app to continue.',
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              String targetUrl = updateUrl != null && updateUrl!.trim().isNotEmpty
                  ? updateUrl!.trim()
                  : (Platform.isIOS ? defaultAppStoreUrl : defaultAppStoreUrl);

              final uri = Uri.parse(targetUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Text(
              isArabic ? 'تحديث الآن' : 'Update Now',
              style: TextStyle(
                color: ColorManager.gold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
