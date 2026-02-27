import 'package:dartz/dartz.dart';

import '../../../../core/domain/failure.dart';

//* Abstract auth repository contract.

abstract class IAuthRepository {
  Future<Either<Failure, String>> login(
    String username,
    String password,
  );
}
