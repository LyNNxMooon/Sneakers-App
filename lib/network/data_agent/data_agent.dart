

import '../../entities/response/sneakers_response.dart';

abstract class DataAgent {

  Future<SneakersResponse> fetchSneakers(String token, String productType, String category, int page, int limit);
}