//* Theme selection tile — Light / Dark / System chips.
//* Matches app tile pattern and uses CategoryChip-style selectors.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../gen/assets.gen.dart';

/// Settings tile for theme selection with Light, Dark, System options.
class SettingsThemeTile extends StatelessWidget {
  const SettingsThemeTile({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();
    final borderColor = appColors?.borderColor ?? colorScheme.outline;

    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: ShapeDecoration(
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadows: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.12),
              blurRadius: 2,
              offset: const Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: Assets.images.icons.discovery.svg(
                    width: 24.r,
                    height: 24.r,
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                AppText(
                  LocaleKeys.settings_theme.tr(),
                  translation: false,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: appColors?.primaryNavy ?? colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                _ThemeChip(
                  label: LocaleKeys.settings_light.tr(),
                  selected: currentTheme == ThemeMode.light,
                  onTap: () => _selectTheme(context, ThemeMode.light),
                ),
                SizedBox(width: 12.w),
                _ThemeChip(
                  label: LocaleKeys.settings_dark.tr(),
                  selected: currentTheme == ThemeMode.dark,
                  onTap: () => _selectTheme(context, ThemeMode.dark),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _ThemeChip(
                    label: LocaleKeys.settings_system.tr(),
                    selected: currentTheme == ThemeMode.system,
                    onTap: () => _selectTheme(context, ThemeMode.system),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectTheme(BuildContext context, ThemeMode mode) {
    AppHaptic.selection();
    onThemeChanged(mode);
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: ShapeDecoration(
          color: selected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            side: selected
                ? BorderSide.none
                : BorderSide(
                    color: appColors?.borderColor ?? colorScheme.outline,
                  ),
            borderRadius: BorderRadius.circular(9999.r),
          ),
        ),
        child: Center(
          child: AppText(
            label,
            translation: false,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: selected
                  ? (appColors?.primaryNavy ?? colorScheme.onPrimaryContainer)
                  : colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
