import 'package:json_annotation/json_annotation.dart';

part 'data_door_entity.g.dart';

@JsonSerializable()
class DataDoorEntity {
  double enter;
  double leave;
  double alert;

  DataDoorEntity(this.enter, this.leave, this.alert);

  factory DataDoorEntity.fromJson(Map<String, dynamic> json) =>
      _$DataDoorEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataDoorEntityToJson(this);
}
