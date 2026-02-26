import 'package:flutter/material.dart';

import '../../../../core/status/bloc_status.dart';
import '../../../../core/status/ui_helper.dart';
import '../../../../skeleton_features/skeleton_features.dart';



class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({
    super.key,
    required this.status,
    this.categoryLayoutStyle = CategorySkeletonLayoutStyle.row,
    this.productCardCount = 6,
  });

  final BlocStatus status;

  /// Skeleton category layout: row (chips) or grid (cards).
  final CategorySkeletonLayoutStyle categoryLayoutStyle;

  /// Number of product card placeholders.
  final int productCardCount;

  @override
  Widget build(BuildContext context) {
    return SimpleSkeletonStatus(
      state: status,
      child: HomeSkeletonContent(
        categoryLayoutStyle: categoryLayoutStyle,
        productCardCount: productCardCount,
      ),
    );
  }
}
