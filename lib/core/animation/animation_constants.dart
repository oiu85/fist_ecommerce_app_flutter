import 'package:flutter/material.dart';

/// Centralized animation constants for the entire application.
///
/// This class provides consistent animation durations, curves, and delays
/// that should be used across all features. By centralizing these values,
/// we ensure:
/// - Consistent feel across the app
/// - Easy global adjustments
/// - Performance optimization (tested values)
/// - Accessibility support (reduced motion)
abstract final class AnimationConstants {
  // ═══════════════════════════════════════════════════════════════════════════
  // DURATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Ultra-fast animations for micro-interactions (button press feedback)
  /// Use for: tap feedback, small state changes
  static const Duration ultraFast = Duration(milliseconds: 100);

  /// Fast animations for small UI changes
  /// Use for: toggles, checkboxes, small icon animations
  static const Duration fast = Duration(milliseconds: 150);

  /// Standard duration for most animations
  /// Use for: card entrance, fade transitions, most UI elements
  static const Duration standard = Duration(milliseconds: 250);

  /// Medium duration for more noticeable animations
  /// Use for: page section entrance, list item stagger base
  static const Duration medium = Duration(milliseconds: 350);

  /// Slow duration for emphasized animations
  /// Use for: hero sections, important content reveals
  static const Duration slow = Duration(milliseconds: 500);

  /// Extra slow for dramatic effect
  /// Use for: onboarding, first-time experiences, celebration animations
  static const Duration extraSlow = Duration(milliseconds: 700);

  // ═══════════════════════════════════════════════════════════════════════════
  // STAGGER DELAYS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Micro stagger for tightly packed items
  /// Use for: horizontal scroll items, compact lists
  static const Duration microStagger = Duration(milliseconds: 30);

  /// Small stagger for list items
  /// Use for: vertical lists, card grids
  static const Duration smallStagger = Duration(milliseconds: 50);

  /// Standard stagger for section reveals
  /// Use for: page sections, form fields
  static const Duration standardStagger = Duration(milliseconds: 80);

  /// Large stagger for dramatic effect
  /// Use for: hero content, onboarding steps
  static const Duration largeStagger = Duration(milliseconds: 120);

  // ═══════════════════════════════════════════════════════════════════════════
  // CURVES - Standard Flutter Curves
  // ═══════════════════════════════════════════════════════════════════════════

  /// Default ease for most animations - natural feeling
  static const Curve defaultCurve = Curves.easeOutCubic;

  /// For entrance animations - starts slow, ends fast feel
  static const Curve entranceCurve = Curves.easeOut;

  /// For exit animations - starts fast, ends slow
  static const Curve exitCurve = Curves.easeIn;

  /// For emphasis - slight overshoot for playful feel
  static const Curve bouncyCurve = Curves.easeOutBack;

  /// For smooth transitions without overshoot
  static const Curve smoothCurve = Curves.easeInOutCubic;

  /// For snappy, responsive interactions
  static const Curve snappyCurve = Curves.easeOutQuart;

  /// For deceleration (content sliding in)
  static const Curve decelerateCurve = Curves.decelerate;

  // ═══════════════════════════════════════════════════════════════════════════
  // OFFSET VALUES (for slide animations)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Subtle slide offset
  static const Offset subtleSlideUp = Offset(0, 0.05);

  /// Standard slide up offset
  static const Offset slideUp = Offset(0, 0.1);

  /// More pronounced slide up
  static const Offset slideUpLarge = Offset(0, 0.2);

  /// Slide from left
  static const Offset slideFromLeft = Offset(-0.1, 0);

  /// Slide from right
  static const Offset slideFromRight = Offset(0.1, 0);

  /// Slide from bottom (for bottom sheets, modals)
  static const Offset slideFromBottom = Offset(0, 0.3);

  // ═══════════════════════════════════════════════════════════════════════════
  // SCALE VALUES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Subtle scale for micro-interactions
  static const double subtleScale = 0.98;

  /// Standard scale for entrance animations
  static const double standardScale = 0.95;

  /// Larger scale for emphasis
  static const double emphasisScale = 0.9;

  /// Scale for pressed state feedback
  static const double pressedScale = 0.97;

  // ═══════════════════════════════════════════════════════════════════════════
  // OPACITY VALUES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Starting opacity for fade-in animations
  static const double fadeStart = 0.0;

  /// Ending opacity for fade-in animations
  static const double fadeEnd = 1.0;

  /// Dimmed state opacity (for disabled/inactive items)
  static const double dimmedOpacity = 0.5;

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Calculates stagger delay for a given index in a list.
  ///
  /// [index] - The item's position in the list
  /// [baseDelay] - The delay between each item (default: smallStagger)
  /// [maxDelay] - Maximum total delay to prevent very long waits
  static Duration staggerDelay(
    int index, {
    Duration baseDelay = smallStagger,
    Duration maxDelay = const Duration(milliseconds: 400),
  }) {
    final calculated = Duration(milliseconds: index * baseDelay.inMilliseconds);
    return calculated > maxDelay ? maxDelay : calculated;
  }

  /// Returns reduced motion durations for accessibility.
  /// When the user has enabled "Reduce Motion" in system settings,
  /// use these shorter durations.
  static Duration reducedMotionDuration(Duration original) {
    // Reduce to 1/3 of original, minimum 50ms
    final reduced = original.inMilliseconds ~/ 3;
    return Duration(milliseconds: reduced < 50 ? 50 : reduced);
  }

  /// Checks if reduced motion is preferred.
  /// Use this to conditionally apply or skip animations.
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }
}
