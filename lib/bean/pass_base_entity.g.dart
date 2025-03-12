// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pass_base_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PassBaseEntity _$PassBaseEntityFromJson(Map<String, dynamic> json) =>
    PassBaseEntity(
      json['id'] as String,
      json['ip'] as String,
      json['name'] as String,
      json['arrow'] as bool,
      json['eas'] as bool,
      json['afi'] as bool,
      json['afiText'] as String,
      json['state'] as bool,
    );

Map<String, dynamic> _$PassBaseEntityToJson(PassBaseEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ip': instance.ip,
      'name': instance.name,
      'arrow': instance.arrow,
      'eas': instance.eas,
      'afi': instance.afi,
      'afiText': instance.afiText,
      'state': instance.state,
    };
