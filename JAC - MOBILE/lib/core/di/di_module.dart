import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class DiModule {
  @lazySingleton
  Dio get dio => Dio(
        BaseOptions(
          // baseUrl: AppConstants.baseUrl, // Comentado hasta que tengamos backend
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
