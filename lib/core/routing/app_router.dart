import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/cart/presentation/bloc/cart_event.dart';
import '../../features/coach_tour/coach_tour.dart';
import '../../features/home/presentation/pages/main_container_page.dart';
import '../../features/product_details/presentation/pages/product_details_page.dart';
import '../../mock_data/product_details_mock_data.dart';
import '../component/app_snackbar.dart';
import '../di/app_dependencies.dart';
import '../localization/locale_keys.g.dart';
import '../storage/app_storage_service.dart';
import 'app_routes.dart';

class AppRouter {
  /// Creates and returns the router; initial page is home.
  static Future<GoRouter> createRouter() async {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: kDebugMode,
      redirect: (context, state) async {
        final storageService = getIt<AppStorageService>();
        final token = await storageService.getAccessToken();
        final isAuthenticated = token != null && token.isNotEmpty;
        final isLoginRoute = state.matchedLocation == AppRoutes.login;

        //? If authenticated and on login, go to home
        if (isAuthenticated && isLoginRoute) {
          return AppRoutes.home;
        }

        //? Auth redirect disabled until login route exists — show home for all
        // if (!isAuthenticated && !isLoginRoute) {
        //   return AppRoutes.login;
        // }

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const MainContainerPage(),
        ),
        GoRoute(
          path: '/home',
          name: 'homeNamed',
          builder: (context, state) => const MainContainerPage(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.productDetails,
          name: 'productDetails',
          builder: (context, state) {
            final extra = state.extra;
            final ProductDetailsPayload p;
            final bool isTourMode;
            if (extra is ProductDetailsRouteExtra) {
              p = extra.payload;
              isTourMode = extra.forCoachTour;
            } else {
              p = (extra as ProductDetailsPayload?) ?? mockProductDetailsPayload;
              isTourMode = false;
            }
            final keys = getIt<CoachTourTargetKeys>();
            return ProductDetailsPage(
              payload: p,
              productDetailsKey: isTourMode ? keys.keyProductDetails : null,
              scrollToAddToCartForTour: isTourMode,
              onBack: () => context.pop(),
              onAddToCart: p.productId != null
                  ? (q) {
                      context.read<CartBloc>().add(
                            AddToCart(productId: p.productId!, quantity: q),
                          );
                      AppSnackbar.showSuccess(context, LocaleKeys.cart_added);
                    }
                  : null,
            );
          },
        ),
      ],
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
