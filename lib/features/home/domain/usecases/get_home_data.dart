import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/home_data.dart';
import '../repositories/home_repository.dart';

@injectable
class GetHomeData {
  final HomeRepository repository;

  GetHomeData(this.repository);

  Future<Either<Exception, HomeData>> call() async {
    return await repository.getHomeData();
  }
}
