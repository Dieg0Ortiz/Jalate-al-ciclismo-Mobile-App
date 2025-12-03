import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/bike.dart';

// Events
abstract class BikesEvent extends Equatable {
  const BikesEvent();

  @override
  List<Object> get props => [];
}

class LoadBikes extends BikesEvent {}

class AddBike extends BikesEvent {
  final Bike bike;

  const AddBike(this.bike);

  @override
  List<Object> get props => [bike];
}

class DeleteBike extends BikesEvent {
  final String bikeId;

  const DeleteBike(this.bikeId);

  @override
  List<Object> get props => [bikeId];
}

// State
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

// Bloc
@injectable
class BikesBloc extends Bloc<BikesEvent, BikesState> {
  BikesBloc() : super(BikesInitial()) {
    on<LoadBikes>(_onLoadBikes);
    on<AddBike>(_onAddBike);
    on<DeleteBike>(_onDeleteBike);
  }

  final List<Bike> _bikes = []; // In-memory storage for now

  void _onLoadBikes(LoadBikes event, Emitter<BikesState> emit) async {
    emit(BikesLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate API delay
    emit(BikesLoaded(List.from(_bikes)));
  }

  void _onAddBike(AddBike event, Emitter<BikesState> emit) async {
    emit(BikesLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    _bikes.add(event.bike);
    emit(BikesLoaded(List.from(_bikes)));
  }

  void _onDeleteBike(DeleteBike event, Emitter<BikesState> emit) async {
    emit(BikesLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    _bikes.removeWhere((bike) => bike.id == event.bikeId);
    emit(BikesLoaded(List.from(_bikes)));
  }
}
