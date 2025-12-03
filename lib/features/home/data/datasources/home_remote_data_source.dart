import 'package:injectable/injectable.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/home_data_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataModel> getHomeData();
}

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<HomeDataModel> getHomeData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    return HomeDataModel(
      user: const UserModel(
        id: '1',
        email: 'usuario@example.com',
        name: 'Ciclista',
      ),
      welcomeMessage: '¡Listo para rodar!',
      suggestedRoutes: [
        {
          'id': '1',
          'name': 'Ruta de Montaña',
          'distance': '25km',
          'difficulty': 'Alta',
        },
        {
          'id': '2',
          'name': 'Paseo Urbano',
          'distance': '10km',
          'difficulty': 'Baja',
        },
      ],
    );
  }
}
