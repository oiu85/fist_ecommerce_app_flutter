import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/di/app_dependencies.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../mock_data/product_details_mock_data.dart';
import '../../product_details/presentation/pages/product_details_page.dart';
import '../data/coach_tour_storage.dart';
import 'coach_tour_controller.dart';
import 'coach_tour_target_keys.dart';

class CoachTourOrchestrator extends StatefulWidget {
  const CoachTourOrchestrator({
    super.key,
    required this.child,
    required this.pageController,
    required this.onTabChange,
    required this.keys,
    required this.storage,
    this.onRegistered,
  });

  final Widget child;
  final PageController pageController;
  final void Function(int index) onTabChange;
  final CoachTourTargetKeys keys;
  final CoachTourStorage storage;
  final void Function(VoidCallback showTour)? onRegistered;
  @override
  State<CoachTourOrchestrator> createState() => _CoachTourOrchestratorState();
}

class _CoachTourOrchestratorState extends State<CoachTourOrchestrator> {
  TutorialCoachMark? _tutorial;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    widget.onRegistered?.call(_showTour);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartTour());
  }

  Future<void> _maybeStartTour() async {
    if (_initialized || !mounted) return;
    _initialized = true;
    final completed = await widget.storage.isCompleted();
    if (!completed && mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (mounted) _showTour();
    }
  }

  void showTour() {
    _showTour();
  }

  void _showTour() {
    final ctx = context;
    if (!ctx.mounted) return;

    final screenSize = MediaQuery.sizeOf(ctx);
    final topSafePadding = MediaQuery.paddingOf(ctx).top;
    final tourController = getIt<CoachTourController>();
    _tutorial = TutorialCoachMark(
      targets: widget.keys.createTargets(
        screenSize: screenSize,
        topSafePadding: topSafePadding,
        onSwitchTab: widget.onTabChange,
        scheduleNextWhenKeyReady: _scheduleNextWhenKeyReady,
        getText: (key, [namedArgs]) =>
            namedArgs != null ? key.tr(namedArgs: namedArgs) : key.tr(),
        onNavigateToProductDetails: (context) {
          context.push(
            AppRoutes.productDetails,
            extra: ProductDetailsRouteExtra(
              payload: mockProductDetailsPayload,
              forCoachTour: true,
            ),
          );
        },
        registerProductDetailsNext: tourController.setPendingNext,
        onProductDetailsNextPressed: () => _onProductDetailsNextPressed(ctx, tourController),
        appName: LocaleKeys.app_name.tr(),
      ),
      textSkip: LocaleKeys.coachTour_skip.tr(),
      paddingFocus: 8,
      opacityShadow: 0.7,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: _onFinish,
      onSkip: _onSkip,
    );

    _tutorial!.show(context: ctx);
  }

  void _scheduleNextWhenKeyReady(
    int tabIndex,
    GlobalKey key,
    VoidCallback next,
  ) {
    next();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        widget.onTabChange(tabIndex);
      });
    });
  }

  void _onProductDetailsNextPressed(BuildContext ctx, CoachTourController tourController) {
    if (!ctx.mounted) return;
    tourController.runPendingNext();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(milliseconds: 350), () {
        if (!mounted || !ctx.mounted) return;
        ctx.pop();
        widget.onTabChange(0);
      });
    });
  }

  bool _onSkip() {
    widget.storage.setCompleted(true);
    return true;
  }

  void _onFinish() {
    widget.storage.setCompleted(true);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
