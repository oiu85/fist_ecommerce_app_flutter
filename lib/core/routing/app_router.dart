import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../di/app_dependencies.dart';
import '../storage/app_storage_service.dart';
import 'app_routes.dart';

class AppRouter {
  /// Creates and returns the router with authentication-aware redirect logic.
  static Future<GoRouter> createRouter() async {
    // Check authentication status to set initial location
    final storageService = getIt<AppStorageService>();
    final token = await storageService.getAccessToken();
    final initialLocation = (token != null && token.isNotEmpty)
        ? AppRoutes.home
        : AppRoutes.login;

    return GoRouter(
      initialLocation: initialLocation,
      debugLogDiagnostics: kDebugMode,
      redirect: (context, state) async {
        final storageService = getIt<AppStorageService>();
        final token = await storageService.getAccessToken();
        final isAuthenticated = token != null && token.isNotEmpty;
        final isLoginRoute = state.matchedLocation == AppRoutes.login;

        // If authenticated and trying to access login, redirect to home
        if (isAuthenticated && isLoginRoute) {
          return AppRoutes.home;
        }

        // If not authenticated and trying to access protected routes, redirect to login
        if (!isAuthenticated && !isLoginRoute) {
          return AppRoutes.login;
        }

        // No redirect needed
        return null;
      },
      routes: [],
    );
  }

  /// Static router instance - initialized after dependencies are ready.
  static GoRouter? _router;
  
  /// Initialize the router - must be called after configureDependencies().
  static Future<void> initialize() async {
    _router = await createRouter();
  }
  
  /// Get the router instance.
  /// Throws if router is not initialized.
  static GoRouter get router {
    if (_router == null) {
      throw StateError(
        'AppRouter.router accessed before initialization. '
        'Call AppRouter.initialize() first.',
      );
    }
    return _router!;
  }
}
