import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/app_dependencies.dart';
import 'core/routing/app_router.dart';
import 'core/shared/locale_notifier.dart';
import 'core/shared/locale_service.dart';
import 'core/storage/app_storage_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //* init the dependencies
  await configureDependencies();
  await AppRouter.initialize();
  final storageService = getIt<AppStorageService>();

  //* init the local
  final savedLocale = await LocaleService.loadLocale(storageService);
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translation',
      fallbackLocale: const Locale('en'),
      startLocale: savedLocale,
      child: MyApp(storageService: storageService),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.storageService,
  });

  final AppStorageService storageService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _currentLocale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadLocale();
    LocaleNotifier.instance.onLocaleChanged = _handleLocaleChange;
  }

  @override
  void dispose() {
    LocaleNotifier.instance.onLocaleChanged = null;
    super.dispose();
  }

  Future<void> _loadLocale() async {
    final locale = await LocaleService.loadLocale(widget.storageService);
    if (mounted) {
      setState(() {
        _currentLocale = locale;
      });
    }
  }

  //* Handle locale change from notifier
  Future<void> _handleLocaleChange(Locale newLocale) async {
    await LocaleService.saveLocale(newLocale, widget.storageService);
    await EasyLocalization.of(context)?.setLocale(newLocale);
    if (mounted) {
      setState(() {
        _currentLocale = newLocale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1280, 832),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Fist Ecommerce App',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: appTheme(context),
          darkTheme: appAltTheme(context),
          themeMode: ThemeMode.system,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: _currentLocale,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
