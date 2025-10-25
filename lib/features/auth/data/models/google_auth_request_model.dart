import 'package:json_annotation/json_annotation.dart';

part 'google_auth_request_model.g.dart';

@JsonSerializable()
class GoogleAuthRequestModel {
  final String code;
  final bool isAdmin;

  GoogleAuthRequestModel({
    required this.code,
    this.isAdmin = false,
  });

  factory GoogleAuthRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleAuthRequestModelToJson(this);
}
