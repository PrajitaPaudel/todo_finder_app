

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:place_finder_app/features/auth/data/repository/auth_repository.g.dart';
import 'package:place_finder_app/features/auth/data/service/logout_services.dart';
import 'package:place_finder_app/features/auth/data/service/register_services.dart';
import 'package:place_finder_app/features/home/data/repository/home_repository.g.dart';
import 'package:place_finder_app/features/home/data/service/home_services.dart';
import 'package:place_finder_app/features/profile/data/repository/profile_repository.g.dart';
import 'package:place_finder_app/features/profile/data/service/profile_services.dart';
import 'package:place_finder_app/features/auth/domain/repository/auth_repository.dart';
import 'package:place_finder_app/features/home/domain/repository/home_repository.dart';
import 'package:place_finder_app/features/profile/domain/repository/profile_repository.dart';
import 'package:place_finder_app/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:place_finder_app/features/auth/domain/usecase/logout_usecase.dart';
import 'package:place_finder_app/features/auth/domain/usecase/register_user_usecase.dart';
import 'package:place_finder_app/features/home/domain/usecase/watch_places_usecase.dart';
import 'package:place_finder_app/features/profile/domain/usecase/update_display_name_usecase.dart';
import 'package:place_finder_app/features/profile/domain/usecase/watch_profile_usecase.dart';
import 'package:place_finder_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:place_finder_app/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:place_finder_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:place_finder_app/features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  sl.registerLazySingleton<FirebaseAuth>(
        () => FirebaseAuth.instance,
  );
  sl.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

  sl.registerLazySingleton<RegisterServices>(
        () => RegisterServices(sl()),
  );
  sl.registerLazySingleton<LogoutServices>(
        () => LogoutServices(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<ProfileServices>(
        () => ProfileServices(sl(), sl()),
  );
  sl.registerLazySingleton<HomeServices>(
        () => HomeServices(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<RegisterUserUseCase>(
        () => RegisterUserUseCase(sl()),
  );
  sl.registerLazySingleton<LoginUserUseCase>(
        () => LoginUserUseCase(sl()),
  );
  sl.registerLazySingleton<WatchPlacesUseCase>(
        () => WatchPlacesUseCase(sl()),
  );
  sl.registerLazySingleton<WatchProfileUseCase>(
        () => WatchProfileUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateDisplayNameUseCase>(
        () => UpdateDisplayNameUseCase(sl()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
        () => LogoutUseCase(sl()),
  );
  sl.registerLazySingleton<RegisterBloc>(
        () => RegisterBloc(sl()),
  );
  sl.registerLazySingleton<LoginBloc>(
        () => LoginBloc(sl()),
  );
  sl.registerFactory<HomeBloc>(
        () => HomeBloc(sl()),
  );
  sl.registerFactory<ProfileBloc>(
        () => ProfileBloc(sl(),sl(),sl()),
  );

}
