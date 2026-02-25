//* ═══════════════════════════════════════════════════════════════════════════════
//* App-level haptic facade — use these static methods throughout the app.
//* Reusable across projects; no app-specific dependencies.
//* ═══════════════════════════════════════════════════════════════════════════════

import 'haptic_service.dart';
import 'haptic_type.dart';

/// Convenience API for haptic feedback.
///
/// Use the static methods for common scenarios. All methods are safe to call
/// from any isolate; HapticFeedback runs on the platform channel.
///
/// **Examples:**
/// ```dart
/// // Quiz correct answer
/// AppHaptic.success();
///
/// // Quiz wrong answer
/// AppHaptic.warning();
///
/// // Submit button
/// AppHaptic.mediumTap();
/// ```
///
/// For tests, override before running:
/// ```dart
/// AppHaptic.setService(NoOpHapticService());
/// ```
class AppHaptic {
  AppHaptic._();

  /// Default implementation; uses Flutter's HapticFeedback.
  static IHapticService _service = const FlutterHapticService();

  /// When false, all feedback calls are no-op (user disabled in settings).
  static bool _enabled = true;

  /// Override the haptic service (e.g. [NoOpHapticService] in tests).
  static void setService(IHapticService service) {
    _service = service;
  }

  /// Set whether haptics are enabled (from settings). When false, no feedback.
  static void setEnabled(bool value) {
    _enabled = value;
  }

  /// Whether haptics are currently enabled.
  static bool get isEnabled => _enabled;

  /// Reset to the default Flutter implementation.
  static void resetToDefault() {
    _service = const FlutterHapticService();
  }

  /// Single gate: triggers feedback only when haptics are enabled.
  /// All public methods delegate here so the settings toggle is respected.
  static void feedback(HapticType type) {
    if (!_enabled) return;
    _service.feedback(type);
  }

  /// Selection feedback — picker, list item, chip, radio.
  static void selection() => feedback(HapticType.selection);

  /// Light tap — icon buttons, secondary actions.
  static void lightTap() => feedback(HapticType.lightTap);

  /// Medium tap — primary buttons, form submit, key actions.
  static void mediumTap() => feedback(HapticType.mediumTap);

  /// Heavy tap — major milestones (quiz pass, lesson complete).
  static void heavyTap() => feedback(HapticType.heavyTap);

  /// Success feedback — auth success, enrollment, download complete.
  static void success() => feedback(HapticType.success);

  /// Warning feedback — incorrect answer, validation failed.
  static void warning() => feedback(HapticType.warning);

  /// Error feedback — severe failure, blocked operation.
  static void error() => feedback(HapticType.error);
}
