import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/bike.dart';
import 'bikes_event.dart';
import 'bikes_state.dart';

class BikesBloc extends Bloc<BikesEvent, BikesState> {
  final List<Bike> _bikes = [];

  BikesBloc() : super(BikesInitial()) {
    on<LoadBikes>(_onLoadBikes);
    on<AddBike>(_onAddBike);
  }

  void _onLoadBikes(LoadBikes event, Emitter<BikesState> emit) {
    emit(BikesLoaded(List.from(_bikes)));
  }

  void _onAddBike(AddBike event, Emitter<BikesState> emit) {
    final newBike = Bike(
      id: const Uuid().v4(),
      name: event.name,
      brand: event.brand,
      color: event.color,
      type: event.type,
    );
    _bikes.add(newBike);
    emit(BikesLoaded(List.from(_bikes)));
  }
}
