import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../localization/locale_keys.g.dart';
import '../theme/app_color_extension.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    this.backgroundColor,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabChange;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    final bg = backgroundColor ?? colorScheme.surface;
    final inactiveColor = colorScheme.onSurface.withValues(alpha: 0.7);
    final activeColor = colorScheme.primary;
    final tabBg = colorScheme.primaryContainer.withValues(alpha: 0.3);
    final borderColor = appColors?.borderColor ?? colorScheme.outline;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [
          BoxShadow(
            blurRadius: 20.r,
            color: theme.shadowColor.withValues(alpha: 0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          child: GNav(
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
            rippleColor: colorScheme.surfaceContainerHighest,
            hoverColor: colorScheme.surfaceContainerHighest,
            gap: 8.w,
            activeColor: activeColor,
            color: inactiveColor,
            iconSize: 24.r,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: tabBg,
            tabBorderRadius: 12.r,
            tabBorder: Border.all(color: borderColor.withValues(alpha: 0.3)),
            tabActiveBorder: Border.all(color: borderColor),
            tabs: [
              GButton(icon: Icons.home_outlined, text: LocaleKeys.home_navHome.tr()),
              GButton(icon: Icons.shopping_cart_outlined, text: LocaleKeys.home_navCart.tr()),
              GButton(icon: Icons.add_box_outlined, text: LocaleKeys.home_navAddProduct.tr()),
            ],
          ),
        ),
      ),
    );
  }
}
