import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/component/app_snackbar.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/shared/app_scaffold.dart';
import '../../../product_details/presentation/widgets/back_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_footer_section.dart';
import '../widgets/login_form_section.dart';
import '../widgets/login_header_section.dart';
import '../widgets/login_info_banner.dart';
import '../widgets/login_sign_in_button.dart';
import '../widgets/login_social_section.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showInfoBanner = true;

  static const String _defaultUsername = 'mor_2314';
  static const String _defaultPassword = '83r5^_';

  @override
  void initState() {
    super.initState();
    //* Pre-fill with default credentials for demo
    _usernameController.text = _defaultUsername;
    _passwordController.text = _defaultPassword;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn(BuildContext context) {
    //* Validate via core validators before API call
    if (!(_formKey.currentState?.validate() ?? false)) return;
    //* Dispatch to AuthBloc; BLoC calls API
    context.read<AuthBloc>().add(
          LoginSubmitted(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
          ),
        );
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

    return BlocProvider<AuthBloc>(
      create: (_) => getIt<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status.isSuccess()) {
            AppSnackbar.showSuccess(
              context,
              LocaleKeys.auth_loginSuccess,
              translation: true,
            );
            context.go(AppRoutes.home);
          }
          if (state.status.isFail()) {
            final msg = state.errorMessage ?? LocaleKeys.auth_loginError;
            AppSnackbar.showError(
              context,
              msg,
              translation: state.errorMessage == null,
            );
          }
        },
        child: AppScaffold.clean(
          backgroundColor: theme.colorScheme.surface,
          body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
              child: Form(
            key: _formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //* Top info banner — default login credentials hint
              if (_showInfoBanner) ...[
                LoginInfoBanner(
                  onDismiss: () => setState(() => _showInfoBanner = false),
                ),
                SizedBox(height: 24.h),
              ],
              //* Header: logo, app name, welcome subtitle
              LoginHeaderSection(),
              SizedBox(height: 48.h),

              //* Form: username, password, forgot link — with core validators
              LoginFormSection(
                usernameController: _usernameController,
                passwordController: _passwordController,
                onForgotPassword: _onForgotPassword,
              ),
              SizedBox(height: 24.h),

              //* Sign in button — disabled during loading
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (prev, curr) => prev.status != curr.status,
                builder: (context, state) => LoginSignInButton(
                  onPressed: () => _onSignIn(context),
                  isLoading: state.status.isLoading(),
                ),
              ),
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
    ),
  ),
    );
  }
}
