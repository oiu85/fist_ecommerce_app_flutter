import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/localization/locale_keys.g.dart';
import '../../core/status/bloc_status.dart';
import '../../core/status/ui_helper.dart';

//* Cart loading skeleton — mirrors cart page layout with card-style items.
//? Uses SimpleSkeletonStatus; cart items match [CartItem] card layout.

class CartSkeleton extends StatelessWidget {
  const CartSkeleton({
    super.key,
    required this.status,
    this.itemCount = 3,
  });

  final BlocStatus status;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SimpleSkeletonStatus(
      state: status,
      child: CartSkeletonContent(itemCount: itemCount),
    );
  }
}

/// Cart skeleton content: title + cart item card placeholders.
class CartSkeletonContent extends StatelessWidget {
  const CartSkeletonContent({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
            child: Text(
              LocaleKeys.home_navCart.tr(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _CartItemCardSkeleton(colorScheme: colorScheme),
              childCount: itemCount,
            ),
          ),
        ),
      ],
    );
  }
}

/// Cart item card skeleton — matches [CartItem] card: Material, elevation, border.
class _CartItemCardSkeleton extends StatelessWidget {
  const _CartItemCardSkeleton({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: colorScheme.surface,
        elevation: 1,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 335.w,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* Image placeholder
                Skeleton.replace(
                  width: 96.r,
                  height: 96.r,
                  child: Container(
                    width: 96.r,
                    height: 96.r,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                //* Content: title, variant, quantity chip, price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton.replace(
                        child: Container(
                          height: 18.h,
                          width: 140.w,
                          color: colorScheme.surfaceContainerHighest,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Skeleton.replace(
                        child: Container(
                          height: 14.h,
                          width: 90.w,
                          color: colorScheme.surfaceContainerHighest,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Skeleton.replace(
                        child: Container(
                          height: 36.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(9999.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Skeleton.replace(
                        child: Container(
                          height: 20.h,
                          width: 70.w,
                          color: colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                //* Delete button placeholder
                Skeleton.replace(
                  width: 32.w,
                  height: 32.h,
                  child: Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
