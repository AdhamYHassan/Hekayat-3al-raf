import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/routing/app_router.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // Uncomment when Firebase is configured

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize JustAudioBackground for lockscreen and notification media controls
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.hekayat.audio.channel',
    androidNotificationChannelName: 'حكايات على الرف - تشغيل الصوت',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
  );

  // 2. EasyLocalization setup
  await EasyLocalization.ensureInitialized();

  // 3. Dependency Injection (Service Locator)
  setupDependencyInjection();

  // 3. Firebase (Commented until needed)
  /*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  */

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      startLocale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
      saveLocale: true,
      useOnlyLangCode: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtil Init (Mobile Standard: 375x812)
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Base App',

          // Localization
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          theme: ThemeData(
            useMaterial3: true,
            // fontFamily: 'Cairo',
          ),

          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
