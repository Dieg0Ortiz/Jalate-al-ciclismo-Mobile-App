// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:proyecto_mvp/core/di/di_module.dart' as _i172;
import 'package:proyecto_mvp/core/theme/theme_bloc.dart' as _i446;
import 'package:proyecto_mvp/features/auth/data/datasources/auth_local_datasource.dart'
    as _i134;
import 'package:proyecto_mvp/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i76;
import 'package:proyecto_mvp/features/auth/data/repositories/auth_repository_impl.dart'
    as _i513;
import 'package:proyecto_mvp/features/auth/domain/repositories/auth_repository.dart'
    as _i196;
import 'package:proyecto_mvp/features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i243;
import 'package:proyecto_mvp/features/auth/domain/usecases/login_usecase.dart'
    as _i953;
import 'package:proyecto_mvp/features/auth/domain/usecases/logout_usecase.dart'
    as _i159;
import 'package:proyecto_mvp/features/auth/domain/usecases/register_usecase.dart'
    as _i755;
import 'package:proyecto_mvp/features/auth/domain/usecases/update_user_usecase.dart'
    as _i864;
import 'package:proyecto_mvp/features/auth/presentation/bloc/auth_bloc.dart'
    as _i348;
import 'package:proyecto_mvp/features/home/data/datasources/home_remote_data_source.dart'
    as _i310;
import 'package:proyecto_mvp/features/home/data/repositories/home_repository_impl.dart'
    as _i1026;
import 'package:proyecto_mvp/features/home/domain/repositories/home_repository.dart'
    as _i519;
import 'package:proyecto_mvp/features/home/domain/usecases/get_home_data.dart'
    as _i998;
import 'package:proyecto_mvp/features/home/presentation/bloc/home_bloc.dart'
    as _i7;
import 'package:proyecto_mvp/features/profile/presentation/bloc/bikes_bloc.dart'
    as _i559;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final diModule = _$DiModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => diModule.prefs,
      preResolve: true,
    );
    gh.factory<_i559.BikesBloc>(() => _i559.BikesBloc());
    gh.lazySingleton<_i361.Dio>(() => diModule.dio);
    gh.factory<_i446.ThemeBloc>(
      () => _i446.ThemeBloc(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i310.HomeRemoteDataSource>(
      () => _i310.HomeRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i76.AuthRemoteDataSource>(
      () => _i76.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i519.HomeRepository>(
      () => _i1026.HomeRepositoryImpl(gh<_i310.HomeRemoteDataSource>()),
    );
    gh.lazySingleton<_i134.AuthLocalDataSource>(
      () => _i134.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i998.GetHomeData>(
      () => _i998.GetHomeData(gh<_i519.HomeRepository>()),
    );
    gh.lazySingleton<_i196.AuthRepository>(
      () => _i513.AuthRepositoryImpl(
        gh<_i76.AuthRemoteDataSource>(),
        gh<_i134.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i7.HomeBloc>(() => _i7.HomeBloc(gh<_i998.GetHomeData>()));
    gh.lazySingleton<_i864.UpdateUserUseCase>(
      () => _i864.UpdateUserUseCase(gh<_i196.AuthRepository>()),
    );
    gh.factory<_i755.RegisterUseCase>(
      () => _i755.RegisterUseCase(gh<_i196.AuthRepository>()),
    );
    gh.factory<_i953.LoginUseCase>(
      () => _i953.LoginUseCase(gh<_i196.AuthRepository>()),
    );
    gh.factory<_i159.LogoutUseCase>(
      () => _i159.LogoutUseCase(gh<_i196.AuthRepository>()),
    );
    gh.factory<_i243.GetCurrentUserUseCase>(
      () => _i243.GetCurrentUserUseCase(gh<_i196.AuthRepository>()),
    );
    gh.factory<_i348.AuthBloc>(
      () => _i348.AuthBloc(
        gh<_i953.LoginUseCase>(),
        gh<_i755.RegisterUseCase>(),
        gh<_i159.LogoutUseCase>(),
        gh<_i243.GetCurrentUserUseCase>(),
        gh<_i864.UpdateUserUseCase>(),
      ),
    );
    return this;
  }
}

class _$DiModule extends _i172.DiModule {}
