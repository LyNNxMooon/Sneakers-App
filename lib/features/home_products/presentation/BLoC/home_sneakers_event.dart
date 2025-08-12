abstract class HomeSneakersEvent {}

class FetchHomeSneakers extends HomeSneakersEvent {
  final int page;

  FetchHomeSneakers({required this.page});
}
