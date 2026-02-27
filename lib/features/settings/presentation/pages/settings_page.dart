import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/animation/animation.dart';
import '../../../../core/component/app_snackbar.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/shared/app_scaffold.dart';
import '../../../../gen/assets.gen.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/settings_profile_section.dart';
import '../widgets/settings_theme_tile.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    this.languageKey,
    this.themeKey,
    this.onShowTourAgain,
  });

  final GlobalKey? languageKey;
  final GlobalKey? themeKey;
  final VoidCallback? onShowTourAgain;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SettingsBloc()..add(const SettingsLoaded());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  String _languageLabel(String languageCode) {
    return languageCode == 'en' ? 'English' : 'العربية';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider<SettingsBloc>.value(
      value: _bloc,
        child: BlocListener<SettingsBloc, SettingsState>(
        listenWhen: (prev, curr) => prev.locale != curr.locale,
        listener: (context, state) {
          if (context.mounted) {
            context.setLocale(state.locale);
          }
        },
        child: AppScaffold.clean(
          backgroundColor: theme.colorScheme.surface,
          body: SafeArea(
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: AnimatedColumn(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //* Profile section — login prompt or username
                      SettingsProfileSection(
                        isLoggedIn: state.isLoggedIn,
                        username: state.userName,
                        imageUrl: null,
                        onLoginTap: () => context.go(AppRoutes.login),
                      ),
                      SizedBox(height: 24.h),
                      //* Language tile
                      _wrapWithKey(
                        widget.languageKey,
                        SettingsTile(
                        leading: Assets.images.icons.swap.svg(
                          width: 24.r,
                          height: 24.r,
                          colorFilter: ColorFilter.mode(
                            colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        title: LocaleKeys.settings_language.tr(),
                        subtitle: _languageLabel(state.locale.languageCode),
                        onTap: () {
                          _bloc.add(SettingsLanguageToggled(
                            currentLocale: context.locale,
                          ));
                        },
                      ),
                      ),
                      SizedBox(height: 12.h),
                      //* Theme tile
                      _wrapWithKey(
                        widget.themeKey,
                        SettingsThemeTile(
                        currentTheme: state.themeMode,
                        onThemeChanged: (mode) {
                          _bloc.add(SettingsThemeChanged(themeMode: mode));
                        },
                      ),
                      ),
                      SizedBox(height: 12.h),
                      //* Haptic toggle tile
                      SettingsTile(
                        leading: Assets.images.icons.volumeUp.svg(
                          width: 24.r,
                          height: 24.r,
                          colorFilter: ColorFilter.mode(
                            colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        title: LocaleKeys.settings_haptic.tr(),
                        trailing: Switch.adaptive(
                          value: state.hapticEnabled,
                          onChanged: (value) {
                            _bloc.add(SettingsHapticToggled(enabled: value));
                          },
                        ),
                      ),
                      if (widget.onShowTourAgain != null) ...[
                        SizedBox(height: 12.h),
                        SettingsTile(
                          leading: Assets.images.icons.discovery.svg(
                            width: 24.r,
                            height: 24.r,
                            colorFilter: ColorFilter.mode(
                              colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          title: LocaleKeys.coachTour_showTourAgain.tr(),
                          onTap: widget.onShowTourAgain,
                        ),
                      ],
                      if (state.isLoggedIn) ...[
                        SizedBox(height: 12.h),
                        SettingsTile(
                          leading: Assets.images.icons.logoutIcon.svg(
                            width: 24.r,
                            height: 24.r,
                            colorFilter: ColorFilter.mode(
                              colorScheme.error,
                              BlendMode.srcIn,
                            ),
                          ),
                          title: LocaleKeys.auth_logout.tr(),
                          onTap: () {
                            _bloc.add(const SettingsLogoutRequested());
                            AppSnackbar.showSuccess(
                              context,
                              LocaleKeys.auth_logoutSuccess,
                              translation: true,
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _wrapWithKey(GlobalKey? key, Widget child) {
    if (key == null) return child;
    return KeyedSubtree(key: key, child: child);
  }
}
