import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/app_dependencies.dart';
import 'core/routing/app_router.dart';
import 'core/shared/locale_service.dart';
import 'core/storage/app_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //* Ensure the binding is initialized

  //* Initialize dependency injection (must be awaited)
  await configureDependencies();
  await AppRouter.initialize();

  //* Lock orientation to portrait mode only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //* Enable edge-to-edge mode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  final isLight = brightness == Brightness.light;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      systemNavigationBarIconBrightness:
          isLight ? Brightness.dark : Brightness.light,
    ),
  );

  await EasyLocalization.ensureInitialized();

  final storageService = getIt<AppStorageService>();
  final savedLocale = await LocaleService.loadLocale(storageService);
  final savedThemeMode = await storageService.getThemeMode();
  final themeMode = savedThemeMode ?? ThemeMode.system;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translation',
      fallbackLocale: const Locale('en'),
      startLocale: savedLocale,
      useOnlyLangCode: true,
      child: MyApp(initialThemeMode: themeMode),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.initialThemeMode,
  });

  final ThemeMode initialThemeMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    //* Listen to system theme changes
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      if (_themeMode == ThemeMode.system) {
        setState(() {});
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    //* Design size: Honor X9b 5G (6.78", 1220×2652)
    return ScreenUtilInit(
      designSize: const Size(375, 861),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            title: 'Fist Ecommerce App',
            theme: appTheme(context),
            darkTheme: appAltTheme(context),
            themeMode: _themeMode,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: (context, child) {
              return ThemeTransition(
                themeMode: _themeMode,
                child: child ?? const SizedBox(),
              );
            },
          ),
        );
      },
    );
  }
}
