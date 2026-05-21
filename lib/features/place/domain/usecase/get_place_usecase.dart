

import 'package:place_finder_app/core/data_sources/data_state.dart';
import 'package:place_finder_app/core/data_sources/usecase.dart';
import 'package:place_finder_app/features/place/data/repository/place_repository.dart';
import 'package:place_finder_app/features/place/domain/entity/place_entity.dart';

class GetPalaceeUsecase implements Usecase<DataState<List<TodoEntity>>,void>{
  final PlaceRepository repository;
  GetPalaceeUsecase(this.repository);
  @override
  Future<DataState<List<TodoEntity>>> call({void params})async {
  return await repository.getPalace();
  }

}