import 'package:json_annotation/json_annotation.dart';

part 'diagramm_key.g.dart';

@JsonSerializable()
class DiagrammKey {
  DiagrammKey({required this.hdr, required this.tbl, required this.tpy});

  @JsonKey(name: "HDR")
  final String hdr;
  @JsonKey(name: "TBL")
  final int tbl;
  @JsonKey(name: "TPY")
  final int tpy;

  factory DiagrammKey.fromJson(Map<String, dynamic> json) =>
      _$DiagrammKeyFromJson(json);

  Map<String, dynamic> toJson() => _$DiagrammKeyToJson(this);
}
