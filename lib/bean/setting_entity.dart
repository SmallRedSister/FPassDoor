import 'package:json_annotation/json_annotation.dart';

part 'setting_entity.g.dart';

@JsonSerializable()
class SettingEntity {
  @JsonKey(name: 'apiAddr')
  String? apiAddr;
  String? title;
  String? deviceId;

  SettingEntity(this.apiAddr, this.title, this.deviceId);

  factory SettingEntity.fromJson(Map<String, dynamic> json) =>
      _$SettingEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SettingEntityToJson(this);

}
