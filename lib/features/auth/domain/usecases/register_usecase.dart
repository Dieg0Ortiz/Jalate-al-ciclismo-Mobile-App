import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call({
    required String name,
    required String lastNameP,
    required String lastNameM,
    required String email,
    required String password,
  }) {
    return _repository.register(
      name: name,
      lastNameP: lastNameP,
      lastNameM: lastNameM,
      email: email,
      password: password,
    );
  }

}
