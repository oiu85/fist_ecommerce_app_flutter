import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/status/bloc_status.dart';
import '../../domain/usecases/login_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

//* Auth BLoC — login logic via LoginUseCase.

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(AuthState.initial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final LoginUseCase _loginUseCase;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    //* Validate empty credentials before hitting API
    final username = event.username.trim();
    final password = event.password;
    if (username.isEmpty || password.isEmpty) {
      final msg = LocaleKeys.validation_required.tr();
      emit(state.copyWith(
        status: BlocStatus.fail(error: msg),
        errorMessage: msg,
      ));
      return;
    }

    emit(state.copyWith(
      status: const BlocStatus.loading(),
      clearErrorMessage: true,
    ));

    final result = await _loginUseCase.call(
      username: username,
      password: password,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: BlocStatus.fail(error: failure.message),
          errorMessage: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(
          status: const BlocStatus.success(),
          clearErrorMessage: true,
        ));
      },
    );
  }
}
