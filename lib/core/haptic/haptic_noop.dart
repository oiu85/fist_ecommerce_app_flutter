//* ═══════════════════════════════════════════════════════════════════════════════
//* No-op haptic service for tests and environments where haptics are disabled.
//* ═══════════════════════════════════════════════════════════════════════════════

import 'haptic_service.dart';
import 'haptic_type.dart';

/// Haptic service that does nothing.
///
/// Use in unit/widget tests to avoid platform calls and ensure
/// deterministic behavior. Also useful when the app is configured
/// to disable haptics (e.g. user preference, reduced motion).
class NoOpHapticService implements IHapticService {
  const NoOpHapticService();

  @override
  void feedback(HapticType type) {
    //* Intentionally does nothing.
  }
}
