abstract class HomeSneakersEvent {}

class FetchHomeSneakers extends HomeSneakersEvent {
  final int page;

  FetchHomeSneakers({
    required this.page,
  });
}

class SearchHomeSneakers extends HomeSneakersEvent {
  final String title;
  final String model;
  final String sku;

  SearchHomeSneakers(
      {required this.title, required this.model, required this.sku});
}
