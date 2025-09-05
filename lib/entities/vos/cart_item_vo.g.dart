// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemVOAdapter extends TypeAdapter<CartItemVO> {
  @override
  final int typeId = 5;

  @override
  CartItemVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemVO(
      id: fields[0] as String,
      title: fields[1] as String,
      brand: fields[2] as String,
      model: fields[3] as String,
      gender: fields[4] as String,
      image: fields[5] as String,
      sku: fields[6] as String,
      secondaryCategory: fields[7] as String?,
      qty: fields[8] as int,
      package: fields[9] as bool,
      shipping: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemVO obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.model)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.sku)
      ..writeByte(7)
      ..write(obj.secondaryCategory)
      ..writeByte(8)
      ..write(obj.qty)
      ..writeByte(9)
      ..write(obj.package)
      ..writeByte(10)
      ..write(obj.shipping);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemVO _$CartItemVOFromJson(Map<String, dynamic> json) => CartItemVO(
      id: json['id'] as String,
      title: json['title'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      gender: json['gender'] as String,
      image: json['image'] as String,
      sku: json['sku'] as String,
      secondaryCategory: json['secondary_category'] as String?,
      qty: (json['qty'] as num).toInt(),
      package: json['package'] as bool,
      shipping: json['shipping'] as bool,
    );

Map<String, dynamic> _$CartItemVOToJson(CartItemVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'brand': instance.brand,
      'model': instance.model,
      'gender': instance.gender,
      'image': instance.image,
      'sku': instance.sku,
      'secondary_category': instance.secondaryCategory,
      'qty': instance.qty,
      'package': instance.package,
      'shipping': instance.shipping,
    };
