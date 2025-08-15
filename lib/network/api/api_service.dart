import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:sneakers_app/features/home_products/data/response/sneakers_response.dart';
import 'package:sneakers_app/network/api/api_constants.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio) => _ApiService(dio);

  @GET(kEndPointForSneakers)
  @Headers(<String, dynamic>{
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  })
  Future<SneakersResponse> fetchSneakers(
      @Header(kAuthorizationKey) String token,
      @Query(kQueryParamKeyForProductType) String productType,
      @Query(kQueryParamKeyForCategory) String category,
      @Query(kQueryParamKeyForPage) int page,
      @Query(kQueryParamKeyForLimit) int limit);
}
