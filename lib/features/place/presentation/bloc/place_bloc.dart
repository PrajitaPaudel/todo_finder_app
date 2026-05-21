import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:place_finder_app/core/data_sources/data_state.dart';
import 'package:place_finder_app/features/place/domain/entity/place_entity.dart';
import 'package:place_finder_app/features/place/presentation/bloc/place_event.dart';
import 'package:place_finder_app/features/place/presentation/bloc/place_state.dart';

import '../../domain/usecase/get_place_usecase.dart';



class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final GetPalaceeUsecase palaceUsecase;

  PlaceBloc(this.palaceUsecase) : super(PlaceInitial()) {
    on<GetPlaceEvent>(_onGetPlaceEvent);
  }

  Future<void> _onGetPlaceEvent(
      GetPlaceEvent event,
      Emitter<PlaceState> emit,
      ) async {
    emit(PlaceLoadingState());

    final data = await palaceUsecase();

    if (data is DataSuccess<List<TodoEntity>>) {
      emit(PlaceLoadedState(data.data ?? []));
    }
    else if (data is DataFailure) {
      emit(PaceLoadedErrorState(data.error??""));
    }
  }
}
