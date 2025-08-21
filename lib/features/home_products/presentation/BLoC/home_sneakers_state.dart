import 'package:sneakers_app/entities/response/sneakers_response.dart';

abstract class HomeSneakersState {}

class HomeSneakersInitial extends HomeSneakersState {}

class HomeSneakersLoading extends HomeSneakersState {
  final SneakersResponse? sneakers;

  HomeSneakersLoading(this.sneakers);
}

class HomeSneakersLoaded extends HomeSneakersState {
  final SneakersResponse sneakers;

  HomeSneakersLoaded(this.sneakers);
}

class HomeSneakersError extends HomeSneakersState {
  final String errorMessage;

  HomeSneakersError(this.errorMessage);
}
