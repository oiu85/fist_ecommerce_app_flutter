import 'package:dartz/dartz.dart';

import '../../../../core/domain/failure.dart';
import '../repositories/auth_repository.dart';

//* Use case to perform login.

class LoginUseCase {
  LoginUseCase(this._repository);
  final IAuthRepository _repository;
  Future<Either<Failure, String>> call({
    required String username,
    required String password,
  }) {
    return _repository.login(username, password);
  }
}
