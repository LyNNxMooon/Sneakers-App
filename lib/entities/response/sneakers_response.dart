import 'package:json_annotation/json_annotation.dart';
import 'package:sneakers_app/entities/response/meta_response.dart';
import 'package:sneakers_app/entities/response/query_response.dart';
import 'package:sneakers_app/entities/vos/sneaker_vo.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../local_db/hive_constants.dart';
part 'sneakers_response.g.dart';


@HiveType(typeId: kHiveTypeIdForSneakersResponse)
@JsonSerializable()
class SneakersResponse {
  @HiveField(0)
  final String status;
  @HiveField(1)
  final QueryResponse query;
  @HiveField(2)
  final List<SneakerVO> data;
  @HiveField(3)
  final MetaResponse meta;

  SneakersResponse(
      {required this.status,
      required this.query,
      required this.data,
      required this.meta});

  factory SneakersResponse.fromJson(Map<String, dynamic> json) =>
      _$SneakersResponseFromJson(json);
}
