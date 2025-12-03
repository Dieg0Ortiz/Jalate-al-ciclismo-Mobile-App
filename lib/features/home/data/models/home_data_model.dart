import 'package:json_annotation/json_annotation.dart';
import '../../../auth/data/models/user_model.dart';

import '../../domain/entities/home_data.dart';

part 'home_data_model.g.dart';

@JsonSerializable()
class HomeDataModel extends HomeData {
  @override
  final UserModel user;

  const HomeDataModel({
    required this.user,
    required super.welcomeMessage,
    required super.suggestedRoutes,
  }) : super(user: user);

  factory HomeDataModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataModelToJson(this);
}
