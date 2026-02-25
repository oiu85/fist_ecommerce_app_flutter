//* ═══════════════════════════════════════════════════════════════════════════════
//* Semantic haptic feedback types for consistent UX across apps.
//* Maps to Flutter's HapticFeedback with clear intent-based naming.
//* ═══════════════════════════════════════════════════════════════════════════════

/// Semantic haptic feedback types.
///
/// Use these to communicate intent rather than raw API calls.
/// Works on iOS (Taptic Engine) and Android; no-op on web/desktop.
///
/// **Usage guide:**
/// - [selection] — Picker, list item, radio, chip selection
/// - [lightTap] — Tab bar, icon buttons, subtle confirmations
/// - [mediumTap] — Primary buttons, important actions
/// - [heavyTap] — Major milestones (quiz pass, lesson complete)
/// - [success] — Auth success, enrollment, download complete
/// - [warning] — Incorrect answer, validation error
/// - [error] — Severe failure, blocked action
enum HapticType {
  /// Very light feedback for selections (picker, list item, chip).
  selection,

  /// Light tap for tab switches, icon buttons, secondary actions.
  lightTap,

  /// Medium tap for primary buttons, form submit, key actions.
  mediumTap,

  /// Heavy tap for major milestones (quiz pass, lesson done, completion).
  heavyTap,

  /// Success feedback — double tap or strong positive cue.
  success,

  /// Warning feedback — incorrect answer, validation failed.
  warning,

  /// Error feedback — severe failure, blocked operation.
  error,
}
