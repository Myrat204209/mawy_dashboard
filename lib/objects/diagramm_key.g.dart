// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagramm_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiagrammKey _$DiagrammKeyFromJson(Map<String, dynamic> json) => DiagrammKey(
  hdr: json['HDR'] as String,
  tbl: (json['TBL'] as num).toInt(),
  tpy: (json['TPY'] as num).toInt(),
);

Map<String, dynamic> _$DiagrammKeyToJson(DiagrammKey instance) =>
    <String, dynamic>{
      'HDR': instance.hdr,
      'TBL': instance.tbl,
      'TPY': instance.tpy,
    };
