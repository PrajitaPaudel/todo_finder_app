
import 'package:place_finder_app/core/data_sources/data_state.dart';
import 'package:place_finder_app/features/place/domain/entity/place_entity.dart';

import '../service/place_service.dart';

class PlaceRepository {
  final PalaceService service;
  PlaceRepository(this.service);

  Future<DataState<List<TodoEntity>>> getPalace()async{
    try{
      final model =await service.getPlaace();
      final entity= model.map((e)=>e.toEntity()).toList();
      return DataSuccess(entity);


    }catch(e){
      return DataFailure(e.toString());

    }
  }

}