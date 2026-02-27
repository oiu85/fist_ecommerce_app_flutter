import 'package:flutter/foundation.dart';
class CoachTourController {
  CoachTourController();
  VoidCallback? _showTour;
  VoidCallback? _pendingNext;
  void register(VoidCallback showTour) {
    _showTour = showTour;
  }
  void showTour() {
    _showTour?.call();
  }
  void setPendingNext(VoidCallback? next) {
    _pendingNext = next;
  }
  void runPendingNext() {
    final cb = _pendingNext;
    _pendingNext = null;
    cb?.call();
  }
}
