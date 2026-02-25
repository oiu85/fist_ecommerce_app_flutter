import 'package:flutter/material.dart';

import 'animation_constants.dart';

/// Custom page route transitions for the app.
///
/// These provide consistent, smooth page transitions that align with
/// the app's animation language.

/// Slide transition from bottom (for modals, bottom sheets promoted to pages)
class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  SlideUpPageRoute({required this.page, super.settings})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: AnimationConstants.smoothCurve,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          );
        },
        transitionDuration: AnimationConstants.medium,
        reverseTransitionDuration: AnimationConstants.standard,
      );

  final Widget page;
}

/// Fade transition (for subtle page changes)
class FadePageRoute<T> extends PageRouteBuilder<T> {
  FadePageRoute({required this.page, super.settings})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: AnimationConstants.entranceCurve,
            ),
            child: child,
          );
        },
        transitionDuration: AnimationConstants.standard,
        reverseTransitionDuration: AnimationConstants.fast,
      );

  final Widget page;
}

/// Slide and fade transition (default for most pages)
class SlideAndFadePageRoute<T> extends PageRouteBuilder<T> {
  SlideAndFadePageRoute({
    required this.page,
    this.direction = SlideDirection.fromRight,
    super.settings,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final curvedAnimation = CurvedAnimation(
             parent: animation,
             curve: AnimationConstants.smoothCurve,
           );

           final offset = switch (direction) {
             SlideDirection.fromRight => const Offset(0.15, 0),
             SlideDirection.fromLeft => const Offset(-0.15, 0),
             SlideDirection.fromBottom => const Offset(0, 0.15),
             SlideDirection.fromTop => const Offset(0, -0.15),
           };

           return FadeTransition(
             opacity: curvedAnimation,
             child: SlideTransition(
               position: Tween<Offset>(
                 begin: offset,
                 end: Offset.zero,
               ).animate(curvedAnimation),
               child: child,
             ),
           );
         },
         transitionDuration: AnimationConstants.medium,
         reverseTransitionDuration: AnimationConstants.standard,
       );

  final Widget page;
  final SlideDirection direction;
}

/// Scale transition (for detail pages, hero-like feel)
class ScalePageRoute<T> extends PageRouteBuilder<T> {
  ScalePageRoute({required this.page, super.settings})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: AnimationConstants.bouncyCurve,
          );

          return ScaleTransition(
            scale: Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).animate(curvedAnimation),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: AnimationConstants.entranceCurve,
              ),
              child: child,
            ),
          );
        },
        transitionDuration: AnimationConstants.medium,
        reverseTransitionDuration: AnimationConstants.standard,
      );

  final Widget page;
}

/// Direction for slide transitions
enum SlideDirection { fromRight, fromLeft, fromBottom, fromTop }

/// Transition builder for go_router CustomTransitionPage
class AppPageTransitions {
  /// Standard slide and fade (default)
  static Widget slideAndFade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child, {
    SlideDirection direction = SlideDirection.fromRight,
  }) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: AnimationConstants.smoothCurve,
    );

    final offset = switch (direction) {
      SlideDirection.fromRight => const Offset(0.1, 0),
      SlideDirection.fromLeft => const Offset(-0.1, 0),
      SlideDirection.fromBottom => const Offset(0, 0.1),
      SlideDirection.fromTop => const Offset(0, -0.1),
    };

    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: offset,
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      ),
    );
  }

  /// Slide up (for modals)
  static Widget slideUp(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: AnimationConstants.smoothCurve,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: child,
    );
  }

  /// Fade only (subtle)
  static Widget fade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: AnimationConstants.entranceCurve,
      ),
      child: child,
    );
  }

  /// Scale with fade (for detail pages)
  static Widget scale(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: AnimationConstants.bouncyCurve,
    );

    return ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: AnimationConstants.entranceCurve,
        ),
        child: child,
      ),
    );
  }
}
