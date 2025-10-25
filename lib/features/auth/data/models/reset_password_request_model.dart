import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_model.g.dart';

@JsonSerializable()
class ResetPasswordRequestModel {
  final String password;
  final String accessToken;

  const ResetPasswordRequestModel({
    required this.password,
    required this.accessToken,
  });

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResetPasswordRequestModelToJson(this);
}
