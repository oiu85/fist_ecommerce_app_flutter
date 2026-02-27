import 'package:equatable/equatable.dart';

//* Auth screen events — login submission.

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// User submitted login form with [username] and [password].
class LoginSubmitted extends AuthEvent {
  const LoginSubmitted({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object?> get props => [username, password];
}
