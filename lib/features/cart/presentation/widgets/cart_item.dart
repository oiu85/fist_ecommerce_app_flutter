import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/quantity_counter_chip.dart';
import '../../../../core/localization/app_text.dart';
import '../../../../core/theme/app_color_extension.dart';
import '../../../../gen/assets.gen.dart';

import 'cart_item_image.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.variant,
    required this.quantity,
    required this.priceFormatted,
    required this.onQuantityChanged,
    required this.onDelete,
    this.maxQuantity,
  });

  final String imageUrl;
  final String name;
  final String variant;
  final int quantity;
  final String priceFormatted;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDelete;
  final int? maxQuantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final appColors = theme.extension<AppColorExtension>();

    final borderColor = appColors?.borderColor ?? colorScheme.outline;
    final surfaceColor = colorScheme.surface;
    final surfaceHighest = colorScheme.surfaceContainerHighest;

    return RepaintBoundary(
      child: Container(
        width: 335.w,
        constraints: BoxConstraints(minHeight: 144.h),
        decoration: ShapeDecoration(
          color: surfaceColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadows: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.12),
              blurRadius: 2,
              offset: const Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        //* 3-column layout: image | content | delete — delete no longer constrains price
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Column 1: Image
              CartItemImage(imageUrl: imageUrl, size: 96.r, backgroundColor: surfaceHighest, borderColor: borderColor),
              SizedBox(width: 16.w),
              //* Column 2: Name, variant, quantity, price — full width, no overlay padding
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      name,
                      translation: false,
                      style: textTheme.titleMedium?.copyWith(
                        color: appColors?.primaryNavy ?? colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      isAutoScale: true,
                    ),
                    SizedBox(height: 4.h),
                    AppText(
                      variant,
                      translation: false,
                      isAutoScale: true,
                      maxLines: 1,
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(height: 12.h),
                    //* Quantity chip row
                    QuantityCounterChip(
                      value: quantity,
                      minValue: 1,
                      maxValue: maxQuantity,
                      onDecrement: () => onQuantityChanged(quantity - 1),
                      onIncrement: () => onQuantityChanged(quantity + 1),
                      backgroundColor: surfaceHighest,
                      borderColor: borderColor,
                    ),
                    SizedBox(height: 8.h),
                    AppText(
                      priceFormatted,
                      translation: false,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: appColors?.primaryNavy ?? colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      isAutoScale: false,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              //* Column 3: Delete button — fixed column, does not constrain content
              _DeleteButton(
                onTap: onDelete,
                borderColor: borderColor,
                surfaceHighest: surfaceHighest,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Delete action button — extracted for clarity and reuse.
class _DeleteButton extends StatelessWidget {
  const _DeleteButton({
    required this.onTap,
    required this.borderColor,
    required this.surfaceHighest,
    required this.colorScheme,
  });

  final VoidCallback onTap;
  final Color borderColor;
  final Color surfaceHighest;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9999.r),
        splashColor: colorScheme.error.withValues(alpha: 0.16),
        highlightColor: colorScheme.error.withValues(alpha: 0.08),
        child: Container(
          width: 32.w,
          height: 32.h,
          decoration: ShapeDecoration(
            color: surfaceHighest,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(9999.r),
            ),
          ),
          child: Center(
            child: Assets.images.icons.delete.svg(
              width: 14.w,
              height: 14.h,
              colorFilter: ColorFilter.mode(colorScheme.error, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
