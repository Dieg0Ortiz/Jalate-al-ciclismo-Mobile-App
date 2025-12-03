// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeDataModel _$HomeDataModelFromJson(Map<String, dynamic> json) =>
    HomeDataModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      welcomeMessage: json['welcomeMessage'] as String,
      suggestedRoutes: json['suggestedRoutes'] as List<dynamic>,
    );

Map<String, dynamic> _$HomeDataModelToJson(HomeDataModel instance) =>
    <String, dynamic>{
      'welcomeMessage': instance.welcomeMessage,
      'suggestedRoutes': instance.suggestedRoutes,
      'user': instance.user,
    };
