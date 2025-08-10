
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../local_db/hive_constants.dart';
part 'query_response.g.dart';

@HiveType(typeId: kHiveTypeIdForQueryData)
@JsonSerializable()
class QueryResponse {
  @HiveField(0)
  final String category;
  @HiveField(1)
  @JsonKey(name: 'product_type')
  final String productType;

  QueryResponse({required this.category, required this.productType});

  factory QueryResponse.fromJson(Map<String, dynamic> json) =>
      _$QueryResponseFromJson(json);
}