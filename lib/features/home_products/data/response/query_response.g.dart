// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QueryResponseAdapter extends TypeAdapter<QueryResponse> {
  @override
  final int typeId = 3;

  @override
  QueryResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QueryResponse(
      category: fields[0] as String,
      page: fields[1] as String?,
      productType: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QueryResponse obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.page)
      ..writeByte(2)
      ..write(obj.productType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryResponse _$QueryResponseFromJson(Map<String, dynamic> json) =>
    QueryResponse(
      category: json['category'] as String,
      page: json['page'] as String?,
      productType: json['product_type'] as String,
    );

Map<String, dynamic> _$QueryResponseToJson(QueryResponse instance) =>
    <String, dynamic>{
      'category': instance.category,
      'page': instance.page,
      'product_type': instance.productType,
    };
