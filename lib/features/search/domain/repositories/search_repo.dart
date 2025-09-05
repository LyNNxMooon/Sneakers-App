import 'package:sneakers_app/entities/response/sneakers_response.dart';

abstract class SearchRepo {
  Future<SneakersResponse> fetchToSearchSneakers(
      String token, String productType, String category, int page, int limit);
}
