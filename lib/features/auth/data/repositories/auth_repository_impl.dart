import 'package:dartz/dartz.dart';

import '../../../../core/domain/failure.dart';
import '../../../../core/storage/app_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

//* Implementation of [IAuthRepository].

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl(this._dataSource, this._storage);

  final AuthRemoteDataSource _dataSource;
  final AppStorageService _storage;

  @override
  Future<Either<Failure, String>> login(
    String username,
    String password,
  ) async {
    final result = await _dataSource.login(username, password);
    return result.fold(
      (nf) => Left(Failure(message: nf.message)),
      (model) async {
        await _storage.setAccessToken(model.token);
        await _storage.setUserName(username);
        await _storage.setLoggedIn(true);
        return Right(model.token);
      },
    );
  }
}
