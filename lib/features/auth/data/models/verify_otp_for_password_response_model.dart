import 'package:json_annotation/json_annotation.dart';
import 'auth_response_model.dart';

part 'verify_otp_for_password_response_model.g.dart';

@JsonSerializable()
class VerifyOTPForPasswordResponseModel {
  final bool success;
  final MessageDTOModel messageDTO;
  final VerifyOTPResultModel result;

  const VerifyOTPForPasswordResponseModel({
    required this.success,
    required this.messageDTO,
    required this.result,
  });

  factory VerifyOTPForPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOTPForPasswordResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyOTPForPasswordResponseModelToJson(this);
}

@JsonSerializable()
class VerifyOTPResultModel {
  final String accessToken;
  final bool verified;

  const VerifyOTPResultModel({
    required this.accessToken,
    required this.verified,
  });

  factory VerifyOTPResultModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOTPResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyOTPResultModelToJson(this);
}
