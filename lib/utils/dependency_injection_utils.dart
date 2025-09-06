import 'package:get_it/get_it.dart';
import 'package:sneakers_app/features/cart/domain/repositories/cart_repo.dart';
import 'package:sneakers_app/features/home_products/domain/repositories/home_products_repo.dart';
import 'package:sneakers_app/features/search/domain/repositories/search_repo.dart';
import '../features/cart/models/cart_model.dart';
import '../features/home_products/models/fetching_sneakers_model.dart';
import '../features/home_products/domain/use_cases/fetch_and_display_sneakers.dart';
import '../features/home_products/domain/use_cases/search_sneakers.dart';
import '../features/home_products/presentation/BLoC/home_sneakers_bloc.dart';
import '../features/search/domain/use_cases/fetch_sneakers.dart';
import '../features/search/domain/use_cases/search_sneakers.dart';
import '../features/search/models/fetching_and_searching_sneakers_model.dart';
import '../features/search/presentation/BLoC/search_sneakers_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Registering dependencies

  //Blocs
  sl.registerFactory(() => HomeSneakersBloc(
      fetchAndDisplaySneakers: sl(), searchHomeSneakers: sl()));
  sl.registerFactory(
      () => SearchSneakersBloc(fetchSneakers: sl(), searchSneakers: sl()));

  //Repos
  sl.registerLazySingleton<HomeProductsRepo>(() => FetchingSneakersModel());
  sl.registerLazySingleton<SearchRepo>(
      () => FetchingAndSearchingSneakersModel());
  sl.registerLazySingleton<CartRepo>(() => CartModel());

  //Use cases
  sl.registerLazySingleton(() => FetchAndDisplaySneakers(sl()));
  sl.registerLazySingleton(() => SearchHomePageSneakers());
  sl.registerLazySingleton(() => FetchSneakers(sl()));
  sl.registerLazySingleton(() => SearchSneakers());
}
