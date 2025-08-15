import 'package:bloc/bloc.dart';
import 'package:sneakers_app/features/home_products/presentation/BLoC/home_sneakers_event.dart';
import 'package:sneakers_app/features/home_products/presentation/BLoC/home_sneakers_state.dart';

import '../../domain/use_cases/fetch_and_display_sneakers.dart';

class HomeSneakersBloc extends Bloc<HomeSneakersEvent, HomeSneakersState> {
  final FetchAndDisplaySneakers fetchAndDisplaySneakers;

  HomeSneakersBloc({required this.fetchAndDisplaySneakers})
      : super(HomeSneakersInitial()) {
    on<FetchHomeSneakers>(_onFetchHomeSneakers);
  }


  Future<void> _onFetchHomeSneakers(
      FetchHomeSneakers event, Emitter<HomeSneakersState> emit) async {
    emit(HomeSneakersLoading(
        await fetchAndDisplaySneakers.getCachedSneakersWhileLoading()));

    try {
      final sneakersResponse = await fetchAndDisplaySneakers(event.page,
          isSearching: event.isSearching,
          model: event.model,
          sku: event.sku,
          title: event.title);

      emit(HomeSneakersLoaded(sneakersResponse));
    } catch (error) {
      emit(HomeSneakersError('$error'));
    }
  }
}
