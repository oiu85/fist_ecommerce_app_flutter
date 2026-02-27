import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../component/app_snackbar.dart';
import '../di/app_dependencies.dart';
import '../localization/locale_keys.g.dart';
import '../routing/app_routes.dart';
import '../storage/app_storage_service.dart';

//* Auth guard responsible for protecting cart/product/add-product actions.


abstract class AuthGuard {
  AuthGuard._();

  /// Returns true only when user has isLoggedIn == true and a non-empty token.
  static Future<bool> isAuthenticated() async {
    final storage = getIt<AppStorageService>();
    final token = await storage.getAccessToken();
    final loggedIn = await storage.isLoggedIn();
    return loggedIn && token != null && token.isNotEmpty;
  }

  static Future<bool> requireAuth(BuildContext context) async {
    final ok = await isAuthenticated();
    if (!ok && context.mounted) {
      AppSnackbar.showInfo(
        context,
        LocaleKeys.auth_mustLoginFirst,
        translation: true,
      );
      context.push(AppRoutes.login);
      return false;
    }
    return ok;
  }
}
