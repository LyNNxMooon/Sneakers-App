import 'package:sneakers_app/features/home_products/data/response/sneakers_response.dart';
import 'package:sneakers_app/features/home_products/domain/repositories/home_products_repo.dart';

import '../../../../network/data_agent/data_agent_impl.dart';

class FetchingSneakersModel implements HomeProductsRepo {
  //Data manipulation can be done here (E.g. substituting data for null values returned from API)

  @override
  Future<SneakersResponse> fetchSneakers(
      String token, String productType, String category, int page) async {
    try {
      return await DataAgentImpl.instance
          .fetchSneakers(token, productType, category, page);
    } on Exception catch (error) {
      return Future.error(error);
    }
  }
}
