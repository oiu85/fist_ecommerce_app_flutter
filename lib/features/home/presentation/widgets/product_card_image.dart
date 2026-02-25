import 'package:flutter/material.dart';

import '../../../../core/util/app_cached_network_image.dart';

class ProductCardImage extends StatelessWidget {
  const ProductCardImage({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.borderColor,
    required this.backgroundColor,
    this.imagePadding = 16,
    this.formatUrl = false,
  });
  final String imageUrl;
  final double size;
  final Color borderColor;
  final Color backgroundColor;
  final double imagePadding;
  final bool formatUrl;

  @override
  Widget build(BuildContext context) {
    final innerSize = size - (imagePadding * 2);

    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: borderColor),
        ),
      ),
      child: Center(
        child: Container(
          width: innerSize > 0 ? innerSize : size,
          height: innerSize > 0 ? innerSize : size,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: borderColor),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: AppCachedNetworkImage(
            imageUrl: imageUrl,
            width: innerSize > 0 ? innerSize : null,
            height: innerSize > 0 ? innerSize : null,
            fit: BoxFit.cover,
            formatUrl: formatUrl,
          ),
        ),
      ),
    );
  }
}
