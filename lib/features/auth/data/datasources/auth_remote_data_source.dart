import 'package:dartz/dartz.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/network/network_client.dart';
import '../models/auth_model.dart';

//* Remote data source for auth API.
//? Uses NetworkClient; returns Either for repository to map to domain Failure.

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final NetworkClient _client;

  /// Logs in with [username] and [password]. Returns AuthModel on success.
  Future<Either<NetworkFailure, AuthModel>> login(
    String username,
    String password,
  ) async {
    final result = await _client.post(
      ApiConfig.authLoginPath,
      data: <String, dynamic>{
        'username': username,
        'password': password,
      },
    );
    return result.fold(
      Left.new,
      (response) {
        final data = response.data;
        if (data is! Map<String, dynamic>) {
          return Left(const NetworkFailure(
            message: 'Invalid auth response format',
          ));
        }
        try {
          final model = AuthModel.fromJson(data);
          return Right(model);
        } catch (e) {
          return Left(NetworkFailure(message: 'Failed to parse auth: $e'));
        }
      },
    );
  }
}
