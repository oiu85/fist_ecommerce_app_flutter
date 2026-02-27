import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../localization/locale_keys.g.dart';
import '../theme/app_color_extension.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    this.backgroundColor,
    this.bottomNavKey,
    this.homeNavKey,
    this.cartNavKey,
    this.addProductNavKey,
    this.settingsNavKey,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabChange;
  final Color? backgroundColor;
  /// Coach tour key for entire bottom nav bar (closing step).
  final GlobalKey? bottomNavKey;
  final GlobalKey? homeNavKey;
  final GlobalKey? cartNavKey;
  final GlobalKey? addProductNavKey;
  final GlobalKey? settingsNavKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();
    final textTheme = theme.textTheme;

    return Container(
      key: bottomNavKey,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        border: Border(
          top: BorderSide(width: 1, color: (appColors?.borderColor ?? colorScheme.outline).withValues(alpha: 0.3)),
        ),
        boxShadow: [
          BoxShadow(offset: Offset(0, -4.h), blurRadius: 12.r, color: theme.shadowColor.withValues(alpha: 0.08)),
        ],
      ),
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              child: GNav(
                selectedIndex: selectedIndex,
                onTabChange: onTabChange,
                rippleColor: colorScheme.surfaceContainerHighest,
                hoverColor: colorScheme.surfaceContainerHighest,
                haptic: false,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 300),
                gap: 5.w,
                activeColor: colorScheme.primary,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                iconSize: 22.r,
                textSize: 11.sp,
                textStyle: textTheme.labelSmall?.copyWith(
                  fontFamily: FontFamily.sora,
                  fontWeight: FontWeight.w600,
                ),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                tabMargin: EdgeInsets.symmetric(horizontal: 2.w),
                tabBackgroundColor:
                    colorScheme.primaryContainer.withValues(alpha: 0.35),
                tabBorderRadius: 24.r,
                tabs: [
                  GButton(
                    icon: Icons.circle,
                    iconActiveColor: Colors.transparent,
                    iconColor: Colors.transparent,
                    leading: SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: Assets.images.icons.home.svg(
                        width: 22.r,
                        height: 22.r,
                        colorFilter: ColorFilter.mode(
                          selectedIndex == 0
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    text: LocaleKeys.home_navHome.tr(),
                  ),
                  GButton(
                    icon: Icons.circle,
                    iconActiveColor: Colors.transparent,
                    iconColor: Colors.transparent,
                    leading: SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: Assets.images.icons.cart.svg(
                        width: 22.r,
                        height: 22.r,
                        colorFilter: ColorFilter.mode(
                          selectedIndex == 1
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    text: LocaleKeys.home_navCart.tr(),
                  ),
                  GButton(
                    icon: Icons.circle,
                    iconActiveColor: Colors.transparent,
                    iconColor: Colors.transparent,
                    leading: SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: Assets.images.icons.addSquare.svg(
                        width: 22.r,
                        height: 22.r,
                        colorFilter: ColorFilter.mode(
                          selectedIndex == 2
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    text: LocaleKeys.home_navAddProduct.tr(),
                  ),
                  GButton(
                    icon: Icons.circle,
                    iconActiveColor: Colors.transparent,
                    iconColor: Colors.transparent,
                    leading: SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: Assets.images.icons.setting2.svg(
                        width: 22.r,
                        height: 22.r,
                        colorFilter: ColorFilter.mode(
                          selectedIndex == 3
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    text: LocaleKeys.settings_title.tr(),
                  ),
                ],
              ),
            ),
          ),
          //* Invisible overlay with keys for coach tour (pass-through for taps)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: IgnorePointer(
                child: SizedBox(
                  height: 52.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: _wrapWithKey(
                            homeNavKey,
                            SizedBox(width: 40.w, height: 40.h),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: _wrapWithKey(
                            cartNavKey,
                            SizedBox(width: 40.w, height: 40.h),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: _wrapWithKey(
                            addProductNavKey,
                            SizedBox(width: 40.w, height: 40.h),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: _wrapWithKey(
                            settingsNavKey,
                            SizedBox(width: 40.w, height: 40.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapWithKey(GlobalKey? key, Widget child) {
    if (key == null) return child;
    return KeyedSubtree(key: key, child: child);
  }
}
