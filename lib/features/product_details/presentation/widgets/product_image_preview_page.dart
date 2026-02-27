import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../gen/assets.gen.dart';

//* Full-screen zoomable image preview using photo_view.
//? Shown when user taps the crop icon on the product details hero.

class ProductImagePreviewPage extends StatelessWidget {
  const ProductImagePreviewPage({
    super.key,
    required this.imageUrl,
    required this.isNetworkImage,
  });

  final String imageUrl;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ImageProvider imageProvider =
        isNetworkImage ? NetworkImage(imageUrl) : AssetImage(imageUrl);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PhotoView(
            imageProvider: imageProvider,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.5,
            initialScale: PhotoViewComputedScale.contained,
            loadingBuilder: (_, __) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.image_not_supported_outlined, size: 64),
            ),
          ),
          //* Close button in top corner
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            right: 16,
            child: Material(
              color: theme.colorScheme.surface.withValues(alpha: 0.9),
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Assets.images.icons.closebutton.svg(
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
