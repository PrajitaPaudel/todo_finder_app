import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/place_entity.dart';
import '../../domain/usecase/watch_places_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WatchPlacesUseCase watchPlacesUseCase;
  StreamSubscription<List<PlaceEntity>>? _subscription;

  HomeBloc(this.watchPlacesUseCase) : super(HomeInitial()) {
    on<HomeStarted>(_onStarted);
    on<HomePlacesUpdated>(_onPlacesUpdated);
    on<HomeErrorOccurred>(_onErrorOccurred);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    await _subscription?.cancel();

    try {
      final stream = await watchPlacesUseCase();
      _subscription = stream.listen(
        (places) => add(HomePlacesUpdated(places)),
        onError: (error, stackTrace) {
          addError(error, stackTrace);
          add(HomeErrorOccurred(error.toString()));
        },
      );
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  Future<void> _onPlacesUpdated(
    HomePlacesUpdated event,
    Emitter<HomeState> emit,
  ) async {
    final places = event.places;
    if (places.isEmpty) {
      emit(HomeEmpty());
    } else {
      emit(HomeLoaded(places));
    }
  }

  Future<void> _onErrorOccurred(
    HomeErrorOccurred event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeFailure(event.message));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
