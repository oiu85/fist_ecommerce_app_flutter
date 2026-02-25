
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import '../localization/app_text.dart';

class CustomRadioButton<T> extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.labelKey,
    this.spacing = 8,
  });

  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final String labelKey;
  final double spacing;

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () => onChanged?.call(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
            fillColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return colorScheme.primary;
                }
                return colorScheme.onSurface;
              },
            ),
          ),
          if (spacing > 0) SizedBox(width: spacing.w),
          AppText(
            labelKey,
            translation: true,
            style: textTheme.bodyMedium?.copyWith(
              color: _isSelected ? colorScheme.primary : colorScheme.onSurface,
              fontSize: 14.sp,
              fontFamily: FontFamily.sora,
              fontWeight: _isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

