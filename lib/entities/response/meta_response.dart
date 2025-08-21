import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../local_db/hive_constants.dart';
part '../../entities/response/meta_response.g.dart';

@HiveType(typeId: kHiveTypeIdForMetaData)
@JsonSerializable()
class MetaResponse {
  @HiveField(0)
  @JsonKey(name: 'current_page')
  final int currentPage;
  @HiveField(1)
  @JsonKey(name: 'per_page')
  final int perPage;
  @HiveField(2)
  final int total;

  MetaResponse(
      {required this.currentPage, required this.perPage, required this.total});

  factory MetaResponse.fromJson(Map<String, dynamic> json) =>
      _$MetaResponseFromJson(json);
}
