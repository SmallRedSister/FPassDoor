import 'package:json_annotation/json_annotation.dart';

part 'device_data_entity.g.dart';

@JsonSerializable()
class DeviceDataEntity {
  String boxId;
  String ipAdder;
  String name;

  DeviceDataEntity(this.boxId, this.ipAdder, this.name);

  factory DeviceDataEntity.fromJson(Map<String, dynamic> json) =>
      _$DeviceDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDataEntityToJson(this);
}
