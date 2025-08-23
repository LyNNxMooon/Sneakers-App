// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sneakers_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SneakersResponseAdapter extends TypeAdapter<SneakersResponse> {
  @override
  final int typeId = 4;

  @override
  SneakersResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SneakersResponse(
      data: (fields[0] as List).cast<SneakerVO>(),
      meta: fields[1] as MetaResponse,
    );
  }

  @override
  void write(BinaryWriter writer, SneakersResponse obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.meta);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SneakersResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SneakersResponse _$SneakersResponseFromJson(Map<String, dynamic> json) =>
    SneakersResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => SneakerVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: MetaResponse.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SneakersResponseToJson(SneakersResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };
