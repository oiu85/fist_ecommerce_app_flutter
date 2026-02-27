import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/custom_bottom_nav_bar.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/shared/app_scaffold.dart';
import '../../../add_product/presentation/pages/add_product_page.dart';
import '../../../cart/presentation/pages/cart_page.dart';
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
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (prev, curr) => prev.selectedBottomNavIndex != curr.selectedBottomNavIndex,
        builder: (context, state) {
          return AppScaffold.clean(
            backgroundColor: theme.colorScheme.surface,
            body: SafeArea(
              bottom: false,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => _onPageChanged(context, index),
                children: const [
                  HomePage(),
                  CartPage(),
                  AddProductPage(),
                  SettingsPage(),
                ],
              ),
            ),
            bottomNavigationBar: CustomBottomNavBar(
              selectedIndex: state.selectedBottomNavIndex,
              onTabChange: (index) => _onTabChange(context, index),
            ),
          );
        },
      ),
    );
  }
}
