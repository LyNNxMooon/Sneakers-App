import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import '../../local_db/hive_constants.dart';
part 'cart_item_vo.g.dart';

@HiveType(typeId: kHiveTypeIdForCartItem)
@JsonSerializable()
class CartItemVO {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String brand;
  @HiveField(3)
  final String model;
  @HiveField(4)
  final String gender;
  @HiveField(5)
  final String image;
  @HiveField(6)
  final String sku;
  @HiveField(7)
  @JsonKey(name: 'secondary_category')
  String? secondaryCategory;
  @HiveField(8)
  final int qty;
  @HiveField(9)
  final bool package;
  @HiveField(10)
  final bool shipping;

  CartItemVO(
      {required this.id,
      required this.title,
      required this.brand,
      required this.model,
      required this.gender,
      required this.image,
      required this.sku,
      required this.secondaryCategory,
      required this.qty,
      required this.package,
      required this.shipping});

  factory CartItemVO.fromJson(Map<String, dynamic> json) =>
      _$CartItemVOFromJson(json);
}
