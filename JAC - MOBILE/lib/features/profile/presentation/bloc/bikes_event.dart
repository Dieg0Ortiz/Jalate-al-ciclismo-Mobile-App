import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BikesEvent extends Equatable {
  const BikesEvent();

  @override
  List<Object> get props => [];
}

class LoadBikes extends BikesEvent {}

class AddBike extends BikesEvent {
  final String name;
  final String brand;
  final Color color;
  final String type;

  const AddBike({
    required this.name,
    required this.brand,
    required this.color,
    required this.type,
  });

  @override
  List<Object> get props => [name, brand, color, type];
}
