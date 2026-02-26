import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'animation_constants.dart';

/// A widget that adds tap/press feedback animations to its child.
///
/// This provides consistent micro-interactions across the app:
/// - Scale down on press
/// - Optional haptic feedback
/// - Smooth spring-like return
///
/// Usage:
/// ```dart
/// TapAnimationWrapper(
///   onTap: () => doSomething(),
///   child: MyCard(),
/// )
/// ```
class TapAnimationWrapper extends StatefulWidget {
  const TapAnimationWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.scaleAmount = AnimationConstants.pressedScale,
    this.duration = AnimationConstants.ultraFast,
    this.enableHapticFeedback = true,
    this.hapticFeedbackType = HapticFeedbackType.light,
  });

  /// The widget to wrap with tap animation
  final Widget child;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Callback when long pressed
  final VoidCallback? onLongPress;

  /// Whether the tap animation is enabled
  final bool enabled;

  /// Scale factor when pressed (default: 0.97)
  final double scaleAmount;

  /// Duration of the scale animation
  final Duration duration;

  /// Whether to trigger haptic feedback on tap
  final bool enableHapticFeedback;

  /// Type of haptic feedback
  final HapticFeedbackType hapticFeedbackType;

  @override
  State<TapAnimationWrapper> createState() => _TapAnimationWrapperState();
}

class _TapAnimationWrapperState extends State<TapAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleAmount)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: AnimationConstants.snappyCurve,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    _controller.reverse();
  }

  void _onTapCancel() {
    if (!widget.enabled) return;
    _controller.reverse();
  }

  void _onTap() {
    if (!widget.enabled) return;

    if (widget.enableHapticFeedback) {
      _triggerHapticFeedback();
    }

    widget.onTap?.call();
  }

  void _triggerHapticFeedback() {
    switch (widget.hapticFeedbackType) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap != null ? _onTap : null,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}

/// Types of haptic feedback available
enum HapticFeedbackType { light, medium, heavy, selection }

/// A widget that adds hover effects for desktop/web platforms.
///
/// On mobile, this acts as a simple pass-through.
/// On desktop/web, it provides visual feedback on hover.
class HoverAnimationWrapper extends StatefulWidget {
  const HoverAnimationWrapper({
    super.key,
    required this.child,
    this.enabled = true,
    this.scaleAmount = 1.02,
    this.duration = AnimationConstants.fast,
    this.onHover,
    this.cursor = SystemMouseCursors.click,
    this.elevationOnHover,
    this.borderRadius,
  });

  /// The widget to wrap
  final Widget child;

  /// Whether the hover effect is enabled
  final bool enabled;

  /// Scale factor when hovered
  final double scaleAmount;

  /// Duration of the animation
  final Duration duration;

  /// Callback when hover state changes
  final ValueChanged<bool>? onHover;

  /// Mouse cursor to show on hover
  final MouseCursor cursor;

  /// When set, animates elevation on hover (0 → this value).
  /// Works even when scale is clipped; use for cards in grids.
  final double? elevationOnHover;

  /// Border radius for elevation shadow when [elevationOnHover] is set.
  final BorderRadius? borderRadius;

  @override
  State<HoverAnimationWrapper> createState() => _HoverAnimationWrapperState();
}

class _HoverAnimationWrapperState extends State<HoverAnimationWrapper> {
  bool _isHovered = false;

  void _onHover(bool isHovered) {
    if (!widget.enabled) return;
    setState(() => _isHovered = isHovered);
    widget.onHover?.call(isHovered);
  }

  @override
  Widget build(BuildContext context) {
    final showHover = _isHovered && widget.enabled;
    final scale = showHover ? widget.scaleAmount : 1.0;
    final elevation = widget.elevationOnHover != null
        ? (showHover ? widget.elevationOnHover! : 0.0)
        : null;

    Widget content = widget.child;
    if (elevation != null) {
      content = AnimatedPhysicalModel(
        shape: BoxShape.rectangle,
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        clipBehavior: Clip.none,
        elevation: elevation,
        color: Colors.transparent,
        shadowColor: Theme.of(context).shadowColor.withValues(alpha: 0.35),
        duration: widget.duration,
        curve: AnimationConstants.snappyCurve,
        child: content,
      );
    }

    content = AnimatedScale(
      scale: scale,
      duration: widget.duration,
      curve: AnimationConstants.snappyCurve,
      child: content,
    );

    return MouseRegion(
      cursor: widget.enabled ? widget.cursor : MouseCursor.defer,
      hitTestBehavior: HitTestBehavior.opaque,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: content,
    );
  }
}

/// Combines tap and hover animations for interactive elements.
///
/// Use this for cards, buttons, and interactive list items.
class InteractiveAnimationWrapper extends StatelessWidget {
  const InteractiveAnimationWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.tapScale = AnimationConstants.pressedScale,
    this.hoverScale = 1.02,
    this.enableHapticFeedback = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final double tapScale;
  final double hoverScale;
  final bool enableHapticFeedback;

  @override
  Widget build(BuildContext context) {
    return HoverAnimationWrapper(
      enabled: enabled,
      scaleAmount: hoverScale,
      child: TapAnimationWrapper(
        onTap: onTap,
        onLongPress: onLongPress,
        enabled: enabled,
        scaleAmount: tapScale,
        enableHapticFeedback: enableHapticFeedback,
        child: child,
      ),
    );
  }
}

/// Animated icon button with scale feedback.
///
/// A simple replacement for IconButton with built-in animation.
class AnimatedIconButton extends StatelessWidget {
  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.color,
    this.tooltip,
    this.enabled = true,
    this.enableHapticFeedback = true,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final String? tooltip;
  final bool enabled;
  final bool enableHapticFeedback;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      size: size,
      color: enabled
          ? color ?? Theme.of(context).iconTheme.color
          : Theme.of(context).disabledColor,
    );

    final button = TapAnimationWrapper(
      onTap: enabled ? onPressed : null,
      enabled: enabled,
      enableHapticFeedback: enableHapticFeedback,
      scaleAmount: 0.85,
      child: Padding(padding: const EdgeInsets.all(8.0), child: iconWidget),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

/// Widget extension for adding tap animation easily
extension TapAnimationExtension on Widget {
  /// Wraps the widget with tap scale animation
  Widget withTapAnimation({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool enabled = true,
    double scaleAmount = AnimationConstants.pressedScale,
    bool enableHapticFeedback = true,
  }) {
    return TapAnimationWrapper(
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
      scaleAmount: scaleAmount,
      enableHapticFeedback: enableHapticFeedback,
      child: this,
    );
  }

  /// Wraps the widget with hover animation (desktop/web)
  Widget withHoverAnimation({
    bool enabled = true,
    double scaleAmount = 1.02,
    ValueChanged<bool>? onHover,
  }) {
    return HoverAnimationWrapper(
      enabled: enabled,
      scaleAmount: scaleAmount,
      onHover: onHover,
      child: this,
    );
  }

  /// Wraps with both tap and hover animations
  Widget withInteractiveAnimation({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool enabled = true,
    double tapScale = AnimationConstants.pressedScale,
    double hoverScale = 1.02,
    bool enableHapticFeedback = true,
  }) {
    return InteractiveAnimationWrapper(
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
      tapScale: tapScale,
      hoverScale: hoverScale,
      enableHapticFeedback: enableHapticFeedback,
      child: this,
    );
  }
}
