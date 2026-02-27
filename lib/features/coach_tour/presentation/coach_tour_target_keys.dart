import 'package:flutter/material.dart';
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
    String appName = 'FIST Ecommerce',
  }) {
    final targets = <TargetFocus>[];

    //* Step 0: Welcome — focus on app bar title + icon
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

    final cartIconSize = 40.0;
    final cartIconX = screenSize.width - cartIconSize - 28;
    final cartIconY = topSafePadding + 16;
    final cartIconText = getText(LocaleKeys.coachTour_cartIcon);
    targets.add(
      TargetFocus(
        identify: 'cartIcon',
        targetPosition: TargetPosition(
          Size(cartIconSize, cartIconSize),
          Offset(cartIconX, cartIconY),
        ),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.all(20),
            builder: (context, ctrl) => _buildContentWithNext(
              context,
              cartIconText,
              onNext: () => scheduleNextWhenKeyReady(1, keyCartListOrEmpty, ctrl.next),
              getText: getText,
            ),
          ),
        ],
        enableOverlayTab: true,
        enableTargetTab: false,
      ),
    );

    final cartPageW = screenSize.width - 40;
    final cartPageH = 160.0;
    final cartPageX = 20.0;
    final cartPageY = topSafePadding + 100;
    targets.add(
      TargetFocus(
        identify: 'cartPage',
        targetPosition: TargetPosition(
          Size(cartPageW, cartPageH),
          Offset(cartPageX, cartPageY),
        ),
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

    final settingsThemeW = screenSize.width - 40;
    final settingsThemeH = 100.0;
    final settingsThemeX = 20.0;
    final settingsThemeY = topSafePadding + 24;
    targets.add(
      TargetFocus(
        identify: 'settingsTheme',
        targetPosition: TargetPosition(
          Size(settingsThemeW, settingsThemeH),
          Offset(settingsThemeX, settingsThemeY),
        ),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onNext,
          child: Text(
            getText(LocaleKeys.coachTour_next),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
