import 'package:get_it/get_it.dart';
import 'package:sneakers_app/features/home_products/domain/repositories/home_products_repo.dart';
import 'package:sneakers_app/local_db/hive_dao.dart';

import '../features/home_products/data/models/fetching_sneakers_model.dart';
import '../features/home_products/domain/use_cases/fetch_and_display_sneakers.dart';
import '../features/home_products/presentation/BLoC/home_sneakers_bloc.dart';
import '../features/home_products/presentation/BLoC/home_sneakers_event.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Registering dependencies

  //Blocs
  sl.registerFactory(() => HomeSneakersBloc(fetchAndDisplaySneakers: sl()));

  //Repos
  sl.registerLazySingleton<HomeProductsRepo>(() => FetchingSneakersModel());

  //Use cases
  sl.registerLazySingleton(() => FetchAndDisplaySneakers(sl()));
  sl.registerLazySingleton(() => HomeSneakerSearchService(sl()));
}
