import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'animation_constants.dart';

/// Widget extensions for common animation patterns using flutter_animate.
///
/// These extensions provide a clean, chainable API for adding animations
/// to any widget. They use the centralized [AnimationConstants] for consistency.
///
/// Usage:
/// ```dart
/// MyWidget().fadeInSlideUp()
/// MyWidget().scaleIn()
/// MyWidget().staggeredItem(index: 2)
/// ```
extension WidgetAnimationExtensions on Widget {
  // ═══════════════════════════════════════════════════════════════════════════
  // ENTRANCE ANIMATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Fades in with a subtle upward slide.
  /// Best for: cards, sections, general content
  Widget fadeInSlideUp({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    Offset? offset,
  }) {
    return animate(delay: delay ?? Duration.zero)
        .fadeIn(
          duration: duration ?? AnimationConstants.standard,
          curve: curve ?? AnimationConstants.entranceCurve,
        )
        .slideY(
          begin: (offset ?? AnimationConstants.slideUp).dy,
          end: 0,
          duration: duration ?? AnimationConstants.standard,
          curve: curve ?? AnimationConstants.entranceCurve,
        );
  }

  /// Fades in with a subtle downward slide.
  /// Best for: headers, top content
  Widget fadeInSlideDown({Duration? duration, Duration? delay, Curve? curve}) {
    return animate(delay: delay ?? Duration.zero)
        .fadeIn(
          duration: duration ?? AnimationConstants.standard,
          curve: curve ?? AnimationConstants.entranceCurve,
        )
        .slideY(
          begin: -AnimationConstants.slideUp.dy,
          end: 0,
          duration: duration ?? AnimationConstants.standard,
          curve: curve ?? AnimationConstants.entranceCurve,
        );
  }

  /// Fades in from the left.
  /// Best for: RTL-aware content, list items
  Widget fadeInSlideLeft({Duration? duration, Duration? delay, Curve? curve}) {
    return animate(delay: delay ?? Duration.zero)
        .fadeIn(
          duration: duration ?? AnimationConstants.standard,
          curve: curve ?? AnimationConstants.entranceCurve,
        )
        .slideX(
          begin: AnimationConstants.slideFromRight.dx,
          end: 0,
          duration: duration ?? AnimationConstants.standard,
          curve: curve ?? AnimationConstants.entranceCurve,
        );
  }

  /// Fades in from the right.
  /// Best for: RTL-aware content, list items
  Widget fadeInSlideRight({Duration? duration, Duration? delay, Curve? curve}) {
    return animate(delay: delay ?? Duration.zero)
        .fadeIn(
          duration: duration ?? AnimationConstants.standard,
          curve: curve ?? AnimationConstants.entranceCurve,
        )
        .slideX(
          begin: AnimationConstants.slideFromLeft.dx,
          end: 0,
          duration: duration ?? AnimationConstants.standard,
          curve: curve ?? AnimationConstants.entranceCurve,
        );
  }

  /// Simple fade in animation.
  /// Best for: subtle transitions, overlays
  Widget fadeInOnly({Duration? duration, Duration? delay, Curve? curve}) {
    return animate(delay: delay ?? Duration.zero).fadeIn(
      duration: duration ?? AnimationConstants.standard,
      curve: curve ?? AnimationConstants.entranceCurve,
    );
  }

  /// Scales in with optional fade.
  /// Best for: icons, buttons, emphasis elements
  Widget scaleIn({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    double? begin,
    bool withFade = true,
  }) {
    var animation = animate(delay: delay ?? Duration.zero).scale(
      begin: Offset(
        begin ?? AnimationConstants.standardScale,
        begin ?? AnimationConstants.standardScale,
      ),
      end: const Offset(1, 1),
      duration: duration ?? AnimationConstants.standard,
      curve: curve ?? AnimationConstants.bouncyCurve,
    );

    if (withFade) {
      animation = animation.fadeIn(
        duration: duration ?? AnimationConstants.standard,
        curve: curve ?? AnimationConstants.entranceCurve,
      );
    }

    return animation;
  }

  /// Scales in with a bouncy effect.
  /// Best for: success states, celebrations, CTAs
  Widget bounceIn({Duration? duration, Duration? delay}) {
    return animate(delay: delay ?? Duration.zero)
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          duration: duration ?? AnimationConstants.medium,
          curve: AnimationConstants.bouncyCurve,
        )
        .fadeIn(
          duration: duration ?? AnimationConstants.medium,
          curve: AnimationConstants.entranceCurve,
        );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STAGGERED LIST ANIMATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Staggered entrance animation for list items.
  /// Each item appears with a delay based on its index.
  ///
  /// [index] - Position in the list (0-based)
  /// [baseDelay] - Delay between each item
  /// [animationType] - Type of entrance animation
  Widget staggeredItem({
    required int index,
    Duration? baseDelay,
    StaggerAnimationType animationType = StaggerAnimationType.fadeSlideUp,
    Duration? duration,
  }) {
    final delay = AnimationConstants.staggerDelay(
      index,
      baseDelay: baseDelay ?? AnimationConstants.smallStagger,
    );

    return switch (animationType) {
      StaggerAnimationType.fadeSlideUp => fadeInSlideUp(
        delay: delay,
        duration: duration,
      ),
      StaggerAnimationType.fadeSlideLeft => fadeInSlideLeft(
        delay: delay,
        duration: duration,
      ),
      StaggerAnimationType.fadeSlideRight => fadeInSlideRight(
        delay: delay,
        duration: duration,
      ),
      StaggerAnimationType.scaleIn => scaleIn(delay: delay, duration: duration),
      StaggerAnimationType.fadeOnly => fadeInOnly(
        delay: delay,
        duration: duration,
      ),
    };
  }

  /// Staggered animation for horizontal lists (like course cards).
  /// Uses smaller delays for tighter visual pacing.
  Widget staggeredHorizontalItem({
    required int index,
    Duration? baseDelay,
    Duration? duration,
  }) {
    final delay = AnimationConstants.staggerDelay(
      index,
      baseDelay: baseDelay ?? AnimationConstants.microStagger,
      maxDelay: const Duration(milliseconds: 200),
    );

    return animate(delay: delay)
        .fadeIn(
          duration: duration ?? AnimationConstants.fast,
          curve: AnimationConstants.entranceCurve,
        )
        .slideX(
          begin: 0.05,
          end: 0,
          duration: duration ?? AnimationConstants.fast,
          curve: AnimationConstants.entranceCurve,
        );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION ANIMATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Section entrance with staggered delay.
  /// Use for major page sections (headers, cards, lists).
  ///
  /// [sectionIndex] - Order of the section on the page (0-based)
  Widget sectionEntrance({
    required int sectionIndex,
    Duration? baseDelay,
    Duration? duration,
  }) {
    final delay = AnimationConstants.staggerDelay(
      sectionIndex,
      baseDelay: baseDelay ?? AnimationConstants.standardStagger,
      maxDelay: const Duration(milliseconds: 500),
    );

    return fadeInSlideUp(
      delay: delay,
      duration: duration ?? AnimationConstants.medium,
      curve: AnimationConstants.smoothCurve,
    );
  }

  /// Hero section animation with more dramatic entrance.
  /// Best for: main cards, featured content
  Widget heroEntrance({Duration? delay, Duration? duration}) {
    return animate(delay: delay ?? Duration.zero)
        .fadeIn(
          duration: duration ?? AnimationConstants.slow,
          curve: AnimationConstants.smoothCurve,
        )
        .slideY(
          begin: AnimationConstants.slideUpLarge.dy,
          end: 0,
          duration: duration ?? AnimationConstants.slow,
          curve: AnimationConstants.smoothCurve,
        )
        .scale(
          begin: const Offset(0.98, 0.98),
          end: const Offset(1, 1),
          duration: duration ?? AnimationConstants.slow,
          curve: AnimationConstants.smoothCurve,
        );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHIMMER / LOADING ANIMATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Adds a shimmer effect for loading states.
  /// Best for: skeleton loaders, placeholder content
  Widget shimmerEffect({Color? color, Duration? duration}) {
    return animate(onPlay: (controller) => controller.repeat()).shimmer(
      duration: duration ?? const Duration(milliseconds: 1500),
      color: color ?? Colors.white24,
    );
  }

  /// Subtle pulse animation for attention.
  /// Best for: notifications, badges, live indicators
  Widget pulseEffect({
    Duration? duration,
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    return animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).scale(
      begin: Offset(minScale, minScale),
      end: Offset(maxScale, maxScale),
      duration: duration ?? const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }
}

/// Types of stagger animations available for list items.
enum StaggerAnimationType {
  /// Fade in with upward slide (default, most common)
  fadeSlideUp,

  /// Fade in with leftward slide (for RTL or left-aligned content)
  fadeSlideLeft,

  /// Fade in with rightward slide
  fadeSlideRight,

  /// Scale in with fade
  scaleIn,

  /// Simple fade only (subtle)
  fadeOnly,
}
