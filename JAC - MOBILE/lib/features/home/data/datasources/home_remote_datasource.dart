import 'package:injectable/injectable.dart';

import '../models/home_data_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataModel> getHomeData();
}

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<HomeDataModel> getHomeData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data - In a real app, this would come from an API client (Dio)
    return const HomeDataModel(
      userName: 'Usuario',
      welcomeMessage: 'Listo para rodar hoy',
      suggestedRoutesModel: [
        HomeRouteModel(
          id: '1',
          name: 'Circuito Tuxtla - Terreno Mixto',
          distance: '60.5 km',
          elevation: '850 m',
          terrainPercent: '60% Terracería',
          aiWarning: 'Descenso técnico',
          imageUrl:
              'https://images.unsplash.com/photo-1600403477955-2b8c2cfab221?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1740',
        ),
        HomeRouteModel(
          id: '2',
          name: 'Ruta Panorámica del Cañón',
          distance: '45.2 km',
          elevation: '620 m',
          terrainPercent: '100% Pavimento',
          aiWarning: 'Tráfico moderado',
          imageUrl:
              'https://images.unsplash.com/photo-1516147697747-02adcafd3fda?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1844',
        ),
      ],
    );
  }
}
