import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../local_db/hive_constants.dart';
part 'sneaker_vo.g.dart';

@HiveType(typeId: kHiveTypeIdForSneaker)
@JsonSerializable()
class SneakerVO {
  @HiveField(0)
  final String id;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String brand;
  @HiveField(4)
  final String model;
  @HiveField(5)
  final String gender;
  @HiveField(6)
  final String description;
  @HiveField(7)
  final String image;
  @HiveField(8)
  final String sku;
  @HiveField(9)
  final String category;
  @HiveField(10)
  @JsonKey(name: 'secondary_category')
  final String secondaryCategory;
  @HiveField(11)
  @JsonKey(name: 'product_type')
  final String productType;

  SneakerVO({
    required this.id,
    required this.title,
    required this.brand,
    required this.model,
    required this.gender,
    required this.description,
    required this.image,
    required this.sku,
    required this.category,
    required this.secondaryCategory,
    required this.productType,
  });

  factory SneakerVO.fromJson(Map<String, dynamic> json) =>
      _$SneakerVOFromJson(json);
}
