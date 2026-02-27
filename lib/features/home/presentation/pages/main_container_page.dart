import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fsit_flutter_task_ecommerce/features/coach_tour/presentation/coach_tour_controller.dart';

import '../../../../core/component/custom_bottom_nav_bar.dart';
import '../../../../core/component/exit_dialog.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/shared/app_scaffold.dart';
import '../../../add_product/presentation/bloc/add_product_bloc.dart';
import '../../../add_product/presentation/bloc/add_product_event.dart';
import '../../../add_product/presentation/pages/add_product_page.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../coach_tour/coach_tour.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'home_page.dart';

//* Main container with bottom nav; all tab/page index logic in [HomeBloc].
//? [PageView] with slide animation; no AutomaticKeepAlive (causes KeepAlive/RepaintBoundary conflict).

class MainContainerPage extends StatefulWidget {
  const MainContainerPage({super.key});

  @override
  State<MainContainerPage> createState() => _MainContainerPageState();
}

class _MainContainerPageState extends State<MainContainerPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(BuildContext context, int index) {
    context.read<HomeBloc>().add(BottomNavIndexChanged(index));
  }

  void _onTabChange(BuildContext context, int index) {
    AppHaptic.selection();
    context.read<HomeBloc>().add(BottomNavIndexChanged(index));
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider<HomeBloc>(
      create: (_) => getIt<HomeBloc>()..add(const LoadHome()),
      child: BlocProvider<AddProductBloc>(
        create: (_) =>
            getIt<AddProductBloc>()..add(const LoadCategoriesRequested()),
        child: BlocBuilder<CartBloc, CartState>(
          buildWhen: (prev, curr) => prev.itemCount != curr.itemCount,
          builder: (context, cartState) {
          return BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (prev, curr) =>
                prev.selectedBottomNavIndex != curr.selectedBottomNavIndex,
            builder: (context, state) {
              final keys = getIt<CoachTourTargetKeys>();
              return PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) async {
                    if (didPop) return;
                    final shouldExit =
                        await ExitDialog.show(context);
                    if (shouldExit && context.mounted) {
                      SystemNavigator.pop();
                    }
                  },
                  child: CoachTourOrchestrator(
                    pageController: _pageController,
                    onTabChange: (index) => _onTabChange(context, index),
                    keys: keys,
                    storage: getIt<CoachTourStorage>(),
                    onRegistered: (showTour) =>
                        getIt<CoachTourController>().register(showTour),
                    child: AppScaffold.clean(
                    backgroundColor: theme.colorScheme.surface,
                    body: SafeArea(
                      bottom: false,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (index) =>
                            _onPageChanged(context, index),
                        children: [
                          HomePage(
                            cartCount: cartState.itemCount,
                            onCartTap: () => _onTabChange(context, 1),
                            searchKey: keys.keySearch,
                            cartKey: keys.keyCart,
                            appBarTitleKey: keys.keyAppBarTitle,
                            categorySectionKey: keys.keyCategorySection,
                            productAreaKey: keys.keyProductArea,
                          ),
                          CartPage(
                            cartListKey: keys.keyCartListOrEmpty,
                            cartItemsKey: keys.keyCartItemsList,
                            cartTotalKey: keys.keyCartTotalSection,
                          ),
                          AddProductPage(
                            addProductFormKey: keys.keyAddProductForm,
                            addProductNameKey: keys.keyAddProductName,
                          ),
                          SettingsPage(
                            languageKey: keys.keySettingsLanguage,
                            themeKey: keys.keySettingsTheme,
                            onShowTourAgain: () async {
                              _onTabChange(context, 0);
                              await getIt<CoachTourStorage>().setCompleted(false);
                              await Future<void>.delayed(
                                const Duration(milliseconds: 400),
                              );
                              getIt<CoachTourController>().showTour();
                            },
                          ),
                        ],
                      ),
                    ),
                    bottomNavigationBar: CustomBottomNavBar(
                      selectedIndex: state.selectedBottomNavIndex,
                      onTabChange: (index) => _onTabChange(context, index),
                      bottomNavKey: keys.keyBottomNav,
                      homeNavKey: keys.keyHomeNav,
                      cartNavKey: keys.keyCartNav,
                      addProductNavKey: keys.keyAddProductNav,
                      settingsNavKey: keys.keySettingsNav,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      ),
    );
  }
}
