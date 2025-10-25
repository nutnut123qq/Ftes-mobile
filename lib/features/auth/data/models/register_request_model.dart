import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

/// Register request model
@JsonSerializable()
class RegisterRequestModel {
  final String username;
  final String email;
  final String password;

  const RegisterRequestModel({
    required this.username,
    required this.email,
    required this.password,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
