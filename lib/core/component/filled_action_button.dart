import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_text.dart';


class FilledActionButton extends StatelessWidget {
  FilledActionButton({
    super.key,
    required this.onTap,
    this.labelKey,
    this.label,
    this.icon,
    this.padding,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.spacing,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.isExpanded = true,
  }) : assert(
          labelKey != null || (label != null && label.isNotEmpty),
          'Either labelKey or label must be provided.',
        );

  final VoidCallback? onTap;
  final String? labelKey;
  final String? label;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? spacing;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final resolvedRadius = borderRadius ?? BorderRadius.circular(14.r);
    final resolvedPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h);
    final resolvedBackground = backgroundColor ?? colors.primary;
    final resolvedForeground = foregroundColor ?? colors.onPrimary;
    final labelSpacing = spacing ?? 10.w;

    final textWidget = AppText(
      labelKey ?? label!,
      translation: labelKey != null,
      style: textTheme.labelLarge?.copyWith(
        color: resolvedForeground,
        fontWeight: FontWeight.w600,
      ),
    );

    final content = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment:
          isExpanded ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        if (icon != null) ...[
          IconTheme(
            data: IconThemeData(color: resolvedForeground, size: 20.r),
            child: icon!,
          ),
          SizedBox(width: labelSpacing),
        ],
        Flexible(child: textWidget),
      ],
    );

    final buttonBody = Container(
      height: height ?? 52.h,
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: resolvedRadius,
        boxShadow: [
          BoxShadow(
            color: resolvedBackground.withAlpha(64),
            blurRadius: 12.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(child: content),
    );

    return Semantics(
      button: true,
      label: semanticLabel ?? label ?? labelKey,
      onTapHint: 'activate',
      child: Focus(
        focusNode: focusNode,
        autofocus: autofocus,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: resolvedRadius,
            splashColor: resolvedForeground.withAlpha(26),
            highlightColor: resolvedForeground.withAlpha(13),
            child: buttonBody,
          ),
        ),
      ),
    );
  }
}

