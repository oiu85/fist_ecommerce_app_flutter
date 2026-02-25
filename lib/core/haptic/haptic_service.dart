//* ═══════════════════════════════════════════════════════════════════════════════
//* Haptic service contract and Flutter implementation.
//* Abstract for testability; use [FlutterHapticService] in production.
//* ═══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/services.dart';

import 'haptic_type.dart';

/// Abstraction over haptic feedback for testability and platform flexibility.
///
/// Inject [NoOpHapticService] in tests to avoid actual vibration.
/// Use [FlutterHapticService] in production.
abstract class IHapticService {
  /// Triggers haptic feedback for the given [type].
  void feedback(HapticType type);
}

/// Production implementation using Flutter's [HapticFeedback].
///
/// Uses platform-native haptics (Taptic Engine on iOS, system haptics on Android).
/// No-op on web/desktop where haptics are not supported.
class FlutterHapticService implements IHapticService {
  const FlutterHapticService();

  @override
  void feedback(HapticType type) {
    switch (type) {
      case HapticType.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticType.lightTap:
        HapticFeedback.lightImpact();
        break;
      case HapticType.mediumTap:
        HapticFeedback.mediumImpact();
        break;
      case HapticType.heavyTap:
        HapticFeedback.heavyImpact();
        break;
      case HapticType.success:
        //* Double light tap for "success" — distinct positive cue
        HapticFeedback.mediumImpact();
        HapticFeedback.lightImpact();
        break;
      case HapticType.warning:
        //* Slightly stronger than light — "something went wrong" feel
        HapticFeedback.mediumImpact();
        break;
      case HapticType.error:
        HapticFeedback.heavyImpact();
        break;
    }
  }
}
