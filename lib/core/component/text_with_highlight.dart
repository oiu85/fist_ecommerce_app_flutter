import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../localization/app_text.dart';

//* Renders text with matching substrings highlighted (e.g. search results).
//? Case-insensitive; uses [highlightStyle] for matches, [style] for the rest.
class TextWithHighlight extends StatelessWidget {
  const TextWithHighlight({
    super.key,
    required this.text,
    required this.highlight,
    this.style,
    this.highlightStyle,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
  });

  final String text;
  final String highlight;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final int? maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;
    final theme = Theme.of(context);
    final highlightBg = theme.colorScheme.primary;
    final effectiveHighlightStyle = highlightStyle ??
        effectiveStyle.copyWith(
          fontWeight: FontWeight.w800,
          backgroundColor: highlightBg,
          color: theme.colorScheme.onPrimary,
          decoration: TextDecoration.none,
        );


    if (highlight.trim().isEmpty) {
      return AppText(
        text,
        translation: false,
        isAutoScale: true,
        maxLines: maxLines ?? 2,
        style: effectiveStyle,
        overflow: overflow,
      );
    }

    final query = highlight.trim().toLowerCase();
    final lower = text.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (start < text.length) {
      final matchIndex = lower.indexOf(query, start);
      if (matchIndex < 0) {
        spans.add(TextSpan(
          text: text.substring(start),
          style: effectiveStyle,
        ));
        break;
      }
      if (matchIndex > start) {
        spans.add(TextSpan(
          text: text.substring(start, matchIndex),
          style: effectiveStyle,
        ));
      }
      spans.add(TextSpan(
        text: text.substring(matchIndex, matchIndex + query.length),
        style: effectiveHighlightStyle,
      ));
      start = matchIndex + query.length;
    }

    return AutoSizeText.rich(
      TextSpan(style: effectiveStyle, children: spans),
      maxLines: maxLines ?? 2,
      overflow: overflow,
      style: effectiveStyle,
    );
  }
}
