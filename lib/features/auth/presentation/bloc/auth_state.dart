import 'package:equatable/equatable.dart';

import '../../../../core/status/bloc_status.dart';

//* Auth screen state — login status and error message.

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.errorMessage,
  });

  final BlocStatus status;
  final String? errorMessage;

  factory AuthState.initial() => const AuthState(
        status: BlocStatus.initial(),
        errorMessage: null,
      );

  AuthState copyWith({
    BlocStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) =>
      AuthState(
        status: status ?? this.status,
        errorMessage:
            clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      );

  @override
  List<Object?> get props => [status, errorMessage];
}
