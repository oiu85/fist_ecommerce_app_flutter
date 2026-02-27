import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fsit_flutter_task_ecommerce/core/localization/app_text.dart';

import '../animation/animation_constants.dart';
import '../localization/locale_keys.g.dart';

//* ═══════════════════════════════════════════════════════════════════════════════
//* Confetti shape enum & particle path builders (4 shapes)
//* ═══════════════════════════════════════════════════════════════════════════════

/// Which confetti particle shape to use.
///
/// [ConfettiShape.random] uses a random mix of all four shapes per particle.
enum ConfettiShape {
  /// Default rectangular confetti (package default style).
  rectangle,

  /// 5-pointed star (celebratory style as in package demo).
  star,

  /// Circular confetti.
  circle,

  /// Triangular confetti.
  triangle,

  /// Each particle randomly uses one of [rectangle], [star], [circle], [triangle].
  random,
}

//* ─── Path builders (pure functions, no side effects) ─────────────────────────

double _degToRad(double deg) => deg * (math.pi / 180.0);

/// Rectangle path (default confetti shape).
/// Fills the given [size] as a rectangle.
Path confettiRectanglePath(Size size) {
  return Path()
    ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
}

/// 5-pointed star path (celebratory style).
/// Uses external and internal radius for classic star silhouette.
Path confettiStarPath(Size size) {
  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = _degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = _degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(
      halfWidth + externalRadius * math.cos(step),
      halfWidth + externalRadius * math.sin(step),
    );
    path.lineTo(
      halfWidth + internalRadius * math.cos(step + halfDegreesPerStep),
      halfWidth + internalRadius * math.sin(step + halfDegreesPerStep),
    );
  }
  path.close();
  return path;
}

/// Circle path (filled circle within [size]).
Path confettiCirclePath(Size size) {
  final radius = math.min(size.width, size.height) / 2;
  final center = Offset(size.width / 2, size.height / 2);
  return Path()
    ..addOval(Rect.fromCircle(center: center, radius: radius));
}

/// Triangle path (equilateral-style within [size]).
Path confettiTrianglePath(Size size) {
  final w = size.width;
  final h = size.height;
  final path = Path()
    ..moveTo(w / 2, 0)
    ..lineTo(w, h)
    ..lineTo(0, h)
    ..close();
  return path;
}

/// Returns a [Path] for the given [shape] and [size].
/// For [ConfettiShape.random], [random] is used to pick one of the four shapes.
Path confettiPathForShape(ConfettiShape shape, Size size, [math.Random? random]) {
  switch (shape) {
    case ConfettiShape.rectangle:
      return confettiRectanglePath(size);
    case ConfettiShape.star:
      return confettiStarPath(size);
    case ConfettiShape.circle:
      return confettiCirclePath(size);
    case ConfettiShape.triangle:
      return confettiTrianglePath(size);
    case ConfettiShape.random:
      final r = random ?? math.Random();
      final index = r.nextInt(4);
      switch (index) {
        case 0:
          return confettiRectanglePath(size);
        case 1:
          return confettiStarPath(size);
        case 2:
          return confettiCirclePath(size);
        default:
          return confettiTrianglePath(size);
      }
  }
}

/// Builds the `createParticlePath` callback for [ConfettiWidget].
/// Use [ConfettiShape.random] for a mix of all four shapes.
Path Function(Size) createParticlePathForShape(ConfettiShape shape) {
  if (shape == ConfettiShape.random) {
    final random = math.Random();
    return (Size size) => confettiPathForShape(ConfettiShape.random, size, random);
  }
  return (Size size) => confettiPathForShape(shape, size);
}

//* ═══════════════════════════════════════════════════════════════════════════════
//* Default celebration colors & config
//* ═══════════════════════════════════════════════════════════════════════════════

/// Default vibrant colors for celebration confetti (aligned with common demos).
const List<Color> defaultConfettiColors = <Color>[
  Color(0xFF2196F3), // blue
  Color(0xFF9C27B0), // purple
  Color(0xFF4CAF50), // green
  Color(0xFFFF9800), // orange
  Color(0xFFE91E63), // pink
];

/// Default duration for a single confetti blast.
const Duration defaultConfettiDuration = Duration(seconds: 3);

//* ═══════════════════════════════════════════════════════════════════════════════
//* Reusable confetti overlay widget
//* ═══════════════════════════════════════════════════════════════════════════════

/// Reusable overlay that shows confetti for celebrations.
///
/// Place this once in your screen (e.g. in a [Stack] above content) and call
/// [ConfettiController.play] when you want to celebrate (e.g. quiz passed,
/// lesson completed).
///
/// Example:
/// ```dart
/// final _confettiController = ConfettiController(duration: defaultConfettiDuration);
///
/// Stack(
///   children: [
///     YourContent(),
///     Align(
///       alignment: Alignment.topCenter,
///       child: AppConfettiOverlay(
///         controller: _confettiController,
///         shape: ConfettiShape.random,
///       ),
///     ),
///   ],
/// )
/// // When user does a great job:
/// _confettiController.play();
/// ```
class AppConfettiOverlay extends StatefulWidget {
  const AppConfettiOverlay({
    super.key,
    required this.controller,
    this.shape = ConfettiShape.random,
    this.colors = defaultConfettiColors,
    this.duration = defaultConfettiDuration,
    this.blastDirectionality = BlastDirectionality.explosive,
    this.blastDirection = math.pi,
    this.numberOfParticles = 25,
    this.gravity = 0.1,
    this.minBlastForce = 5,
    this.maxBlastForce = 20,
    this.minimumSize = const Size(8, 8),
    this.maximumSize = const Size(25, 25),
    this.emissionFrequency = 0.05,
  });

  /// Controller that triggers the confetti blast (call [ConfettiController.play]).
  final ConfettiController controller;

  /// Which of the 4 shapes to use, or [ConfettiShape.random] for a mix.
  final ConfettiShape shape;

  /// Colors for the particles. Defaults to [defaultConfettiColors].
  final List<Color> colors;

  /// Duration of the blast. Should match the duration used to create [controller].
  final Duration duration;

  /// Whether to shoot in all directions or one direction.
  final BlastDirectionality blastDirectionality;

  /// Direction when [blastDirectionality] is directional (radians).
  final double blastDirection;

  /// Number of particles per emission.
  final int numberOfParticles;

  /// Gravity (0–1). Higher = faster fall.
  final double gravity;

  final double minBlastForce;
  final double maxBlastForce;
  final Size minimumSize;
  final Size maximumSize;
  final double emissionFrequency;

  @override
  State<AppConfettiOverlay> createState() => _AppConfettiOverlayState();
}

class _AppConfettiOverlayState extends State<AppConfettiOverlay> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? Ignore pointer so taps pass through to content below.
    return IgnorePointer(
      child: ConfettiWidget(
        confettiController: widget.controller,
        blastDirectionality: widget.blastDirectionality,
        blastDirection: widget.blastDirection,
        emissionFrequency: widget.emissionFrequency,
        numberOfParticles: widget.numberOfParticles,
        gravity: widget.gravity,
        minBlastForce: widget.minBlastForce,
        maxBlastForce: widget.maxBlastForce,
        minimumSize: widget.minimumSize,
        maximumSize: widget.maximumSize,
        colors: widget.colors,
        createParticlePath: createParticlePathForShape(widget.shape),
        shouldLoop: false,
      ),
    );
  }
}

//* ═══════════════════════════════════════════════════════════════════════════════
//* Trigger-based overlay (no controller in parent — keeps page StatelessWidget)
//* ═══════════════════════════════════════════════════════════════════════════════

/// Confetti overlay that owns the controller and plays when [triggerPlay]
/// transitions from false to true.
///
/// Use this when you want to keep the parent [StatelessWidget]: pass a value
/// derived from BLoC state (e.g. `triggerPlay: state.submitResult?.isCorrect == true`).
/// Confetti plays once per transition to true; controller lifecycle is fully
/// internal so the page does not need to be StatefulWidget.
///
/// Example (in a StatelessWidget builder with BlocBuilder):
/// ```dart
/// Stack(
///   children: [
///     YourContent(),
///     Align(
///       alignment: Alignment.topCenter,
///       child: AppConfettiTriggerOverlay(
///         triggerPlay: state.submitResult?.isCorrect == true,
///       ),
///     ),
///   ],
/// )
/// ```
class AppConfettiTriggerOverlay extends StatefulWidget {
  const AppConfettiTriggerOverlay({
    super.key,
    required this.triggerPlay,
    this.shape = ConfettiShape.random,
    this.colors = defaultConfettiColors,
    this.duration = defaultConfettiDuration,
    this.blastDirectionality = BlastDirectionality.explosive,
    this.blastDirection = math.pi,
    this.minBlastForce = 5,
    this.maxBlastForce = 20,
  });

  /// When this becomes true (from false), confetti plays once.
  final bool triggerPlay;

  final ConfettiShape shape;
  final List<Color> colors;
  final Duration duration;

  /// Directionality for the blast; use [BlastDirectionality.directional] for
  /// edge emitters (e.g. left/right shooting inward).
  final BlastDirectionality blastDirectionality;

  /// Direction in radians when [blastDirectionality] is directional.
  /// 0 = right, [math.pi] = left.
  final double blastDirection;

  /// Blast force range — higher values = particles travel farther.
  final double minBlastForce;
  final double maxBlastForce;

  @override
  State<AppConfettiTriggerOverlay> createState() =>
      _AppConfettiTriggerOverlayState();
}

class _AppConfettiTriggerOverlayState extends State<AppConfettiTriggerOverlay> {
  late final ConfettiController _controller;
  bool _lastTrigger = false;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: widget.duration);
    _lastTrigger = widget.triggerPlay;
    //? Play on first build if already true (e.g. after hot reload).
    if (widget.triggerPlay) {
      _schedulePlay();
    }
  }

  void _schedulePlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.play();
    });
  }

  @override
  void didUpdateWidget(AppConfettiTriggerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    //? Play only when trigger transitions from false to true.
    if (!_lastTrigger && widget.triggerPlay) {
      _lastTrigger = true;
      _schedulePlay();
    } else if (!widget.triggerPlay) {
      _lastTrigger = false;
    }
  }

  @override
  void dispose() {
    //! Controller is disposed by [AppConfettiOverlay] which we delegate to.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppConfettiOverlay(
      controller: _controller,
      shape: widget.shape,
      colors: widget.colors,
      duration: widget.duration,
      blastDirectionality: widget.blastDirectionality,
      blastDirection: widget.blastDirection,
      minBlastForce: widget.minBlastForce,
      maxBlastForce: widget.maxBlastForce,
    );
  }
}

//* ═══════════════════════════════════════════════════════════════════════════════
//* Two confetti from horizontal edges (left + right shooting inward)
//* ═══════════════════════════════════════════════════════════════════════════════

/// Two confetti emitters from the left and right edges of the screen,
/// both firing when [triggerPlay] becomes true (e.g. correct answer or quiz passed).
///
/// Use this for a stronger celebration: confetti from both horizontal edges.
class AppConfettiTriggerOverlayFromHorizontalEdges extends StatelessWidget {
  const AppConfettiTriggerOverlayFromHorizontalEdges({
    super.key,
    required this.triggerPlay,
    this.shape = ConfettiShape.random,
    this.colors = defaultConfettiColors,
    this.duration = defaultConfettiDuration,
  });

  final bool triggerPlay;
  final ConfettiShape shape;
  final List<Color> colors;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //* Left edge: emit toward the right (0 radians).
        Align(
          alignment: Alignment.centerLeft,
          child: AppConfettiTriggerOverlay(
            triggerPlay: triggerPlay,
            shape: shape,
            colors: colors,
            duration: duration,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: 0,
          ),
        ),
        //* Right edge: emit toward the left (pi radians).
        Align(
          alignment: Alignment.centerRight,
          child: AppConfettiTriggerOverlay(
            triggerPlay: triggerPlay,
            shape: shape,
            colors: colors,
            duration: duration,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: math.pi,
          ),
        ),
      ],
    );
  }
}

//* ═══════════════════════════════════════════════════════════════════════════════
//* Cup icon overlay — scale animation (small → big) when triggered
//* ═══════════════════════════════════════════════════════════════════════════════

/// Cup icon that scales from small to full size when [triggerPlay] becomes true.
/// Uses elastic curve for a satisfying celebratory pop. Respects reduced motion.
class _CelebrationCupOverlay extends StatefulWidget {
  const _CelebrationCupOverlay({required this.triggerPlay});

  final bool triggerPlay;

  @override
  State<_CelebrationCupOverlay> createState() => _CelebrationCupOverlayState();
}

class _CelebrationCupOverlayState extends State<_CelebrationCupOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  Animation<double>? _opacityAnimation;
  bool _lastTrigger = false;
  bool _initialized = false;

  static const String _cupAssetPath = 'assets/images/icons/cup.svg';
  static const double _cupSize = 140.0;
  static const double _scaleStart = 0.15;
  static const double _scaleEnd = 1.0;

  @override
  void initState() {
    super.initState();
    _lastTrigger = widget.triggerPlay;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //! initState cannot access inherited widgets (MediaQuery, Theme).
    //? Create controller in didChangeDependencies when context is ready.
    if (!_initialized) {
      _initialized = true;
      final reducedMotion = AnimationConstants.shouldReduceMotion(context);
      const totalDuration = Duration(milliseconds: 2500);
      _controller = AnimationController(
        duration: reducedMotion
            ? AnimationConstants.reducedMotionDuration(totalDuration)
            : totalDuration,
        vsync: this,
      );
      _scaleAnimation = Tween<double>(begin: _scaleStart, end: _scaleEnd).animate(
        CurvedAnimation(
          parent: _controller!,
          curve: Interval(0, 0.2, curve: reducedMotion
              ? AnimationConstants.defaultCurve
              : Curves.elasticOut),
        ),
      );
      //* Opacity: fade in (0–20%), hold (20–75%), fade out (75–100%)
      _opacityAnimation = TweenSequence<double>(<TweenSequenceItem<double>>[
        TweenSequenceItem(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ConstantTween<double>(1),
          weight: 2.75,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1, end: 0),
          weight: 1,
        ),
      ]).animate(CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeInOut,
      ));
      _controller!.addStatusListener(_onAnimationStatus);
      if (widget.triggerPlay) _controller!.forward();
    }
  }

  @override
  void didUpdateWidget(_CelebrationCupOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ctrl = _controller;
    if (ctrl == null) return;
    if (!_lastTrigger && widget.triggerPlay) {
      _lastTrigger = true;
      ctrl.forward(from: 0);
    } else if (!widget.triggerPlay) {
      _lastTrigger = false;
      ctrl.reset();
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      _controller?.reset();
    }
  }

  @override
  void dispose() {
    _controller?.removeStatusListener(_onAnimationStatus);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = _controller;
    final scaleAnim = _scaleAnimation;
    final opacityAnim = _opacityAnimation;
    if (ctrl == null || scaleAnim == null || opacityAnim == null) {
      return const SizedBox.shrink();
    }
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: ctrl,
        builder: (context, child) {
          if (ctrl.status == AnimationStatus.dismissed) {
            return const SizedBox.shrink();
          }
          return Opacity(
            opacity: opacityAnim.value,
            child: Transform.scale(
              scale: scaleAnim.value,
              child: child,
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              _cupAssetPath,
              width: _cupSize,
              height: _cupSize,
              colorFilter: const ColorFilter.mode(
                Color(0xFFFFC107),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AppText(
                LocaleKeys.coachTour_celebrationQuote,
                translation: true,
                textAlign: TextAlign.center,
                maxLines: 2,
                isAutoScale: true,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//* ═══════════════════════════════════════════════════════════════════════════════
//* Two confetti from bottom corners (bottom-left + bottom-right shooting upward)
//* ═══════════════════════════════════════════════════════════════════════════════

/// Two confetti emitters from the bottom-left and bottom-right corners,
/// both firing toward the center of the screen when [triggerPlay] becomes true.
///
/// Computes the exact angle from each corner to screen center so shapes
/// converge at center. Uses high blast force so shapes reach the middle.
class AppConfettiTriggerOverlayFromBottomCorners extends StatelessWidget {
  const AppConfettiTriggerOverlayFromBottomCorners({
    super.key,
    required this.triggerPlay,
    this.shape = ConfettiShape.random,
    this.colors = defaultConfettiColors,
    this.duration = defaultConfettiDuration,
  });

  final bool triggerPlay;
  final ConfettiShape shape;
  final List<Color> colors;
  final Duration duration;

  /// High blast force so confetti reaches center from bottom corners.
  static const double _minBlastForce = 70;
  static const double _maxBlastForce = 150;

  /// Angle from bottom-left to center: up-right. atan2(-dy, dx) with dy, dx to center.
  static double _blastAngleBottomLeft(double width, double height) {
    final dx = width / 2;
    final dy = height / 2;
    return math.atan2(-dy, dx);
  }

  /// Angle from bottom-right to center: up-left. atan2(-dy, -dx).
  static double _blastAngleBottomRight(double width, double height) {
    final dx = width / 2;
    final dy = height / 2;
    return math.atan2(-dy, -dx);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final angleLeft = _blastAngleBottomLeft(size.width, size.height);
    final angleRight = _blastAngleBottomRight(size.width, size.height);

    return Stack(
      children: [
        //* Cup icon in center with scale animation (small → big)
        Center(
          child: _CelebrationCupOverlay(triggerPlay: triggerPlay),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: AppConfettiTriggerOverlay(
            triggerPlay: triggerPlay,
            shape: shape,
            colors: colors,
            duration: duration,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: angleLeft,
            minBlastForce: _minBlastForce,
            maxBlastForce: _maxBlastForce,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: AppConfettiTriggerOverlay(
            triggerPlay: triggerPlay,
            shape: shape,
            colors: colors,
            duration: duration,
            blastDirectionality: BlastDirectionality.directional,
            blastDirection: angleRight,
            minBlastForce: _minBlastForce,
            maxBlastForce: _maxBlastForce,
          ),
        ),
      ],
    );
  }
}

//* ═══════════════════════════════════════════════════════════════════════════════
//* Optional: helper to create controller with app defaults
//* ═══════════════════════════════════════════════════════════════════════════════

/// Creates a [ConfettiController] with app-default duration.
/// Remember to call [ConfettiController.dispose] when the widget is disposed.
ConfettiController createConfettiController({
  Duration duration = defaultConfettiDuration,
}) {
  return ConfettiController(duration: duration);
}
