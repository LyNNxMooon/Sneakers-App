import 'package:sneakers_app/entities/response/sneakers_response.dart';
import 'package:sneakers_app/features/search/domain/repositories/search_repo.dart';

import '../../../network/data_agent/data_agent_impl.dart';

class FetchingAndSearchingSneakersModel implements SearchRepo {
  //Data manipulation can be done here (E.g. substituting data for null values returned from API)

  @override
  Future<SneakersResponse> fetchAndSearchSneakers(String token, String productType,
      String category, int page, int limit) async {
    try {
      return await DataAgentImpl.instance
          .fetchSneakers(token, productType, category, page, limit);
    } on Exception catch (error) {
      return Future.error(error);
    }
  }
}
