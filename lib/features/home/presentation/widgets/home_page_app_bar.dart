import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../gen/assets.gen.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({super.key, this.title, this.cartCount = 0, this.onSearchTap, this.onCartTap});

  final String? title;
  final int cartCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;

  @override
  Size get preferredSize => Size.fromHeight(56.h + 16.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(width: 1, color: appColors?.borderColor ?? colorScheme.outline)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: appColors?.primaryNavy ?? colorScheme.onSurface, width: 1),
                ),
                child: Center(
                  child: Assets.images.icons.shop.svg(
                    width: 18.r,
                    height: 18.r,
                    colorFilter: ColorFilter.mode(colorScheme.onPrimary, BlendMode.srcIn),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: AppText(
                  title ?? LocaleKeys.home_appBarTitle,
                  translation: title == null,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: appColors?.primaryNavy ?? colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  isAutoScale: true,
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: onSearchTap,
                icon: Assets.images.icons.search.svg(
                  width: 24.r,
                  height: 24.r,
                  colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
                ),
                style: IconButton.styleFrom(
                  minimumSize: Size(40.r, 40.r),
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                ),
              ),
              SizedBox(width: 8.w),
              Badge(
                isLabelVisible: cartCount > 0,
                label: Text(cartCount > 99 ? '99+' : '$cartCount'),
                backgroundColor: colorScheme.primary,
                textColor: colorScheme.onPrimary,
                child: IconButton(
                  onPressed: onCartTap,
                  icon: Assets.images.icons.cart.svg(
                    width: 24.r,
                    height: 24.r,
                    colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
                  ),
                  style: IconButton.styleFrom(
                    minimumSize: Size(40.r, 40.r),
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
