import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sneakers_app/features/home_products/data/response/sneakers_response.dart';
import 'package:sneakers_app/network/api/api_service.dart';
import 'package:sneakers_app/network/data_agent/data_agent.dart';

import '../../features/home_products/data/response/error_response_for_fetching_sneakers.dart';
import '../../utils/log_util.dart';

class DataAgentImpl implements DataAgent {
  late ApiService _apiService;

  DataAgentImpl._() {
    _apiService = ApiService(Dio());
  }

  static final DataAgentImpl _instance = DataAgentImpl._();

  static DataAgentImpl get instance => _instance;

  @override
  Future<SneakersResponse> fetchSneakers(
      String token, String productType, String category, int page, int limit) async {
    try {
      return await _apiService
          .fetchSneakers('Bearer $token', productType, category, page, limit)
          .asStream()
          .map((event) => event)
          .first;
    } on Exception catch (error) {
      logger.e('Error fetching sneakers from network: $error');
      return Future.error(throwExceptionForFetchingSneakers(error));
    }
  }

  //Error config for fetching sneakers
  Object throwExceptionForFetchingSneakers(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return "Unable to connect to the server. Please check your internet connection and try again.";
      }
      if (error.response?.data is Map<String, dynamic>) {
        try {
          final errorResponse = ErrorResponseForFetchingSneakers.fromJson(
              jsonDecode(error.response.toString()));
          return errorResponse.message;
        } catch (error) {
          return error.toString();
        }
      }
      return error.response.toString();
    }
    return error.toString();
  }
}
