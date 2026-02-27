import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

//* Home skeleton content — categories + products; mirrors [HomeContent].
class HomeSkeletonContent extends StatelessWidget {
  const HomeSkeletonContent({
    super.key,
    this.categoryLayoutStyle = CategorySkeletonLayoutStyle.row,
    this.productCardCount = 6,
  });

  /// Row = horizontal chips; grid = 2-column category cards.
  final CategorySkeletonLayoutStyle categoryLayoutStyle;

  /// Number of product card placeholders.
  final int productCardCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: <Widget>[
        //* Category section: header + chips/grid
        SliverToBoxAdapter(
          child: ColoredBox(
            color: colorScheme.surface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CategoryHeaderSkeleton(),
                if (categoryLayoutStyle == CategorySkeletonLayoutStyle.row)
                  _CategoryChipsRowSkeleton()
                else
                  _CategoryGridSkeleton(),
              ],
            ),
          ),
        ),
        //* Product section: header
        SliverToBoxAdapter(
          child: ColoredBox(
            color: colorScheme.surface,
            child: _ProductHeaderSkeleton(),
          ),
        ),
        //* Product grid: cards
        SliverPadding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 8.h,
            bottom: MediaQuery.of(context).viewPadding.bottom + 90.h,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 163.5 / 283.5,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _ProductCardSkeleton(),
              childCount: productCardCount,
            ),
          ),
        ),
      ],
    );
  }
}

/// Layout style for category skeleton (row chips vs grid cards).
enum CategorySkeletonLayoutStyle { row, grid }

//* Category header: title + icon — bone placeholders for Skeletonizer.
class _CategoryHeaderSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Categories', style: TextStyle(fontSize: 16.sp)),
          SizedBox(width: 40.r, height: 40.r),
        ],
      ),
    );
  }
}

//* Horizontal row of category chips — mirrors [HomeCategorySection] row layout.
class _CategoryChipsRowSkeleton extends StatelessWidget {
  static const int _chipCount = 5;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 55.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: 20.w, right: 52.w, top: 4.h, bottom: 0),
        itemCount: _chipCount,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, index) => Skeleton.replace(
          child: Container(
            width: 106.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(9999.r),
            ),
          ),
        ),
      ),
    );
  }
}

//* 2-column category grid — mirrors [HomeCategoryGrid] category cards.
class _CategoryGridSkeleton extends StatelessWidget {
  static const int _cardCount = 4;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final horizontalPadding = 20.w;
    final cardWidth =
        (MediaQuery.sizeOf(context).width - horizontalPadding * 2 - 12.w) / 2;

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: 4.h,
        bottom: 12.h,
      ),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: List.generate(_cardCount, (_) {
          return Skeleton.replace(
            child: Container(
              width: cardWidth,
              height: 72.h,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }),
      ),
    );
  }
}

//* Product header: title + icon.
class _ProductHeaderSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Products', style: TextStyle(fontSize: 16.sp)),
          SizedBox(width: 40.r, height: 40.r),
        ],
      ),
    );
  }
}

//* Single product card skeleton — mirrors [ProductCard] (163.5×283.5, image + title + rating + price).
class _ProductCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 0.5,
          color: colorScheme.outline.withValues(alpha: 0.25),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          //* Image area
          Expanded(
            flex: 3,
            child: Container(
              color: colorScheme.surfaceContainer,
            ),
          ),
          //* Content: title, rating, price
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title (2 lines)
                  Text(
                    'Product name placeholder text',
                    style: TextStyle(fontSize: 14.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  // Rating
                  SizedBox(
                    height: 14.h,
                    width: 80.w,
                    child: Container(
                      color: colorScheme.surfaceContainerHighest,
                      margin: EdgeInsets.only(right: 4.w),
                    ),
                  ),
                  const Spacer(),
                  // Price
                  SizedBox(
                    height: 18.h,
                    width: 60.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
