import 'package:json_annotation/json_annotation.dart';

part 'mercariHunter.g.dart';

@JsonSerializable()
class MercariHunter {
  MercariHunter();

  late String hunterInstanceId;
  late String? lastShotAt;
  late String freezingStart;
  late String freezingEnd;
  late String schedule;
  late String url;
  late String createdAt;
  late String updatedAt;
  
  factory MercariHunter.fromJson(Map<String,dynamic> json) => _$MercariHunterFromJson(json);
  Map<String, dynamic> toJson() => _$MercariHunterToJson(this);
}
