import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sneakers_app/features/search/presentation/BLoC/search_sneakers_event.dart';
import 'package:sneakers_app/features/search/presentation/BLoC/search_sneakers_state.dart';

import '../../domain/use_cases/fetch_sneakers.dart';
import '../../domain/use_cases/search_sneakers.dart';

class SearchSneakersBloc
    extends Bloc<SearchSneakersEvent, SearchSneakersState> {
  final FetchSneakers fetchSneakers;
  final SearchSneakers searchSneakers;

  SearchSneakersBloc(
      {required this.fetchSneakers, required this.searchSneakers})
      : super(SearchSneakersInitial()) {
    on<FetchSneakersEvent>(_onFetchSneakers);
    on<SearchEvent>(_onSearchSneakers);
  }

  Future<void> _onFetchSneakers(
      FetchSneakersEvent event, Emitter<SearchSneakersState> emit) async {
    emit(SearchSneakersLoading(
        await fetchSneakers.getCachedSearchedSneakersWhileLoading()));

    try {
      final sneakersResponse = await fetchSneakers(
        event.page,
      );

      emit(SearchSneakersLoaded(sneakersResponse));
    } catch (error) {
      emit(SearchSneakersError('$error'));
    }
  }

  Future<void> _onSearchSneakers(
      SearchEvent event, Emitter<SearchSneakersState> emit) async {
    emit(SearchSneakersLoading(
        await fetchSneakers.getCachedSearchedSneakersWhileLoading()));

    try {
      final sneakersResponse = await searchSneakers(
          event.title, event.model, event.sku, event.secCategory);

      emit(SearchSneakersLoaded(sneakersResponse));
    } catch (error) {
      emit(SearchSneakersError('$error'));
    }
  }
}
