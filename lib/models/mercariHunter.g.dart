// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mercariHunter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MercariHunter _$MercariHunterFromJson(Map<String, dynamic> json) =>
    MercariHunter()
      ..hunterInstanceId = json['hunterInstanceId'] as String
      ..lastShotAt = json['lastShotAt']
      ..freezingStart = json['freezingStart'] as String
      ..freezingEnd = json['freezingEnd'] as String
      ..schedule = json['schedule'] as String
      ..url = json['url'] as String
      ..createdAt = json['createdAt'] as String
      ..updatedAt = json['updatedAt'] as String;

Map<String, dynamic> _$MercariHunterToJson(MercariHunter instance) =>
    <String, dynamic>{
      'hunterInstanceId': instance.hunterInstanceId,
      'lastShotAt': instance.lastShotAt,
      'freezingStart': instance.freezingStart,
      'freezingEnd': instance.freezingEnd,
      'schedule': instance.schedule,
      'url': instance.url,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
