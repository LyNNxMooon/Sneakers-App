import '../../../../entities/response/sneakers_response.dart';

abstract class SearchSneakersState {}

class SearchSneakersInitial extends SearchSneakersState {}

class SearchSneakersLoading extends SearchSneakersState {
  final SneakersResponse? sneakers;

  SearchSneakersLoading(this.sneakers);
}

class SearchSneakersLoaded extends SearchSneakersState {
  final SneakersResponse sneakers;

  SearchSneakersLoaded(this.sneakers);
}

class SearchSneakersError extends SearchSneakersState {
  final String errorMessage;

  SearchSneakersError(this.errorMessage);
}