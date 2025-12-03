import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/home_data.dart';

part 'home_data_model.g.dart';

@JsonSerializable()
class HomeDataModel extends HomeData {
  @JsonKey(name: 'suggestedRoutes')
  final List<HomeRouteModel> suggestedRoutesModel;

  const HomeDataModel({
    required super.userName,
    required super.welcomeMessage,
    required this.suggestedRoutesModel,
  }) : super(suggestedRoutes: suggestedRoutesModel);

  factory HomeDataModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataModelToJson(this);
}

@JsonSerializable()
class HomeRouteModel extends HomeRoute {
  const HomeRouteModel({
    required super.id,
    required super.name,
    required super.distance,
    required super.elevation,
    required super.terrainPercent,
    super.aiWarning,
    required super.imageUrl,
  });

  factory HomeRouteModel.fromJson(Map<String, dynamic> json) =>
      _$HomeRouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeRouteModelToJson(this);
}
