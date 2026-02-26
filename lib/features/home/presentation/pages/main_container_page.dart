import 'package:flutter/material.dart';

import '../../../../core/component/custom_bottom_nav_bar.dart';
import '../../../../core/haptic/app_haptic.dart';
import '../../../../core/shared/app_scaffold.dart';
import '../../../add_product/presentation/pages/add_product_page.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import 'home_page.dart';

class MainContainerPage extends StatefulWidget {
  const MainContainerPage({super.key});

  @override
  State<MainContainerPage> createState() => _MainContainerPageState();
}

class _MainContainerPageState extends State<MainContainerPage> {
  late final PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onTabChange(int index) {
    AppHaptic.selection();
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold.clean(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: _onPageChanged,
          children: const [
            HomePage(),
            CartPage(),
            AddProductPage(),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: _selectedIndex, onTabChange: _onTabChange),
    );
  }
}

