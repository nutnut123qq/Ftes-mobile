import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
import 'auth_response_model.dart';

part 'register_response_model.g.dart';

/// Register response model
@JsonSerializable()
class RegisterResponseModel {
  final bool success;
  final MessageDTOModel? messageDTO;
  final UserModel? result;

  const RegisterResponseModel({
    required this.success,
    this.messageDTO,
    this.result,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);
}
