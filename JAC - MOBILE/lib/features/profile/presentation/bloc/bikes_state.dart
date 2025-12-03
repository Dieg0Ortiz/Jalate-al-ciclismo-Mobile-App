import 'package:equatable/equatable.dart';
import '../../domain/entities/bike.dart';

abstract class BikesState extends Equatable {
  const BikesState();

  @override
  List<Object> get props => [];
}

class BikesInitial extends BikesState {}

class BikesLoading extends BikesState {}

class BikesLoaded extends BikesState {
  final List<Bike> bikes;

  const BikesLoaded(this.bikes);

  @override
  List<Object> get props => [bikes];
}

class BikesError extends BikesState {
  final String message;

  const BikesError(this.message);

  @override
  List<Object> get props => [message];
}
