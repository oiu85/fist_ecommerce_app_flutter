import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_color_extension.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({
    super.key,
    this.title,
    this.cartCount = 0,
    this.onSearchTap,
    this.onCartTap,
  });

  final String? title;
  final int cartCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;

  static const double _logoSize = 32;
  static const double _logoRadius = 8;
  static const double _actionSize = 40;
  static const double _horizontalPadding = 20;
  static const double _spacing = 8;

  @override
  Size get preferredSize => Size.fromHeight(56.h + 16.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();
    final borderColor = appColors?.borderColor ?? colorScheme.outline;

    final useTitleKey = title == null;
    final effectiveTitle = title ?? LocaleKeys.home_appBarTitle;
    final titleStyle = textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w700,
      height: 1.4,
      letterSpacing: -0.5,
      color: colorScheme.onSurface,
    );

    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(width: 1, color: borderColor),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding.w),
          child: Row(
            children: [
              Container(
                width: _logoSize.r,
                height: _logoSize.r,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(_logoRadius.r),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.store_outlined,
                  size: 18.r,
                  color: colorScheme.onPrimary,
                ),
              ),
              SizedBox(width: _spacing.w),
              Expanded(
                child: AppText(
                  effectiveTitle,
                  translation: useTitleKey,
                  style: titleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: _spacing.w),
              IconButton(
                onPressed: onSearchTap,
                icon: Icon(
                  Icons.search,
                  size: 24.r,
                  color: colorScheme.onSurface,
                ),
                style: IconButton.styleFrom(
                  minimumSize: Size(_actionSize.r, _actionSize.r),
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                ),
              ),
              SizedBox(width: _spacing.w),
              Badge(
                isLabelVisible: cartCount > 0,
                label: Text(cartCount > 99 ? '99+' : '$cartCount'),
                backgroundColor: colorScheme.primary,
                textColor: colorScheme.onPrimary,
                child: IconButton(
                  onPressed: onCartTap,
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: 24.r,
                    color: colorScheme.onSurface,
                  ),
                  style: IconButton.styleFrom(
                    minimumSize: Size(_actionSize.r, _actionSize.r),
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
