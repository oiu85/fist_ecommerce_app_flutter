import 'dart:ui';

import 'package:flutter/material.dart';

import 'spring_curves.dart';

/// Configuration for the origin shape from which the overlay expands.
///
/// The overlay morphs from this origin (position, size, border-radius,
/// color) into the expanded panel.
class MorphOrigin {
  const MorphOrigin({
    required this.centerX,
    required this.centerY,
    required this.width,
    required this.height,
    this.color = const Color(0x194688E7),
    this.borderRadius,
  });

  /// Horizontal center of the origin element (in logical pixels).
  final double centerX;

  /// Vertical center of the origin element (in logical pixels).
  final double centerY;

  /// Width of the origin element.
  final double width;

  /// Height of the origin element.
  final double height;

  /// Background color of the origin element.
  final Color color;

  /// Border radius of the origin. Defaults to fully-round (pill shape).
  final BorderRadius? borderRadius;

  /// Fully-round pill border radius based on [height].
  BorderRadius get pillRadius => BorderRadius.circular(height / 2);
}

/// Configuration for the expanded panel destination.
class MorphDestination {
  const MorphDestination({
    required this.top,
    required this.maxHeight,
    this.left = 0.0,
    this.width,
    this.color = Colors.white,
    this.borderRadius,
    this.shadows,
  });

  /// Top offset of the expanded panel.
  final double top;

  /// Left offset of the expanded panel. Defaults to 0 (full-width).
  final double left;

  /// Width of the expanded panel. Defaults to screen width.
  final double? width;

  /// Maximum height of the expanded panel.
  final double maxHeight;

  /// Background color of the expanded panel.
  final Color color;

  /// Border radius of the expanded panel.
  final BorderRadius? borderRadius;

  /// Box shadows for the expanded panel.
  final List<BoxShadow>? shadows;
}

/// Timing configuration for the morphing overlay animations.
class MorphTiming {
  const MorphTiming({
    this.expandDuration = const Duration(milliseconds: 500),
    this.collapseDuration = const Duration(milliseconds: 280),
    this.expandCurve,
    this.collapseCurve = Curves.easeInCubic,
    this.contentFadeInterval = const Interval(
      0.35,
      0.75,
      curve: Curves.easeOut,
    ),
    this.backdropInterval = const Interval(0.0, 0.4, curve: Curves.easeOut),
    this.maxBlurSigma = 12.0,
    this.maxDimAlpha = 0.18,
  });

  /// Duration of the expand animation.
  final Duration expandDuration;

  /// Duration of the collapse animation.
  final Duration collapseDuration;

  /// Curve for the expand animation. Defaults to [AppleSpringCurve.bouncy].
  final Curve? expandCurve;

  /// Curve for the collapse animation.
  final Curve collapseCurve;

  /// Interval during which the panel content fades in (normalised 0–1).
  final Interval contentFadeInterval;

  /// Interval during which the backdrop blur/dim activates (normalised 0–1).
  final Interval backdropInterval;

  /// Maximum gaussian blur sigma for the backdrop.
  final double maxBlurSigma;

  /// Maximum dim alpha (0–1) for the backdrop overlay.
  final double maxDimAlpha;
}

/// Builder that receives the dismiss callback so content can trigger close.
typedef MorphContentBuilder =
    Widget Function(BuildContext context, VoidCallback dismiss);

/// A reusable overlay widget that morphs from an origin shape to an
/// expanded panel with iOS Dynamic Island-style spring animation.
///
/// Features:
/// - Spring physics matching Apple's SwiftUI presets
/// - Background gaussian blur + dim
/// - Smooth color, position, size, and border-radius interpolation
/// - Content fade-in during expansion
/// - Tap-to-dismiss on the backdrop
///
/// Usage:
/// ```dart
/// static OverlayEntry? _overlay;
///
/// void show(BuildContext context) {
///   final overlay = Overlay.of(context);
///   late OverlayEntry entry;
///   entry = OverlayEntry(
///     builder: (_) => MorphingOverlay(
///       origin: MorphOrigin(
///         centerX: screenW / 2,
///         centerY: statusBarH + kToolbarHeight / 2,
///         width: 200,
///         height: 40,
///         color: Colors.blue.shade50,
///       ),
///       destination: MorphDestination(
///         top: statusBarH,
///         maxHeight: screenH * 0.55,
///         color: Colors.white,
///       ),
///       onDismiss: () {
///         entry.remove();
///         _overlay = null;
///       },
///       contentBuilder: (context, dismiss) {
///         return MyPanelContent(onClose: dismiss);
///       },
///     ),
///   );
///   _overlay = entry;
///   overlay.insert(entry);
/// }
/// ```
class MorphingOverlay extends StatefulWidget {
  const MorphingOverlay({
    super.key,
    required this.origin,
    required this.destination,
    required this.onDismiss,
    required this.contentBuilder,
    this.timing = const MorphTiming(),
  });

  /// The shape and position the overlay morphs from.
  final MorphOrigin origin;

  /// The shape and position the overlay morphs to.
  final MorphDestination destination;

  /// Called when the dismiss animation completes.
  final VoidCallback onDismiss;

  /// Builds the expanded panel content.
  final MorphContentBuilder contentBuilder;

  /// Animation timing configuration.
  final MorphTiming timing;

  @override
  State<MorphingOverlay> createState() => _MorphingOverlayState();
}

class _MorphingOverlayState extends State<MorphingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.timing.expandDuration,
      reverseDuration: widget.timing.collapseDuration,
    );
    _controller.forward();
  }

  /// Triggers the reverse (collapse) animation and calls [onDismiss].
  Future<void> _dismiss() async {
    if (_isDismissing) return;
    _isDismissing = true;
    await _controller.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final origin = widget.origin;
    final dest = widget.destination;
    final timing = widget.timing;

    final expandCurve = timing.expandCurve ?? AppleSpringCurve.bouncy;
    final destW = dest.width ?? screenW;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final rawT = _controller.value;

        // Apply spring for forward, easeIn for reverse.
        final springT = _controller.status == AnimationStatus.reverse
            ? timing.collapseCurve.transform(rawT)
            : expandCurve.transform(rawT);

        // ── Container dimensions ──
        final containerW = origin.width + (destW - origin.width) * springT;
        final containerMaxH =
            origin.height + (dest.maxHeight - origin.height) * springT;

        // ── Position: origin center → destination top-left ──
        final originLeft = origin.centerX - origin.width / 2;
        final destLeft = dest.left;
        final left = originLeft + (destLeft - originLeft) * springT;

        final originTop = origin.centerY - origin.height / 2;
        final top = originTop + (dest.top - originTop) * springT;

        // ── Border radius interpolation ──
        final originBR = origin.borderRadius ?? origin.pillRadius;
        final destBR =
            dest.borderRadius ??
            BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.zero,
              bottomLeft: Radius.circular(origin.height / 2),
              bottomRight: Radius.circular(origin.height / 2),
            );
        final borderRadius = BorderRadius.lerp(originBR, destBR, springT)!;

        // ── Background colour interpolation ──
        final colorT = (springT * 2.5).clamp(0.0, 1.0);
        final bgColor = Color.lerp(origin.color, dest.color, colorT)!;

        // ── Content fade ──
        final contentOpacity = timing.contentFadeInterval.transform(rawT);

        // ── Backdrop blur + dim ──
        final backdropT = timing.backdropInterval.transform(rawT);
        final blurSigma = timing.maxBlurSigma * backdropT;
        final dimAlpha = timing.maxDimAlpha * backdropT;

        // ── Shadow intensity ──
        final shadowAlpha = springT.clamp(0.0, 1.0);
        final shadows = dest.shadows?.map((s) {
          return BoxShadow(
            color: s.color.withValues(alpha: (s.color.a * shadowAlpha)),
            blurRadius: s.blurRadius,
            offset: s.offset,
            spreadRadius: s.spreadRadius,
          );
        }).toList();

        // Default iOS-style shadows if none provided.
        final boxShadows =
            shadows ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08 * shadowAlpha),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12 * shadowAlpha),
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              ),
            ];

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // ── Blurred + dimmed backdrop ──
              Positioned.fill(
                child: GestureDetector(
                  onTap: _dismiss,
                  behavior: HitTestBehavior.opaque,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurSigma,
                      sigmaY: blurSigma,
                    ),
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: dimAlpha),
                    ),
                  ),
                ),
              ),
              // ── Expanding panel container ──
              Positioned(
                left: left,
                top: top,
                child: Container(
                  width: containerW,
                  constraints: BoxConstraints(maxHeight: containerMaxH),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: borderRadius,
                    boxShadow: boxShadows,
                  ),
                  clipBehavior: Clip.antiAlias,
                  // Skip rendering content until the container has expanded
                  // enough to fit it (springT >= 0.7 means ~70% expanded).
                  // This avoids RenderFlex overflow during expand/collapse
                  // when the container is too small for content's intrinsic size.
                  child: springT < 0.7
                      ? const SizedBox.shrink()
                      : Opacity(
                          opacity: contentOpacity,
                          child: widget.contentBuilder(context, _dismiss),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
