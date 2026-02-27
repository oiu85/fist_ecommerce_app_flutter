import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/localization/locale_keys.g.dart';

class CoachTourTargetKeys {
  CoachTourTargetKeys() {
    keyHomeNav = GlobalKey();
    keyCartNav = GlobalKey();
    keyAddProductNav = GlobalKey();
    keySettingsNav = GlobalKey();
    keySearch = GlobalKey();
    keyCart = GlobalKey();
    keyCategorySection = GlobalKey();
    keyProductArea = GlobalKey();
    keyCartListOrEmpty = GlobalKey();
    keyCartItemsList = GlobalKey();
    keyCartTotalSection = GlobalKey();
    keyAddProductForm = GlobalKey();
    keyAddProductName = GlobalKey();
    keySettingsLanguage = GlobalKey();
    keySettingsTheme = GlobalKey();
    keyBottomNav = GlobalKey();
    keyProductDetails = GlobalKey();
    keyAppBarTitle = GlobalKey();
  }

  late final GlobalKey keyHomeNav;
  late final GlobalKey keyCartNav;
  late final GlobalKey keyAddProductNav;
  late final GlobalKey keySettingsNav;
  late final GlobalKey keySearch;
  late final GlobalKey keyCart;
  late final GlobalKey keyCategorySection;
  late final GlobalKey keyProductArea;
  late final GlobalKey keyCartListOrEmpty;
  late final GlobalKey keyCartItemsList;
  late final GlobalKey keyCartTotalSection;
  late final GlobalKey keyAddProductForm;
  late final GlobalKey keyAddProductName;
  late final GlobalKey keySettingsLanguage;
  late final GlobalKey keySettingsTheme;
  late final GlobalKey keyBottomNav;
  late final GlobalKey keyProductDetails;
  late final GlobalKey keyAppBarTitle;

  List<TargetFocus> createTargets({
    required Size screenSize,
    required double topSafePadding,
    required void Function(int) onSwitchTab,
    required void Function(int tabIndex, GlobalKey key, VoidCallback next)
        scheduleNextWhenKeyReady,
    required String Function(String key, [Map<String, String>? namedArgs]) getText,
    required void Function(BuildContext context) onNavigateToProductDetails,
    required void Function(VoidCallback next) registerProductDetailsNext,
    required VoidCallback onProductDetailsNextPressed,
    String appName = 'Fsit-Ecommerce Task',
  }) {
    final targets = <TargetFocus>[];

    targets.add(
      TargetFocus(
        identify: 'welcome',
        keyTarget: keyAppBarTitle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              getText(LocaleKeys.coachTour_welcome),
              onNext: ctrl.next,
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
      ),
    );

    targets.add(
      TargetFocus(
        identify: 'homeNav',
        keyTarget: keyHomeNav,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              getText(LocaleKeys.coachTour_homeNav),
              onNext: ctrl.next,
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: true,
      ),
    );

    targets.add(
      TargetFocus(
        identify: 'categoriesProducts',
        keyTarget: keyCategorySection,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              getText(LocaleKeys.coachTour_categoriesProducts),
              onNext: ctrl.next,
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
      ),
    );

    //* Focus on search icon in app bar (after categories)
    targets.add(
      TargetFocus(
        identify: 'search',
        keyTarget: keySearch,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              getText(LocaleKeys.coachTour_search),
              onNext: ctrl.next,
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: true,
      ),
    );

    targets.add(
      TargetFocus(
        identify: 'productArea',
        keyTarget: keyProductArea,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              getText(LocaleKeys.coachTour_productArea),
              onNext: () async {
                onNavigateToProductDetails(context);
                await Future<void>.delayed(const Duration(milliseconds: 600));
                ctrl.next();
              },
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: false,
        enableTargetTab: false,
        shape: ShapeLightFocus.RRect,
      ),
    );

    
    targets.add(
      TargetFocus(
        identify: 'productDetails',
        keyTarget: keyProductDetails,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, ctrl) {
              registerProductDetailsNext(ctrl.next);
              return _buildContentWithNext(
                context,
                getText(LocaleKeys.coachTour_productDetails),
                onNext: onProductDetailsNextPressed,
                getText: getText,
              );
            },
          ),
        ],
        enableOverlayTab: false,
        enableTargetTab: false,
        shape: ShapeLightFocus.RRect,
      ),
    );

    //* Focus on cart icon in app bar (after product details pop) — key on icon itself
    targets.add(
      TargetFocus(
        identify: 'cartIcon',
        keyTarget: keyCart,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.all(20),
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              getText(LocaleKeys.coachTour_cartIcon),
              onNext: () => scheduleNextWhenKeyReady(1, keyCartItemsList, ctrl.next),
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: true,
        enableTargetTab: false,
      ),
    );

    //* Focus on cart item card only (first item or empty-state center)
    targets.add(
      TargetFocus(
        identify: 'cartPage',
        keyTarget: keyCartItemsList,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.only(top: 16),
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              getText(LocaleKeys.coachTour_cartPage),
              onNext: () => scheduleNextWhenKeyReady(2, keyAddProductName, ctrl.next),
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: false,
        enableTargetTab: false,
        shape: ShapeLightFocus.RRect,
      ),
    );

    final addProductW = screenSize.width - 40;
    final addProductH = 72.0;
    final addProductX = 20.0;
    final addProductY = topSafePadding + 24;
    targets.add(
      TargetFocus(
        identify: 'addProduct',
        targetPosition: TargetPosition(
          Size(addProductW, addProductH),
          Offset(addProductX, addProductY),
        ),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.only(top: 16),
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              getText(LocaleKeys.coachTour_addProduct),
              onNext: () => scheduleNextWhenKeyReady(3, keySettingsLanguage, ctrl.next),
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: false,
        enableTargetTab: false,
        shape: ShapeLightFocus.RRect,
      ),
    );

    targets.add(
      TargetFocus(
        identify: 'settingsLanguage',
        keyTarget: keySettingsLanguage,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              getText(LocaleKeys.coachTour_settingsLanguageTheme),
              onNext: ctrl.next,
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
      ),
    );

    //* Focus on theme tile/button (not profile card)
    targets.add(
      TargetFocus(
        identify: 'settingsTheme',
        keyTarget: keySettingsTheme,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.only(top: 16),
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              getText(LocaleKeys.coachTour_settingsLanguageTheme),
              onNext: () => scheduleNextWhenKeyReady(0, keyHomeNav, ctrl.next),
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: false,
        enableTargetTab: false,
        shape: ShapeLightFocus.RRect,
      ),
    );

    targets.add(
      TargetFocus(
        identify: 'closing',
        keyTarget: keyBottomNav,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: const EdgeInsets.only(bottom: 16),
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              getText(LocaleKeys.coachTour_closing),
              onNext: ctrl.next,
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
      ),
    );

    return targets;
  }

  Widget _buildContentWithNext(
    BuildContext context,
    String text, {
    required VoidCallback onNext,
    required String Function(String key, [Map<String, String>? namedArgs]) getText,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
          //* Next button — chip-style, compact width, no` icon
          Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onNext,
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 6.r,
                      offset: Offset(0, 2.r),
                    ),
                  ],
                ),
                child: Text(
                  getText(LocaleKeys.coachTour_next),
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
