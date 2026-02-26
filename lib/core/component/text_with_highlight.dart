import 'package:flutter/material.dart';

//* Renders text with matching substrings highlighted (e.g. search results).
//? Case-insensitive; uses [highlightStyle] for matches, [style] for the rest.
class TextWithHighlight extends StatelessWidget {
  const TextWithHighlight({
    super.key,
    required this.text,
    required this.highlight,
    this.style,
    this.highlightStyle,
    this.maxLines,
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
    final highlightColor = theme.colorScheme.primaryContainer;
    final effectiveHighlightStyle = highlightStyle ??
        effectiveStyle.copyWith(
          fontWeight: FontWeight.w700,
          backgroundColor: highlightColor,
          color: theme.colorScheme.onPrimaryContainer,
        );

    if (highlight.trim().isEmpty) {
      return Text(
        text,
        style: effectiveStyle,
        maxLines: maxLines,
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

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(style: effectiveStyle, children: spans),
    );
  }
}
