import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:base_app/core/routing/app_router.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // Uncomment when Firebase is configured

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. EasyLocalization setup
  await EasyLocalization.ensureInitialized();

  // 2. Dependency Injection (Service Locator)
  // await initAppDependencies(); // Service locator function in core/di/

  // 3. Firebase (Commented until needed)
  /*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  */

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
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
