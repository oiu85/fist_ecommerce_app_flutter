import 'package:flutter/widgets.dart';

enum AppSizeClass { mobile, desktop }

// Backward-compatible API (still available if used elsewhere)
AppSizeClass sizeClassFor(BoxConstraints constraints) =>
    constraints.maxWidth > constraints.maxHeight ? AppSizeClass.desktop : AppSizeClass.mobile;

// Simpler bool helpers - Desktop is when width is greater than height (landscape orientation)
bool isDesktopLayout(BoxConstraints constraints) => constraints.maxWidth > constraints.maxHeight;
bool isMobileLayout(BoxConstraints constraints) => constraints.maxWidth <= constraints.maxHeight;

// Optional context-based helpers
bool isDesktopContext(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return size.width > size.height;
}

bool isMobileContext(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return size.width <= size.height;
}
