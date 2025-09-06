import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../local_db/hive_constants.dart';
part 'shipping_item_vo.g.dart';

@HiveType(typeId: kHiveTypeIdForShippingItem)
@JsonSerializable()
class ShippingItemVO {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String model;
  @HiveField(3)
  final String image;
  @HiveField(4)
  final String sku;
  @HiveField(5)
  final int qty;
  @HiveField(6)
  @JsonKey(name: 'package_type')
  final String packageType;
  @HiveField(7)
  @JsonKey(name: 'shipping_type')
  final String shippingType;

  ShippingItemVO(
      {required this.id,
      required this.title,
      required this.model,
      required this.image,
      required this.sku,
      required this.qty,
      required this.packageType,
      required this.shippingType});

  factory ShippingItemVO.fromJson(Map<String, dynamic> json) =>
      _$ShippingItemVOFromJson(json);
}
