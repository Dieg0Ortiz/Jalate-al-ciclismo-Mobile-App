import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Exception, HomeData>> getHomeData() async {
    try {
      final remoteData = await remoteDataSource.getHomeData();
      return Right(remoteData);
    } catch (e) {
      return Left(Exception('Error al obtener datos del home: $e'));
    }
  }
}
