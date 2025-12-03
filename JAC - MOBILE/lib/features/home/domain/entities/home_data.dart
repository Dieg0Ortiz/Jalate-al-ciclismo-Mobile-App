import 'package:equatable/equatable.dart';

class HomeData extends Equatable {
  final String userName;
  final String welcomeMessage;
  final List<HomeRoute> suggestedRoutes;
  // Add other fields as needed for the home screen

  const HomeData({
    required this.userName,
    required this.welcomeMessage,
    required this.suggestedRoutes,
  });

  @override
  List<Object?> get props => [userName, welcomeMessage, suggestedRoutes];
}

class HomeRoute extends Equatable {
  final String id;
  final String name;
  final String distance;
  final String elevation;
  final String terrainPercent;
  final String? aiWarning;
  final String imageUrl;

  const HomeRoute({
    required this.id,
    required this.name,
    required this.distance,
    required this.elevation,
    required this.terrainPercent,
    this.aiWarning,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, distance, elevation, terrainPercent, aiWarning, imageUrl];
}
