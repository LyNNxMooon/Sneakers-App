// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sneaker_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SneakerVOAdapter extends TypeAdapter<SneakerVO> {
  @override
  final int typeId = 1;

  @override
  SneakerVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SneakerVO(
      id: fields[0] as String,
      title: fields[2] as String,
      brand: fields[3] as String,
      model: fields[4] as String,
      gender: fields[5] as String,
      description: fields[6] as String,
      image: fields[7] as String,
      sku: fields[8] as String,
      category: fields[9] as String,
      secondaryCategory: fields[10] as String,
      productType: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SneakerVO obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.brand)
      ..writeByte(4)
      ..write(obj.model)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.image)
      ..writeByte(8)
      ..write(obj.sku)
      ..writeByte(9)
      ..write(obj.category)
      ..writeByte(10)
      ..write(obj.secondaryCategory)
      ..writeByte(11)
      ..write(obj.productType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SneakerVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SneakerVO _$SneakerVOFromJson(Map<String, dynamic> json) => SneakerVO(
      id: json['id'] as String,
      title: json['title'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      gender: json['gender'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      sku: json['sku'] as String,
      category: json['category'] as String,
      secondaryCategory: json['secondary_category'] as String,
      productType: json['product_type'] as String,
    );

Map<String, dynamic> _$SneakerVOToJson(SneakerVO instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'brand': instance.brand,
      'model': instance.model,
      'gender': instance.gender,
      'description': instance.description,
      'image': instance.image,
      'sku': instance.sku,
      'category': instance.category,
      'secondary_category': instance.secondaryCategory,
      'product_type': instance.productType,
    };
