// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_item_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShippingItemVOAdapter extends TypeAdapter<ShippingItemVO> {
  @override
  final int typeId = 7;

  @override
  ShippingItemVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShippingItemVO(
      id: fields[0] as String,
      title: fields[1] as String,
      model: fields[2] as String,
      image: fields[3] as String,
      sku: fields[4] as String,
      qty: fields[5] as int,
      packageType: fields[6] as String,
      shippingType: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShippingItemVO obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.sku)
      ..writeByte(5)
      ..write(obj.qty)
      ..writeByte(6)
      ..write(obj.packageType)
      ..writeByte(7)
      ..write(obj.shippingType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShippingItemVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingItemVO _$ShippingItemVOFromJson(Map<String, dynamic> json) =>
    ShippingItemVO(
      id: json['id'] as String,
      title: json['title'] as String,
      model: json['model'] as String,
      image: json['image'] as String,
      sku: json['sku'] as String,
      qty: (json['qty'] as num).toInt(),
      packageType: json['package_type'] as String,
      shippingType: json['shipping_type'] as String,
    );

Map<String, dynamic> _$ShippingItemVOToJson(ShippingItemVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'model': instance.model,
      'image': instance.image,
      'sku': instance.sku,
      'qty': instance.qty,
      'package_type': instance.packageType,
      'shipping_type': instance.shippingType,
    };
