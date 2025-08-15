abstract class HomeSneakersEvent {}

class FetchHomeSneakers extends HomeSneakersEvent {
  final int page;
  bool isSearching;
  String title;
  String model;
  String sku;

  FetchHomeSneakers(
      {required this.page,
      this.isSearching = false,
      this.title = "",
      this.model = "",
      this.sku = ""});
}
