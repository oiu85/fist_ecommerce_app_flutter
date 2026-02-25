/// Core Animation Module
///
/// This module provides a comprehensive animation toolkit for the app.
/// All animations use consistent durations, curves, and patterns.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:swb_academy_app/core/animation/animation.dart';
///
/// // Entrance animation for a widget
/// MyWidget().fadeInSlideUp()
///
/// // Staggered list items
/// MyCard().staggeredItem(index: 2)
///
/// // Interactive tap animation
/// MyCard().withTapAnimation(onTap: () => doSomething())
///
/// // Animated section on a page
/// MySection().asAnimatedSection(sectionIndex: 0)
/// ```
///
/// ## Architecture
///
/// - [AnimationConstants] - Centralized durations, curves, and values
/// - [WidgetAnimationExtensions] - Extension methods for entrance animations
/// - [TapAnimationWrapper] - Micro-interactions for tappable elements
/// - [AnimatedListBuilder] - Pre-built animated list widgets
/// - [AppleSpringCurve] - iOS-style spring physics curves
/// - [AppPageTransitions] - Page transition builders for routing
///
/// ## Performance Considerations
///
/// - All animations respect `MediaQuery.disableAnimations`
/// - Use `RepaintBoundary` around animated content when needed
/// - Stagger animations have max delay caps to prevent long waits
/// - Horizontal lists use optimized micro-stagger delays
///
library animation;

// Core constants and curves
export 'animation_constants.dart';
export 'spring_curves.dart';

// Widget extensions for animations
export 'animation_extensions.dart';

// Micro-interactions (tap, hover, press)
export 'micro_interactions.dart';

// List and section animation builders
export 'animated_list_builder.dart';

// Page transition utilities
export 'page_transitions.dart';

// Morphing overlay (for Dynamic Island-style effects)
export 'morphing_overlay.dart';
