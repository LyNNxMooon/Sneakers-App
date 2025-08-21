
import 'package:json_annotation/json_annotation.dart';
part 'error_response_for_fetching_sneakers.g.dart';

@JsonSerializable()
class ErrorResponseForFetchingSneakers {
  final String message;

  ErrorResponseForFetchingSneakers({required this.message});

  factory ErrorResponseForFetchingSneakers.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseForFetchingSneakersFromJson(json);
}