import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/animation/animation.dart';
import '../../../../core/component/search_field_with_filter.dart';
import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../gen/assets.gen.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({
    super.key,
    this.title,
    this.cartCount = 0,
    this.onSearchTap,
    this.onCartTap,
    this.isSearchMode = false,
    this.searchController,
    this.searchFocusNode,
    this.onSearchClosed,
    this.onSearchQueryChanged,
  });

  final String? title;
  final int cartCount;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;

  //* Search mode: when true, show search field and hide app logo + title
  final bool isSearchMode;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;
  final VoidCallback? onSearchClosed;
  final void Function(String)? onSearchQueryChanged;

  @override
  Size get preferredSize => Size.fromHeight(56.h + 16.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
          child: AnimatedSwitcher(
            duration: AnimationConstants.standard,
            switchInCurve: AnimationConstants.entranceCurve,
            switchOutCurve: AnimationConstants.exitCurve,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.05),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: AnimationConstants.entranceCurve)),
                child: child,
              ),
            ),
            child: KeyedSubtree(
              key: ValueKey(isSearchMode),
              child: isSearchMode ? _buildSearchMode(context) : _buildNormalMode(context),
            ),
          ),
        ),
      ),
    );
  }

  /// App bar in normal mode: logo, title, search icon, cart
  Widget _buildNormalMode(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    return Row(
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
          onPressed: onSearchTap != null
              ? () {
                  AppHaptic.lightTap();
                  onSearchTap!();
                }
              : null,
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
        _buildCartButton(context),
      ],
    );
  }

  /// App bar in search mode: search field, close button, cart (no logo, no title)
  Widget _buildSearchMode(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBarWithFilter(
            controller: searchController,
            focusNode: searchFocusNode,
            hintKey: LocaleKeys.app_search,
            onChanged: onSearchQueryChanged,
            showFilter: false,
            width: double.infinity,
          ),
        ),
        SizedBox(width: 8.w),
        IconButton(
          onPressed: () {
            AppHaptic.lightTap();
            onSearchClosed?.call();
          },
          icon: Icon(Icons.close, size: 24.r, color: Theme.of(context).colorScheme.onSurface),
          style: IconButton.styleFrom(
            minimumSize: Size(40.r, 40.r),
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
          ),
        ),
        SizedBox(width: 8.w),
        _buildCartButton(context),
      ],
    );
  }

  Widget _buildCartButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Badge(
      isLabelVisible: cartCount > 0,
      label: Text(cartCount > 99 ? '99+' : '$cartCount'),
      backgroundColor: colorScheme.primary,
      textColor: colorScheme.onPrimary,
      child: IconButton(
        onPressed: onCartTap != null
            ? () {
                AppHaptic.lightTap();
                onCartTap!();
              }
            : null,
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
    );
  }
}
