import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/status/bloc_status.dart';
import '../../core/status/ui_helper.dart';

//* Add Product loading skeleton — mirrors add product form layout.
//? Uses SimpleSkeletonStatus; includes category chips matching [AddProductCategorySection].

class AddProductSkeleton extends StatelessWidget {
  const AddProductSkeleton({
    super.key,
    required this.status,
  });

  final BlocStatus status;

  @override
  Widget build(BuildContext context) {
    return SimpleSkeletonStatus(
      state: status,
      child: const AddProductSkeletonContent(),
    );
  }
}

/// Add product form skeleton: placeholder fields + category chips + image URL.
class AddProductSkeletonContent extends StatelessWidget {
  const AddProductSkeletonContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FormFieldSkeleton(height: 56.h),
          SizedBox(height: 24.h),
          _FormFieldSkeleton(height: 56.h),
          SizedBox(height: 24.h),
          _FormFieldSkeleton(height: 150.h),
          SizedBox(height: 24.h),
          //* Category label
          Skeleton.replace(
            child: Container(
              height: 14.h,
              width: 80.w,
              color: colorScheme.surfaceContainerHighest,
            ),
          ),
          SizedBox(height: 12.h),
          //* Category chips row — matches [AddProductCategorySection] row layout
          _CategoryChipsSkeleton(colorScheme: colorScheme),
          SizedBox(height: 24.h),
          _FormFieldSkeleton(height: 56.h),
        ],
      ),
    );
  }
}

/// Category chips skeleton — horizontal row of chip placeholders.
class _CategoryChipsSkeleton extends StatelessWidget {
  const _CategoryChipsSkeleton({required this.colorScheme});

  final ColorScheme colorScheme;

  static const int _chipCount = 5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _chipCount,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, __) => Skeleton.replace(
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

class _FormFieldSkeleton extends StatelessWidget {
  const _FormFieldSkeleton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 12.h,
          width: 100.w,
          color: colorScheme.surfaceContainerHighest,
        ),
        SizedBox(height: 8.h),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ],
    );
  }
}
