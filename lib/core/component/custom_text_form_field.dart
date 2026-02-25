import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_text.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.labelKey,
    this.label,
    this.hintKey,
    this.hint,
    this.helperKey,
    this.helper,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.onTap,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autocorrect = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.autofillHints,
    this.contentPadding,
    this.helperMaxLines,
    this.textCapitalization = TextCapitalization.none,
    this.textStyle,
    this.height,
  }) : assert(controller == null || initialValue == null, 'You cannot supply both a controller and an initialValue'),
       assert(maxLines == 1 || obscureText == false, 'Obscured text cannot have multiple lines');

  final TextEditingController? controller;
  final String? initialValue;

  final String? labelKey;
  final String? label;
  final String? hintKey;
  final String? hint;
  final String? helperKey;
  final String? helper;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autocorrect;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final EdgeInsetsGeometry? contentPadding;
  final int? helperMaxLines;
  final TextCapitalization textCapitalization;
  final TextStyle? textStyle;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (labelKey != null || (label != null && label!.isNotEmpty)) ...[
          AppText(
            labelKey ?? label!,
            translation: labelKey != null,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 24 / 14,
              // line-height 24px / font-size 14px
              letterSpacing: 0,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
        ],
        // Input Field
        SizedBox(
          height: height != null ? height!.h : null,
          child: TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            focusNode: focusNode,
            onTap: onTap,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            style:
                textStyle ??
                textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w400),
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            obscureText: obscureText,
            enabled: enabled,
            readOnly: readOnly,
            autocorrect: autocorrect,
            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            autofillHints: autofillHints,
            decoration: InputDecoration(
            hintText: hintKey != null ? hintKey!.tr() : hint,
            hintStyle: textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w400),
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11.r), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11.r), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.r),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.r),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.r),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1.w),
            ),
            errorStyle: TextStyle(
              fontSize: 12.sp,
              height: 1.2,
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w400,
            ),
            errorMaxLines: 2,
            isDense: true,
            counterText: '',
          ),
          ),
        ),
        // Helper text
        if (helperKey != null || (helper != null && helper!.isNotEmpty)) ...[
          SizedBox(height: 6.h),
          AppText(
            helperKey ?? helper!,
            translation: helperKey != null,
            maxLines: helperMaxLines ?? 2,
            style: textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
