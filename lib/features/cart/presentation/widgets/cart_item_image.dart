import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/util/app_cached_network_image.dart';

class CartItemImage extends StatelessWidget {
  const CartItemImage({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.backgroundColor,
    required this.borderColor,
  });

  final String imageUrl;
  final double size;
  final Color backgroundColor;
  final Color borderColor;

  static bool _isAssetPath(String url) => url.trim().toLowerCase().startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: _isAssetPath(imageUrl)
          ? Image.asset(
              imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _errorIcon(context),
            )
          : AppCachedNetworkImage(
              imageUrl: imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(12.r),
              formatUrl: true,
              errorWidget: _errorIcon(context),
            ),
    );
  }

  Widget _errorIcon(BuildContext context) {
    return Center(
      child: Icon(Icons.broken_image_outlined, size: size * 0.4, color: Theme.of(context).colorScheme.outline),
    );
  }
}
