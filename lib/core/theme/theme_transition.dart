import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A widget that provides a smooth circular reveal transition
/// when switching between light and dark themes.
/// The animation starts from a specified position (e.g., theme button) and expands outward.
class ThemeTransition extends StatefulWidget {
  final Widget child;
  final ThemeMode themeMode;

  const ThemeTransition({
    super.key,
    required this.child,
    required this.themeMode,
  });

  /// Static variable to store the starting position for the reveal animation
  /// This should be set before changing the theme (e.g., from the theme button)
  static Offset? revealStartPosition;

  /// Set the starting position for the reveal animation
  static void setRevealStartPosition(Offset position) {
    revealStartPosition = position;
  }

  @override
  State<ThemeTransition> createState() => _ThemeTransitionState();
}

class _ThemeTransitionState extends State<ThemeTransition> {
  int _uniqueKeyCounter = 0;

  @override
  void didUpdateWidget(ThemeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only increment counter if theme actually changed
    if (oldWidget.themeMode != widget.themeMode) {
      _uniqueKeyCounter++; // Increment to ensure completely unique keys
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use AnimatedSwitcher with custom layoutBuilder to prevent duplicate GlobalKeys
    // The layoutBuilder ensures only the current child exists (no old widgets during transition)
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      layoutBuilder: (currentChild, previousChildren) {
        // Only show the current child, don't keep old widgets during transition
        // This prevents duplicate GlobalKeys from GoRouter
        return Stack(
          children: [
            if (currentChild != null) currentChild,
            // Don't include previousChildren to avoid duplicate GlobalKeys
          ],
        );
      },
      transitionBuilder: (child, animation) {
        return _CircularRevealTransition(
          animation: animation,
          startPosition: ThemeTransition.revealStartPosition,
          child: child,
        );
      },
      child: RepaintBoundary(
        key: ValueKey('theme-${widget.themeMode}-$_uniqueKeyCounter'),
        child: widget.child,
      ),
    );
  }
}

/// Custom transition that creates a circular reveal effect
/// from a specified starting position (e.g., theme button).
class _CircularRevealTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final Offset? startPosition;

  const _CircularRevealTransition({
    required this.child,
    required this.animation,
    this.startPosition,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipPath(
          clipper: _CircularRevealClipper(
            revealPercent: animation.value,
            startPosition: startPosition,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Custom clipper that creates a circular reveal effect
/// from a specified starting position (e.g., theme button).
class _CircularRevealClipper extends CustomClipper<Path> {
  final double revealPercent;
  final Offset? startPosition;

  _CircularRevealClipper({
    required this.revealPercent,
    this.startPosition,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    if (revealPercent <= 0.0) {
      // Start: no reveal (completely hidden)
      path.addRect(Rect.fromLTWH(0, 0, 0, 0));
      return path;
    }

    if (revealPercent >= 1.0) {
      // End: fully revealed
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      return path;
    }

    // Use provided start position or default to bottom-left corner
    final startX = startPosition?.dx ?? 0.0;
    final startY = startPosition?.dy ?? size.height;
    
    // End at top-right corner (or opposite corner from start)
    final endX = size.width;
    final endY = 0.0;

    // Interpolate the center point from start position to end position
    final centerX = startX + (endX - startX) * revealPercent;
    final centerY = startY + (endY - startY) * revealPercent;

    // Calculate the maximum radius needed to cover the entire screen
    // from the current center point
    final maxRadius = _calculateMaxRadius(
      centerX,
      centerY,
      size.width,
      size.height,
    );

    // Current radius based on animation progress
    // Use a curve to make the reveal smoother
    final curvedProgress = Curves.easeInOutCubic.transform(revealPercent);
    final radius = maxRadius * curvedProgress;

    // Create circular path
    path.addOval(
      Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: radius,
      ),
    );

    return path;
  }

  /// Calculate the maximum radius needed to cover the entire screen
  /// from the given center point.
  double _calculateMaxRadius(
    double centerX,
    double centerY,
    double width,
    double height,
  ) {
    // Calculate distances to all four corners
    final distances = [
      _distance(centerX, centerY, 0, 0), // Top-left
      _distance(centerX, centerY, width, 0), // Top-right
      _distance(centerX, centerY, 0, height), // Bottom-left
      _distance(centerX, centerY, width, height), // Bottom-right
    ];

    // Return the maximum distance (to the farthest corner)
    return distances.reduce((a, b) => a > b ? a : b);
  }

  /// Calculate Euclidean distance between two points.
  double _distance(double x1, double y1, double x2, double y2) {
    final dx = x2 - x1;
    final dy = y2 - y1;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  bool shouldReclip(_CircularRevealClipper oldClipper) {
    return oldClipper.revealPercent != revealPercent ||
        oldClipper.startPosition != startPosition;
  }
}

