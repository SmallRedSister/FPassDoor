// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingEntity _$SettingEntityFromJson(Map<String, dynamic> json) =>
    SettingEntity(
      json['apiAddr'] as String?,
      json['title'] as String?,
      json['deviceId'] as String?,
    );

Map<String, dynamic> _$SettingEntityToJson(SettingEntity instance) =>
    <String, dynamic>{
      'apiAddr': instance.apiAddr,
      'title': instance.title,
      'deviceId': instance.deviceId,
    };
