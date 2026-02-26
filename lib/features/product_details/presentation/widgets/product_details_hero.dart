import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_color_extension.dart';
import 'back_button.dart';
import 'favourite_button.dart';

class ProductDetailsHero extends StatelessWidget {
  const ProductDetailsHero({
    super.key,
    required this.imageUrl,
    this.onBack,
    this.onFavourite,
  });

  final String imageUrl;
  final VoidCallback? onBack;
  final VoidCallback? onFavourite;

  bool get _isNetworkImage =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(24.r),
        bottomRight: Radius.circular(24.r),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 375.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
          //* Product image: asset or network
          _isNetworkImage
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (_, __, ___) => _buildErrorPlaceholder(context),
                )
              : Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildErrorPlaceholder(context),
                ),
          //* Bottom gradient overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    theme.extension<AppColorExtension>()?.imageOverlayScrim ??
                        Colors.black.withValues(alpha: 0.30),
                  ],
                ),
              ),
            ),
          ),
          //* Top buttons
          Positioned(
            left: 16.w,
            top: MediaQuery.paddingOf(context).top + 24.h,
            child: ProductDetailsBackButton(onPressed: onBack),
          ),
          Positioned(
            right: 16.w,
            top: MediaQuery.paddingOf(context).top + 24.h,
            child: FavouriteButton(onPressed: onFavourite),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(child: Icon(Icons.image_not_supported_outlined, size: 48)),
      );
}
