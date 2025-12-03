import 'package:flutter/material.dart';

class Bike {
  final String id;
  final String name;
  final String brand;
  final Color color;
  final String type;

  Bike({
    required this.id,
    required this.name,
    required this.brand,
    required this.color,
    this.type = 'Bicicleta',
  });
}
