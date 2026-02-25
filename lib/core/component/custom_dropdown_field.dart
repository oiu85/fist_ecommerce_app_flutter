import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_text.dart';
import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';

class CustomDropdownField<T> extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    this.labelKey,
    this.label,
    this.value,
    this.items,
    this.onChanged,
    this.height = 48,
  });

  final String? labelKey;
  final String? label;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Label
        if (labelKey != null || (label != null && label!.isNotEmpty)) ...[
          AppText(
            labelKey ?? label!,
            translation: labelKey != null,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 24 / 14,
              letterSpacing: 0,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
        ],
        //* Dropdown Field
        SizedBox(
          height: height.h,
          child: DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: colorScheme.surfaceVariant,
              contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11.r),
                borderSide: BorderSide(color: colorScheme.primary, width: 1.w),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11.r),
                borderSide: BorderSide(color: colorScheme.error, width: 1.w),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11.r),
                borderSide: BorderSide(color: colorScheme.error, width: 1.w),
              ),
            ),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 14.sp,
              fontFamily: FontFamily.sora,
              fontWeight: FontWeight.w400,
            ),
            icon: Assets.images.icons.dropDownIcon.svg(
              width: 18.w,
              height: 18.h,
              colorFilter: ColorFilter.mode(
                colorScheme.onSurface.withOpacity(0.6),
                BlendMode.srcIn,
              ),
            ),
        
            isExpanded: true,
            dropdownColor: colorScheme.surface,
          ),
        ),
      ],
    );
  }
}

