import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class UpdateUserUseCase {
  final AuthRepository _repository;

  UpdateUserUseCase(this._repository);

  Future<Either<Failure, User>> call({
    required String id,
    String? name,
    String? email,
    String? location,
    String? birthDate,
    Uint8List? profileImage,
  }) {
    return _repository.updateUser(
      id: id,
      name: name,
      email: email,
      location: location,
      birthDate: birthDate,
      profileImage: profileImage,
    );
  }
}
