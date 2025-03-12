import 'package:json_annotation/json_annotation.dart';

part 'pass_base_entity.g.dart';

@JsonSerializable()
class PassBaseEntity {
  String id;
  String ip;
  String name;
  bool arrow;
  bool eas;
  bool afi;
  String afiText;
  bool state;

  PassBaseEntity(this.id, this.ip, this.name, this.arrow, this.eas, this.afi,
      this.afiText, this.state);

  factory PassBaseEntity.fromJson(Map<String, dynamic> json) =>
      _$PassBaseEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PassBaseEntityToJson(this);
}
