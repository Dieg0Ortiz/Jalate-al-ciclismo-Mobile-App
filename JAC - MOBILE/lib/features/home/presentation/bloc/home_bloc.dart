import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/usecases/get_home_data.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeData getHomeData;

  HomeBloc(this.getHomeData) : super(HomeInitial()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefresh>(_onRefresh);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await getHomeData(NoParams());
    result.fold(
      (failure) =>
          emit(HomeError(failure.message ?? 'An unexpected error occurred')),
      (data) => emit(HomeLoaded(data)),
    );
  }

  Future<void> _onRefresh(HomeRefresh event, Emitter<HomeState> emit) async {
    final result = await getHomeData(NoParams());
    result.fold(
      (failure) =>
          emit(HomeError(failure.message ?? 'An unexpected error occurred')),
      (data) => emit(HomeLoaded(data)),
    );
  }
}
