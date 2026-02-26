import 'package:flutter/material.dart';

import '../../../../core/component/custom_bottom_nav_bar.dart';
import '../../../../core/shared/app_scaffold.dart';
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
          children: const [HomePage(), _CartPlaceholderPage(), _AddProductPlaceholderPage()],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: _selectedIndex, onTabChange: _onTabChange),
    );
  }
}

class _ComingSoonPage extends StatelessWidget {
  const _ComingSoonPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text('Coming soon', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSurface)),
    );
  }
}

class _CartPlaceholderPage extends StatelessWidget {
  const _CartPlaceholderPage();

  @override
  Widget build(BuildContext context) => const _ComingSoonPage();
}

class _AddProductPlaceholderPage extends StatelessWidget {
  const _AddProductPlaceholderPage();

  @override
  Widget build(BuildContext context) => const _ComingSoonPage();
}
