import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/animation/animation.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../gen/assets.gen.dart';

//* Empty cart state widget — shows loading spinner or empty message with cart icon.
//? Reusable; used when cart has no items.

class CartEmptyWidget extends StatelessWidget {
  const CartEmptyWidget({
    super.key,
    required this.isLoading,
    this.cartItemsKey,
  });

  final bool isLoading;
  final GlobalKey? cartItemsKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AnimatedSection(
            sectionIndex: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
              child: AppText(
                LocaleKeys.home_navCart,
                translation: true,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: _wrapWithKey(
            cartItemsKey,
            Center(
              child: isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.images.icons.cart.svg(
                        width: 80.r,
                        height: 80.r,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppText(
                        LocaleKeys.cart_empty,
                        translation: true,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _wrapWithKey(GlobalKey? key, Widget child) {
    if (key == null) return child;
    return KeyedSubtree(key: key, child: child);
  }
}
