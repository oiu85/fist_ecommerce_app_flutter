import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../gen/fonts.gen.dart';
import '../localization/locale_keys.g.dart';
import '../theme/app_color_extension.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.selectedIndex, required this.onTabChange, this.backgroundColor});

  final int selectedIndex;
  final ValueChanged<int> onTabChange;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        border: Border(
          top: BorderSide(width: 1, color: (appColors?.borderColor ?? colorScheme.outline).withValues(alpha: 0.3)),
        ),
        boxShadow: [
          BoxShadow(offset: Offset(0, -4.h), blurRadius: 12.r, color: theme.shadowColor.withValues(alpha: 0.08)),
        ],
      ),
      child: SafeArea(
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
            textStyle: textTheme.labelSmall?.copyWith(fontFamily: FontFamily.sora, fontWeight: FontWeight.w600),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            tabMargin: EdgeInsets.symmetric(horizontal: 2.w),
            tabBackgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.35),
            tabBorderRadius: 24.r,
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
