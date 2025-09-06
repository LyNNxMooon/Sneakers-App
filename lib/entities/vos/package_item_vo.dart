import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../local_db/hive_constants.dart';
part 'package_item_vo.g.dart';

@HiveType(typeId: kHiveTypeIdForPackageItem)
@JsonSerializable()
class PackageItemVO {
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

  PackageItemVO(
      {required this.id,
      required this.title,
      required this.model,
      required this.image,
      required this.sku,
      required this.qty,
      required this.packageType});

  factory PackageItemVO.fromJson(Map<String, dynamic> json) =>
      _$PackageItemVOFromJson(json);
}
