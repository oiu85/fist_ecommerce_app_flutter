import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/app_dependencies.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/bloc/cart_event.dart';
import 'core/haptic/app_haptic.dart';
import 'core/routing/app_router.dart';
import 'core/shared/locale_service.dart';
import 'core/storage/app_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_notifier.dart';
import 'core/theme/theme_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //* Ensure the binding is initialized

  //* Load env first — required before any ApiConfig access
  //? Uses .env.example as default; copy to .env for local overrides
  await dotenv.load(fileName: '.env.example');

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
  final themeMode = savedThemeMode ?? ThemeMode.light;
  //* Register theme notifier for runtime theme updates from Settings
  getIt.registerSingleton<ThemeModeNotifier>(ThemeModeNotifier(themeMode));
  //* Initialize haptic preference from storage
  final hapticEnabled = await storageService.getHapticEnabled();
  AppHaptic.setEnabled(hapticEnabled);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translation',
      fallbackLocale: const Locale('en'),
      startLocale: savedLocale,
      useOnlyLangCode: true,
      child: MyApp(themeNotifier: getIt<ThemeModeNotifier>()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.themeNotifier,
  });

  final ThemeModeNotifier themeNotifier;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //* Listen to system theme changes when using ThemeMode.system
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      if (widget.themeNotifier.value == ThemeMode.system) {
        setState(() {});
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    //* Design size: Honor X9b 5G (6.78", 1220×2652)
    return ListenableBuilder(
      listenable: widget.themeNotifier,
      builder: (context, _) {
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
                title: 'Fist-Ecommerce Task',
                theme: appTheme(context),
                darkTheme: appAltTheme(context),
                themeMode: widget.themeNotifier.value,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                builder: (context, child) {
                  return BlocProvider<CartBloc>(
                    create: (_) => getIt<CartBloc>()..add(const LoadCart()),
                    child: ThemeTransition(
                      themeMode: widget.themeNotifier.value,
                      child: child ?? const SizedBox(),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
