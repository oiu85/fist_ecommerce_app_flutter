import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/component/app_snackbar.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/shared/app_scaffold.dart';
import '../../../../core/storage/app_storage_service.dart';
import '../../../product_details/presentation/widgets/back_button.dart';
import '../widgets/login_footer_section.dart';
import '../widgets/login_form_section.dart';
import '../widgets/login_header_section.dart';
import '../widgets/login_sign_in_button.dart';
import '../widgets/login_social_section.dart';

/// Login page — composes header, form, sign-in button, social options, footer.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    //! TODO: Connect to AuthBloc when implemented; placeholder sets auth for guard
    final storage = getIt<AppStorageService>();
    await storage.setAccessToken('placeholder');
    await storage.setLoggedIn(true);
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  void _onForgotPassword() {
    //! TODO: Navigate to forgot password flow when implemented
    AppSnackbar.showInfo(
      context,
      LocaleKeys.auth_comingSoon,
      translation: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold.clean(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //* Header: logo, app name, welcome subtitle
              LoginHeaderSection(),
              SizedBox(height: 48.h),

              //* Form: username, password, forgot link
              LoginFormSection(
                usernameController: _usernameController,
                passwordController: _passwordController,
                onForgotPassword: _onForgotPassword,
              ),
              SizedBox(height: 24.h),

              //* Sign in button
              LoginSignInButton(onPressed: _onSignIn),
              SizedBox(height: 24.h),

              //* Or + Google / Apple buttons
              LoginSocialSection(
                onGoogleSignIn: () {
                  AppSnackbar.showInfo(
                    context,
                    LocaleKeys.auth_comingSoon,
                    translation: true,
                  );
                },
                onAppleSignIn: () {
                  AppSnackbar.showInfo(
                    context,
                    LocaleKeys.auth_comingSoon,
                    translation: true,
                  );
                },
              ),
              SizedBox(height: 40.h),

              //* Create account + Privacy / Terms
              LoginFooterSection(
                onCreateAccountTap: () {
                  AppSnackbar.showInfo(
                    context,
                    LocaleKeys.auth_comingSoon,
                    translation: true,
                  );
                },
              ),
            ],
              ),
            ),
          ),
          PositionedDirectional(
            start: 16.w,
            top: MediaQuery.paddingOf(context).top + 24.h,
            child: ProductDetailsBackButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.home);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
