

import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';

import 'package:place_finder_app/features/place/data/repository/place_repository.dart';


import 'features/place/data/service/place_service.dart';
import 'features/place/domain/usecase/get_place_usecase.dart';
import 'features/place/presentation/bloc/place_bloc.dart';



final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerLazySingleton<Dio>(
        () => Dio(),
  );


  sl.registerFactory<PalaceService>(
        () => PalaceService(sl(),),
  );
  sl.registerFactory<PlaceRepository>(
        () => PlaceRepository(sl(),),
  );

  sl.registerFactory<GetPalaceeUsecase>(
        () => GetPalaceeUsecase(sl(),),
  );
  sl.registerFactory<PlaceBloc>(
        () => PlaceBloc(sl(),),
  );





}
