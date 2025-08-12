import 'package:sneakers_app/features/home_products/data/response/sneakers_response.dart';

abstract class HomeProductsRepo {
  Future<SneakersResponse> fetchSneakers(
      String token, String productType, String category, int page);
}
