// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_data_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDataEntity _$DeviceDataEntityFromJson(Map<String, dynamic> json) =>
    DeviceDataEntity(
      json['boxId'] as String,
      json['ipAdder'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$DeviceDataEntityToJson(DeviceDataEntity instance) =>
    <String, dynamic>{
      'boxId': instance.boxId,
      'ipAdder': instance.ipAdder,
      'name': instance.name,
    };
