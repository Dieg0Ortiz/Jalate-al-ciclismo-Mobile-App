import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String lastNameP,
    required String lastNameM,
  });

  Future<Either<Failure, User>> loginWithGoogle();
  Future<Either<Failure, User>> loginWithApple();
  Future<Either<Failure, User>> loginWithStrava();

  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> updateUser({
    required String id,
    String? name,
    String? email,
    String? location,
    String? birthDate,
    Uint8List? profileImage,
  });

  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, bool>> isLoggedIn();
}
