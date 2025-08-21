abstract class SearchSneakersEvent {}

class FetchSneakersEvent extends SearchSneakersEvent {
  final int page;

  FetchSneakersEvent({required this.page});
}

class SearchEvent extends SearchSneakersEvent {
  final String title;
  final String model;
  final String sku;
  final String secCategory;

  SearchEvent(
      {required this.title,
      required this.model,
      required this.sku,
      required this.secCategory});
}
