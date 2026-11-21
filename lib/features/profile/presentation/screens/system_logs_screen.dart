import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/helpers/app_log_store.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';

class SystemLogsScreen extends StatefulWidget {
  const SystemLogsScreen({super.key});

  @override
  State<SystemLogsScreen> createState() => _SystemLogsScreenState();
}

class _SystemLogsScreenState extends State<SystemLogsScreen> {
  @override
  Widget build(BuildContext context) {
    final logs = AppLogStore.instance.logs;

    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      appBar: AppBar(
        backgroundColor: ColorManager.primaryDark,
        elevation: 0,
        title: Text(
          'سجلات النظام (Logs)',
          style: AppFonts.alexandria(
            color: ColorManager.gold,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.doc_on_clipboard, color: ColorManager.gold),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: logs.join('\n')));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ السجلات بالكامل')),
              );
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.trash, color: Colors.redAccent),
            onPressed: () {
              setState(() {
                AppLogStore.instance.clear();
              });
            },
          ),
        ],
      ),
      body: logs.isEmpty
          ? Center(
              child: Text(
                'لا توجد سجلات مسجلة حتى الآن',
                style: AppFonts.ibmPlexSansArabic(color: ColorManager.paper400),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: logs.length,
              separatorBuilder: (_, _) => Divider(
                color: ColorManager.gold.withValues(alpha: 0.1),
                height: 12.h,
              ),
              itemBuilder: (context, index) {
                final logEntry = logs[logs.length - 1 - index]; // latest first
                final isError = logEntry.contains('ERROR');
                return SelectableText(
                  logEntry,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 11.sp,
                    color: isError ? Colors.redAccent : ColorManager.paper200,
                  ),
                );
              },
            ),
    );
  }
}
