import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../gen/assets.gen.dart';

class SearchBarWithFilter extends StatelessWidget {
  const SearchBarWithFilter({
    super.key,
    this.controller,
    this.hintKey,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.width,
    this.textInputAction,
    this.autocorrect = true,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.inputFormatters,
  }) : assert(
         hintKey != null || hint != null,
         'Either hintKey or hint must be provided.',
       );

  final TextEditingController? controller;
  final String? hintKey;
  final String? hint;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onFilterTap;
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;
  final double? width;
  final TextInputAction? textInputAction;
  final bool autocorrect;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    //* Main Container
    return Container(
      height: 49.h,
      width: width ?? 356.w,
      //* Container Decoration
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.w,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(24.50.r),
        ),
      ),
      child: Row(
        children: [
          //* Search Input Section
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: TextField(
                //* TextField Properties
                controller: controller,
                focusNode: focusNode,
                enabled: enabled,
                readOnly: readOnly,
                autocorrect: autocorrect,
                textCapitalization: textCapitalization,
                textInputAction: textInputAction ?? TextInputAction.search,
                maxLength: maxLength,
                inputFormatters: inputFormatters,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                textAlignVertical: TextAlignVertical.center,
                //* TextField Style
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                //* TextField Decoration
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surface,
                  hintText: hintKey != null ? hintKey!.tr() : hint,
                  //* Hint Style
                  hintStyle: textTheme.titleMedium?.copyWith(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  //* Search Icon
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Assets.images.icons.search.svg(
                      width: 18.w,
                      height: 18.h,
                      colorFilter: ColorFilter.mode(
                        colorScheme.secondary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 18.w,
                    minHeight: 18.h,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  //* Border Styles
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  counterText: '',
                  isDense: true,
                ),
              ),
            ),
          ),
          //* Filter Button Section
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 5.5.w, top: 5.h, bottom: 4.h),
              child: GestureDetector(
                onTap: onFilterTap,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  //* Filter Button Decoration
                  decoration: ShapeDecoration(
                    color: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.w,
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                        bottomLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(24.r),
                      ),
                    ),
                  ),
                  //* Filter Icon
                  child: Center(
                    child: Assets.images.icons.filter.svg(
                      width: 40.w,
                      height: 40.h,
                    ),
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
