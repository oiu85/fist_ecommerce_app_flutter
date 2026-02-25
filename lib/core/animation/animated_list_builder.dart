import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'animation_constants.dart';
import 'animation_extensions.dart';

/// A builder widget that creates animated list items with staggered entrance.
///
/// This is a drop-in replacement for ListView.builder that automatically
/// animates each item as it appears.
///
/// Usage:
/// ```dart
/// AnimatedListBuilder(
///   itemCount: items.length,
///   itemBuilder: (context, index) => MyCard(item: items[index]),
/// )
/// ```
class AnimatedListBuilder extends StatelessWidget {
  const AnimatedListBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.controller,
    this.separatorBuilder,
    this.cacheExtent,
    this.animationType = StaggerAnimationType.fadeSlideUp,
    this.staggerDelay = AnimationConstants.smallStagger,
    this.animationDuration = AnimationConstants.standard,
    this.enableAnimation = true,
  });

  /// Total number of items
  final int itemCount;

  /// Builder for each item
  final IndexedWidgetBuilder itemBuilder;

  /// Scroll direction (default: vertical)
  final Axis scrollDirection;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Padding around the list
  final EdgeInsetsGeometry? padding;

  /// Whether to shrink wrap
  final bool shrinkWrap;

  /// Scroll controller
  final ScrollController? controller;

  /// Optional separator between items
  final IndexedWidgetBuilder? separatorBuilder;

  /// Cache extent for performance
  final double? cacheExtent;

  /// Type of entrance animation
  final StaggerAnimationType animationType;

  /// Delay between each item's animation
  final Duration staggerDelay;

  /// Duration of each item's animation
  final Duration animationDuration;

  /// Whether to enable animations (useful for reduced motion)
  final bool enableAnimation;

  @override
  Widget build(BuildContext context) {
    // Check for reduced motion preference
    final shouldAnimate =
        enableAnimation && !AnimationConstants.shouldReduceMotion(context);

    if (separatorBuilder != null) {
      return ListView.separated(
        scrollDirection: scrollDirection,
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
        controller: controller,
        cacheExtent: cacheExtent,
        itemCount: itemCount,
        separatorBuilder: separatorBuilder!,
        itemBuilder: (context, index) {
          final child = itemBuilder(context, index);
          if (!shouldAnimate) return child;
          return child.staggeredItem(
            index: index,
            baseDelay: staggerDelay,
            animationType: animationType,
            duration: animationDuration,
          );
        },
      );
    }

    return ListView.builder(
      scrollDirection: scrollDirection,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      controller: controller,
      cacheExtent: cacheExtent,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final child = itemBuilder(context, index);
        if (!shouldAnimate) return child;
        return child.staggeredItem(
          index: index,
          baseDelay: staggerDelay,
          animationType: animationType,
          duration: animationDuration,
        );
      },
    );
  }
}

/// A horizontal animated list optimized for course cards and similar content.
///
/// Uses tighter stagger delays and horizontal slide animation.
class AnimatedHorizontalList extends StatelessWidget {
  const AnimatedHorizontalList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.height,
    this.physics,
    this.separatorWidth = 12.0,
    this.cacheExtent,
    this.staggerDelay = AnimationConstants.microStagger,
    this.animationDuration = AnimationConstants.fast,
    this.enableAnimation = true,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double height;
  final ScrollPhysics? physics;
  final double separatorWidth;
  final double? cacheExtent;
  final Duration staggerDelay;
  final Duration animationDuration;
  final bool enableAnimation;

  @override
  Widget build(BuildContext context) {
    final shouldAnimate =
        enableAnimation && !AnimationConstants.shouldReduceMotion(context);

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics:
            physics ??
            const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast,
            ),
        cacheExtent: cacheExtent ?? 200,
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(width: separatorWidth),
        itemBuilder: (context, index) {
          final child = itemBuilder(context, index);
          if (!shouldAnimate) return child;
          return child.staggeredHorizontalItem(
            index: index,
            baseDelay: staggerDelay,
            duration: animationDuration,
          );
        },
      ),
    );
  }
}

/// A column that animates its children with staggered entrance.
///
/// Useful for animating page sections or form fields.
class AnimatedColumn extends StatelessWidget {
  const AnimatedColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.animationType = StaggerAnimationType.fadeSlideUp,
    this.staggerDelay = AnimationConstants.standardStagger,
    this.animationDuration = AnimationConstants.medium,
    this.enableAnimation = true,
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final StaggerAnimationType animationType;
  final Duration staggerDelay;
  final Duration animationDuration;
  final bool enableAnimation;

  @override
  Widget build(BuildContext context) {
    final shouldAnimate =
        enableAnimation && !AnimationConstants.shouldReduceMotion(context);

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (int i = 0; i < children.length; i++)
          if (shouldAnimate)
            children[i].staggeredItem(
              index: i,
              baseDelay: staggerDelay,
              animationType: animationType,
              duration: animationDuration,
            )
          else
            children[i],
      ],
    );
  }
}

/// A widget that wraps page sections with staggered animations.
///
/// Use this to wrap major page sections for coordinated entrance animations.
///
/// Usage:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverToBoxAdapter(
///       child: AnimatedSection(
///         sectionIndex: 0,
///         child: HeaderSection(),
///       ),
///     ),
///     SliverToBoxAdapter(
///       child: AnimatedSection(
///         sectionIndex: 1,
///         child: CardCarousel(),
///       ),
///     ),
///   ],
/// )
/// ```
class AnimatedSection extends StatelessWidget {
  const AnimatedSection({
    super.key,
    required this.sectionIndex,
    required this.child,
    this.baseDelay = AnimationConstants.standardStagger,
    this.duration = AnimationConstants.medium,
    this.enableAnimation = true,
  });

  /// Index of this section on the page (0-based)
  final int sectionIndex;

  /// The section content
  final Widget child;

  /// Base delay between sections
  final Duration baseDelay;

  /// Animation duration
  final Duration duration;

  /// Whether animation is enabled
  final bool enableAnimation;

  @override
  Widget build(BuildContext context) {
    final shouldAnimate =
        enableAnimation && !AnimationConstants.shouldReduceMotion(context);

    if (!shouldAnimate) return child;

    return child.sectionEntrance(
      sectionIndex: sectionIndex,
      baseDelay: baseDelay,
      duration: duration,
    );
  }
}

/// Extension to easily wrap widgets for section animation
extension SectionAnimationExtension on Widget {
  /// Wraps the widget as an animated page section
  Widget asAnimatedSection({
    required int sectionIndex,
    Duration? baseDelay,
    Duration? duration,
    bool enableAnimation = true,
  }) {
    return AnimatedSection(
      sectionIndex: sectionIndex,
      baseDelay: baseDelay ?? AnimationConstants.standardStagger,
      duration: duration ?? AnimationConstants.medium,
      enableAnimation: enableAnimation,
      child: this,
    );
  }
}
