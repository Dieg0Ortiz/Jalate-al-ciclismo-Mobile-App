import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String lastNameP,
    required String lastNameM,
  });

  Future<UserModel> loginWithGoogle();
  Future<UserModel> loginWithApple();
  Future<UserModel> loginWithStrava();

  Future<UserModel> updateUser({
    required String id,
    String? name,
    String? email,
    String? location,
    String? birthDate,
    Uint8List? profileImage,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🟦 === INICIO LOGIN ===');
      print('🟦 Email: $email');

      final response = await _dio.post(
        '/auth/v1/login',
        data: FormData.fromMap({'correo': email, 'contrasena': password}),
        options: Options(
          contentType: 'multipart/form-data',
          validateStatus: (status) => status! < 500,
        ),
      );

      print('🟦 Login Status Code: ${response.statusCode}');
      print('🟦 Login Response completo: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data is! Map) {
          throw const AuthenticationException(
            'Respuesta inválida del servidor',
          );
        }

        // CASO 1: Respuesta con token pero sin datos de usuario
        if (data.containsKey('access_token') || data.containsKey('token')) {
          final token =
              data['access_token']?.toString() ?? data['token']?.toString();

          if (token == null || token.isEmpty) {
            throw const AuthenticationException('Token no recibido');
          }

          print('🟦 Token recibido, creando usuario con email');

          // TODO: Guardar token para futuras peticiones
          // await _saveToken(token);

          // Crear usuario con datos del email
          return UserModel(
            id: '0',
            name: email.split('@')[0].replaceAll('.', ' ').trim(),
            email: email,
          );
        }

        // CASO 2: Respuesta con datos de usuario
        dynamic userData;

        if (data.containsKey('data') && data['data'] is Map) {
          final dataObj = data['data'];
          if (dataObj.containsKey('user')) {
            userData = dataObj['user'];
            print('🟦 Usando data.user');
          } else {
            userData = dataObj;
            print('🟦 Usando data directamente');
          }
        } else if (data.containsKey('user')) {
          userData = data['user'];
          print('🟦 Usando user directamente');
        } else if (data.containsKey('id') || data.containsKey('nombre')) {
          userData = data;
          print('🟦 Usando response.data directamente');
        } else {
          print('🔴 Estructura desconocida - Keys: ${data.keys.toList()}');
          throw const AuthenticationException(
            'Estructura de respuesta desconocida',
          );
        }

        print('🟦 User Data extraído: $userData');

        // Construir usuario desde userData
        final userId = userData['id']?.toString() ?? '0';

        String userName = 'Usuario';
        if (userData['nombre'] != null) {
          userName = userData['nombre'].toString();
          if (userData['apellido_paterno'] != null) {
            userName += ' ${userData['apellido_paterno']}';
          }
          if (userData['apellido_materno'] != null) {
            userName += ' ${userData['apellido_materno']}';
          }
        } else if (userData['name'] != null) {
          userName = userData['name'].toString();
        }

        final userEmail =
            userData['correo']?.toString() ??
            userData['email']?.toString() ??
            email;

        print('🟦 Usuario construido:');
        print('   - ID: $userId');
        print('   - Nombre: $userName');
        print('   - Email: $userEmail');

        return UserModel(id: userId, name: userName, email: userEmail);
      } else if (response.statusCode == 401) {
        throw const AuthenticationException('Credenciales inválidas');
      } else {
        final errorMsg = response.data is Map
            ? (response.data['message'] ?? 'Error al iniciar sesión')
            : 'Error al iniciar sesión';
        throw ServerException(errorMsg);
      }
    } on DioException catch (e) {
      print('🔴 Login DioException: ${e.type}');
      print('🔴 Message: ${e.message}');

      if (e.response?.statusCode == 401) {
        throw const AuthenticationException('Credenciales inválidas');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw ServerException(
          'Tiempo de espera agotado. Verifica tu conexión.',
        );
      }

      throw ServerException(e.message ?? 'Error al iniciar sesión');
    } catch (e) {
      print('🔴 Login error: $e');
      if (e is AuthenticationException || e is ServerException) rethrow;
      throw ServerException('Error desconocido al iniciar sesión');
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String lastNameP,
    required String lastNameM,
    required String email,
    required String password,
  }) async {
    try {
      print('🟦 === INICIO REGISTRO ===');
      print('🟦 Nombre: $name');
      print('🟦 Apellido P: $lastNameP');
      print('🟦 Apellido M: $lastNameM');
      print('🟦 Email: $email');
      print('🟦 Contraseña: ${password.length} caracteres');

      final formData = FormData.fromMap({
        'nombre': name,
        'apellido_paterno': lastNameP,
        'apellido_materno': lastNameM,
        'correo': email,
        'contrasena': password,
        'url_foto': '',
      });

      print(
        '🟦 Enviando request a: https://jalatealciclismo.ddns.net/auth/v1/register',
      );

      final response = await _dio.post(
        'https://jalatealciclismo.ddns.net/auth/v1/register',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          validateStatus: (status) => status! < 500,
        ),
      );

      print('🟦 Status Code: ${response.statusCode}');
      print('🟦 Response completa: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        dynamic userData;

        if (responseData is Map) {
          if (responseData.containsKey('data')) {
            userData = responseData['data'];
            print('🟦 Usando responseData["data"]');
          } else if (responseData.containsKey('id') ||
              responseData.containsKey('nombre')) {
            userData = responseData;
            print('🟦 Usando responseData directamente');
          } else if (responseData.containsKey('user')) {
            userData = responseData['user'];
            print('🟦 Usando responseData["user"]');
          } else {
            print('🔴 Estructura desconocida de respuesta');
            throw ServerException(
              'Respuesta del servidor en formato desconocido',
            );
          }
        } else {
          print('🔴 Response no es un Map');
          throw ServerException('Respuesta del servidor inválida');
        }

        print('🟦 User Data: $userData');

        final userId = userData['id']?.toString() ?? '0';
        final userName = userData['nombre']?.toString() ?? name;
        final userLastNameP =
            userData['apellido_paterno']?.toString() ?? lastNameP;
        final userLastNameM =
            userData['apellido_materno']?.toString() ?? lastNameM;
        final userEmail = userData['correo']?.toString() ?? email;

        final fullName = '$userName $userLastNameP $userLastNameM'.trim();

        print(
          '🟦 Usuario creado: ID=$userId, Nombre=$fullName, Email=$userEmail',
        );

        return UserModel(id: userId, name: fullName, email: userEmail);
      } else if (response.statusCode == 400) {
        final errorMsg = response.data is Map
            ? (response.data['message'] ??
                  response.data['error'] ??
                  'Datos inválidos')
            : 'Datos inválidos';
        print('🔴 Error 400: $errorMsg');
        throw ValidationException(errorMsg);
      } else if (response.statusCode == 422) {
        final errorMsg = response.data is Map
            ? (response.data['message'] ??
                  response.data['error'] ??
                  'El email ya está registrado')
            : 'Error de validación';
        print('🔴 Error 422: $errorMsg');
        throw ValidationException(errorMsg);
      } else {
        final errorMsg = response.data is Map
            ? (response.data['message'] ?? 'Error al registrarse')
            : 'Error al registrarse: ${response.statusCode}';
        print('🔴 Error ${response.statusCode}: $errorMsg');
        throw ServerException(errorMsg);
      }
    } on DioException catch (e) {
      print('🔴 DioException detectado');
      print('🔴 Tipo: ${e.type}');
      print('🔴 Mensaje: ${e.message}');
      print('🔴 Response: ${e.response?.data}');
      print('🔴 Status Code: ${e.response?.statusCode}');

      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final errorData = e.response!.data;

        String errorMessage = 'Error al registrarse';

        if (errorData is Map) {
          errorMessage =
              errorData['message']?.toString() ??
              errorData['error']?.toString() ??
              'Error al registrarse';
        }

        if (statusCode == 422 || statusCode == 400) {
          throw ValidationException(errorMessage);
        } else {
          throw ServerException(errorMessage);
        }
      } else {
        throw ServerException('Error de conexión. Verifica tu internet.');
      }
    } catch (e) {
      print('🔴 Error catch genérico: $e');
      print('🔴 Tipo: ${e.runtimeType}');

      if (e is ValidationException || e is ServerException) {
        rethrow;
      }
      throw ServerException('Error desconocido al registrarse: $e');
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> loginWithApple() async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> loginWithStrava() async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateUser({
    required String id,
    String? name,
    String? email,
    String? location,
    String? birthDate,
    Uint8List? profileImage,
  }) async {
    // Simular petición al servidor
    await Future.delayed(const Duration(seconds: 1));

    // En una implementación real, aquí se subiría la imagen y se actualizarían los datos
    // Por ahora, retornamos el usuario con los datos actualizados
    return UserModel(
      id: id,
      name: name ?? 'Usuario',
      email: email ?? '',
      location: location,
      birthDate: birthDate,
      photoUrl: profileImage != null ? 'path/to/new/image' : null,
    );
  }
}
