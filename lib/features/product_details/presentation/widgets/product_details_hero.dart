import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../gen/assets.gen.dart';
import 'back_button.dart';
import 'favourite_button.dart';
import 'product_image_preview_page.dart';

//* Hero section for product details: full image (contain), overlay, back/fav and crop icon.
class ProductDetailsHero extends StatelessWidget {
  const ProductDetailsHero({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.onBack,
    this.onFavourite,
  });

  final String imageUrl;
  /// Unique tag for Hero animation (must match home card/list).
  final String? heroTag;
  final VoidCallback? onBack;
  final VoidCallback? onFavourite;

  bool get _isNetworkImage =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    //* Locale-aware: back at start, favourite at end (RTL swaps sides).
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final startInset = 16.w;
    final endInset = 16.w;
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
            //* Background so letterboxing looks consistent when image doesn’t fill
            Positioned.fill(
              child: ColoredBox(
                color: colorScheme.surfaceContainerHighest,
              ),
            ),
            //* Product image: full image visible (no crop); Hero when [heroTag] set
            _buildHeroImage(context),
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
            //* Top buttons: back at start, favourite at end (locale-aware)
            Positioned(
              left: isRtl ? null : startInset,
              right: isRtl ? endInset : null,
              top: MediaQuery.paddingOf(context).top + 24.h,
              child: ProductDetailsBackButton(onPressed: onBack),
            ),
            Positioned(
              left: isRtl ? endInset : null,
              right: isRtl ? null : endInset,
              top: MediaQuery.paddingOf(context).top + 24.h,
              child: FavouriteButton(onPressed: onFavourite),
            ),
            //* Crop icon: open full-screen zoomable preview (locale-aware end)
            Positioned(
              left: isRtl ? endInset : null,
              right: isRtl ? null : endInset,
              bottom: 16.h,
              child: Material(
                color: colorScheme.surface.withValues(alpha: 0.9),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    AppHaptic.lightTap();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ProductImagePreviewPage(
                          imageUrl: imageUrl,
                          isNetworkImage: _isNetworkImage,
                        ),
                      ),
                    );
                  },
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Assets.images.icons.crop.svg(
                      width: 22.r,
                      height: 22.r,
                      colorFilter: ColorFilter.mode(
                        colorScheme.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    final image = _isNetworkImage
        ? Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (_, __, ___) => _buildErrorPlaceholder(context),
          )
        : Image.asset(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _buildErrorPlaceholder(context),
          );
    if (heroTag != null && heroTag!.isNotEmpty) {
      return Hero(
        tag: heroTag!,
        child: image,
      );
    }
    return image;
  }

  Widget _buildErrorPlaceholder(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(
            child: Icon(Icons.image_not_supported_outlined, size: 48)),
      );
}
