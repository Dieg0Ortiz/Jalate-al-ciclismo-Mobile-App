import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithGoogle();
  Future<UserModel> loginWithApple();
  Future<UserModel> loginWithStrava();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  // ignore: unused_field
  final Dio _dio;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Autenticación mock sin backend
    // Para cuando vean esto, estos son usuarios de prueba, descomentar el código de abajo y comentar este bloque cuando tengamos backend

    await Future.delayed(const Duration(seconds: 1));

    if (email == 'test@example.com' && password == 'password123') {
      return UserModel(
        id: '1',
        name: 'Usuario de Prueba',
        email: email,
      );
    }

    if (email == 'carlos@example.com' && password == 'password123') {
      return UserModel(
        id: '2',
        name: 'Carlos',
        email: email,
      );
    }

    // Cualquier otra combinación válida (para testing rápido)
    if (password.length >= 6) {
      return UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: email.split('@').first,
        email: email,
      );
    }

    throw const AuthenticationException('Credenciales inválidas');

    /* Código para cuando tengamos backend (descomentar cuando tengamos backend):
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthenticationException('Credenciales inválidas');
      }
      throw ServerException(e.message ?? 'Error al iniciar sesión');
    } catch (e) {
      if (e is ServerException || e is AuthenticationException) {
        rethrow;
      }
      throw ServerException('Error desconocido al iniciar sesión');
    }
    */
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // MODO DESARROLLO: Registro mock sin backend
    // Para producción, descomentar el código de abajo y comentar este bloque

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    // Validación básica
    if (password.length < 6) {
      throw const ValidationException(
          'La contraseña debe tener al menos 6 caracteres',);
    }

    if (!email.contains('@')) {
      throw const ValidationException('Email inválido');
    }

    // Crear usuario mock
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );

    /* Código para cuando tengamos backend (descomentar cuando tengamos backend):
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ValidationException(e.response?.data['message'] ?? 'Datos inválidos');
      }
      throw ServerException(e.message ?? 'Error al registrarse');
    } catch (e) {
      if (e is ServerException || e is ValidationException) {
        rethrow;
      }
      throw ServerException('Error desconocido al registrarse');
    }
    */
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    //implementar inicio de sesión con Google
    throw UnimplementedError();
  }

  @override
  Future<UserModel> loginWithApple() async {
    // Implementar inicio de sesión con Apple
    throw UnimplementedError();
  }

  @override
  Future<UserModel> loginWithStrava() async {
    // Implementar inicio de sesión con Strava
    throw UnimplementedError();
  }
}
