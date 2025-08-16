import 'package:bloc/bloc.dart';
import 'package:sneakers_app/features/home_products/presentation/BLoC/home_sneakers_event.dart';
import 'package:sneakers_app/features/home_products/presentation/BLoC/home_sneakers_state.dart';

import '../../domain/use_cases/fetch_and_display_sneakers.dart';
import '../../domain/use_cases/search_sneakers.dart';

class HomeSneakersBloc extends Bloc<HomeSneakersEvent, HomeSneakersState> {
  final FetchAndDisplaySneakers fetchAndDisplaySneakers;
  final SearchHomePageSneakers searchHomeSneakers;

  HomeSneakersBloc(
      {required this.fetchAndDisplaySneakers, required this.searchHomeSneakers})
      : super(HomeSneakersInitial()) {
    on<FetchHomeSneakers>(_onFetchHomeSneakers);
    on<SearchHomeSneakers>(_onSearchHomeSneakers);
  }

  Future<void> _onFetchHomeSneakers(
      FetchHomeSneakers event, Emitter<HomeSneakersState> emit) async {
    emit(HomeSneakersLoading(
        await fetchAndDisplaySneakers.getCachedSneakersWhileLoading()));

    try {
      final sneakersResponse = await fetchAndDisplaySneakers(
        event.page,
      );

      emit(HomeSneakersLoaded(sneakersResponse));
    } catch (error) {
      emit(HomeSneakersError('$error'));
    }
  }

  Future<void> _onSearchHomeSneakers(
      SearchHomeSneakers event, Emitter<HomeSneakersState> emit) async {
    emit(HomeSneakersLoading(
        await fetchAndDisplaySneakers.getCachedSneakersWhileLoading()));

    try {
      final sneakersResponse =
          await searchHomeSneakers(event.title, event.model, event.sku);

      emit(HomeSneakersLoaded(sneakersResponse));
    } catch (error) {
      emit(HomeSneakersError('$error'));
    }
  }
}
