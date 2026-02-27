import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../gen/assets.gen.dart';
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool _hasNavigated = false;

  void _navigateToHome() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    //* Match app theme: light/dark background based on MediaQuery
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.primaryNavy : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: RepaintBoundary(
        child: SafeArea(
          child: Center(
            child: Lottie.asset(
              Assets.lottie.screenSplash,
              fit: BoxFit.contain,
              repeat: false,
              addRepaintBoundary: true,
              width: double.infinity,
              height: double.infinity,
              onLoaded: (composition) {
                //* Redirect when animation completes using composition duration
                Future.delayed(composition.duration, _navigateToHome);
              },
              errorBuilder: (context, error, stackTrace) {
                //! Fallback: navigate immediately if Lottie fails to load
                Future.microtask(_navigateToHome);
                return Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64.r,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Loading...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
