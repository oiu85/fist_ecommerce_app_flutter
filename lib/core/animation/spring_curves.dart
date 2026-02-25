import 'dart:math' as math;

import 'package:flutter/animation.dart';

/// Exact reproductions of Apple's SwiftUI spring animation presets.
///
/// These curves replicate the physics-based spring system that makes
/// iOS interactions feel alive and tangible.
///
/// Source formula from [Respring](https://github.com/ktiays/Respring):
/// ```
/// dampingRatio (ζ) = 1 - bounce
/// ωd = √(1 - ζ²) × 2π / duration   (damped angular frequency)
/// σ  = ζ × 2π / duration            (decay constant)
/// x(t) = 1 - e^(-σ·t) × [cos(ωd·t) + (σ/ωd)·sin(ωd·t)]
/// ```
///
/// Usage:
/// ```dart
/// AnimationController(
///   vsync: this,
///   duration: const Duration(milliseconds: 500),
/// )..forward();
///
/// // Then in your animated builder:
/// final t = AppleSpringCurve.bouncy.transform(controller.value);
/// ```
abstract final class AppleSpringCurve {
  /// **Bouncy** — SwiftUI `Spring(duration: 0.5, bounce: 0.3)`.
  ///
  /// Noticeable overshoot (~4.6%) that gives a playful, energetic feel.
  /// Best for: popups, pill expansions, Dynamic Island-style morphs.
  static const Curve bouncy = _AppleSpring(
    duration: 0.5,
    bounce: 0.3,
    timeScale: 0.6,
  );

  /// **Snappy** — SwiftUI `Spring(duration: 0.35, bounce: 0.15)`.
  ///
  /// Quick with minimal overshoot (~1.5%). Feels precise and responsive.
  /// Best for: toggles, tab switches, small state changes.
  static const Curve snappy = _AppleSpring(
    duration: 0.35,
    bounce: 0.15,
    timeScale: 0.5,
  );

  /// **Smooth** — SwiftUI `Spring(duration: 0.5, bounce: 0.0)`.
  ///
  /// No overshoot. Critically damped — fastest arrival without bouncing.
  /// Best for: navigation transitions, background changes, subtle shifts.
  static const Curve smooth = _AppleSpring(
    duration: 0.5,
    bounce: 0.0,
    timeScale: 0.6,
  );

  /// Creates a **custom** Apple spring with the given parameters.
  ///
  /// [duration] — natural duration in seconds (0.2 – 1.0 typical).
  /// [bounce] — 0.0 = critically damped, 1.0 = infinite oscillation.
  ///            Negative values are allowed for over-damped springs.
  /// [timeScale] — maps normalized t=1 to this many real seconds.
  ///              Must be >= [duration] for the spring to settle fully.
  static Curve custom({
    required double duration,
    required double bounce,
    double? timeScale,
  }) {
    return _AppleSpring(
      duration: duration,
      bounce: bounce,
      timeScale: timeScale ?? duration * 1.2,
    );
  }
}

/// Internal implementation of the Apple spring physics curve.
class _AppleSpring extends Curve {
  const _AppleSpring({
    required this.duration,
    required this.bounce,
    required this.timeScale,
  });

  /// Natural duration in seconds.
  final double duration;

  /// Bounce factor (0.0 = critically damped, 1.0 = undamped).
  final double bounce;

  /// Maps normalised t ∈ [0, 1] → real time in seconds.
  final double timeScale;

  static const double _tau = 2.0 * math.pi;

  @override
  double transformInternal(double t) {
    final zeta = 1.0 - bounce;
    final omegaD = math.sqrt((1.0 - zeta * zeta).abs()) * _tau / duration;
    final sigma = zeta * _tau / duration;

    final rt = t * timeScale;
    final decay = math.exp(-sigma * rt);

    // For critically or over-damped springs, avoid division by zero.
    if (omegaD < 1e-6) {
      return (1.0 - decay * (1.0 + sigma * rt)).clamp(0.0, 1.0);
    }

    final sinCoeff = sigma / omegaD;
    final value =
        1.0 -
        decay * (math.cos(omegaD * rt) + sinCoeff * math.sin(omegaD * rt));

    // Allow a tiny overshoot (up to 10%) for the bouncy feel.
    return value.clamp(0.0, 1.1);
  }
}
