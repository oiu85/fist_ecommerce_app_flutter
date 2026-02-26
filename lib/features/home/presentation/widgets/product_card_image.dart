import 'package:flutter/material.dart';

import '../../../../core/util/app_cached_network_image.dart';

class ProductCardImage extends StatelessWidget {
  const ProductCardImage({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.borderColor,
    required this.backgroundColor,
    this.formatUrl = false,
  });

  final String imageUrl;
  final double size;
  final Color borderColor;
  final Color backgroundColor;
  final bool formatUrl;

  static bool isAssetPath(String url) =>
      url.trim().toLowerCase().startsWith('assets/');

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: isAssetPath(imageUrl)
              ? Image.asset(
                  imageUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _defaultError(context),
                )
              : AppCachedNetworkImage(
                  imageUrl: imageUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  formatUrl: formatUrl,
                ),
        ),
      ),
    );
  }

  Widget _defaultError(BuildContext context) {

    return Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: size > 0 ? (size * 0.5) : 24,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
