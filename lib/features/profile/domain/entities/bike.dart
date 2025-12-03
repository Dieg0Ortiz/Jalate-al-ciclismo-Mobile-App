import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum BikeType { mountain, road, urban, gravel, electric, other }

class Bike extends Equatable {
  final String id;
  final String name;
  final String brand;
  final BikeType type;
  final Color color;
  final double? weight;
  final String? notes;

  const Bike({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.color,
    this.weight,
    this.notes,
  });

  @override
  List<Object?> get props => [id, name, brand, type, color, weight, notes];

  String get typeName {
    switch (type) {
      case BikeType.mountain:
        return 'Montaña';
      case BikeType.road:
        return 'Ruta';
      case BikeType.urban:
        return 'Urbana';
      case BikeType.gravel:
        return 'Gravel';
      case BikeType.electric:
        return 'Eléctrica';
      case BikeType.other:
        return 'Otra';
    }
  }
}
