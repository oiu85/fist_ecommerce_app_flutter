import 'package:flutter/material.dart';

import 'coach_tour_target_keys.dart';

class CoachTourScope extends InheritedWidget {
  const CoachTourScope({
    super.key,
    required this.keys,
    required super.child,
  });

  final CoachTourTargetKeys keys;

  static CoachTourTargetKeys? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CoachTourScope>()
        ?.keys;
  }

  @override
  bool updateShouldNotify(CoachTourScope oldWidget) =>
      keys != oldWidget.keys;
}
