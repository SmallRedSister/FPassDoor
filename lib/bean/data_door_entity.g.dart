// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_door_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataDoorEntity _$DataDoorEntityFromJson(Map<String, dynamic> json) =>
    DataDoorEntity(
      (json['enter'] as num).toDouble(),
      (json['leave'] as num).toDouble(),
      (json['alert'] as num).toDouble(),
    );

Map<String, dynamic> _$DataDoorEntityToJson(DataDoorEntity instance) =>
    <String, dynamic>{
      'enter': instance.enter,
      'leave': instance.leave,
      'alert': instance.alert,
    };
