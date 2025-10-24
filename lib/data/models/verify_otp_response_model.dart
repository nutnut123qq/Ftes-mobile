import 'package:json_annotation/json_annotation.dart';
import 'auth_response_model.dart';

part 'verify_otp_response_model.g.dart';

/// Verify OTP response model
@JsonSerializable()
class VerifyOTPResponseModel {
  final bool success;
  final MessageDTOModel? messageDTO;
  final VerifyOTPResultModel? result;

  const VerifyOTPResponseModel({
    required this.success,
    this.messageDTO,
    this.result,
  });

  factory VerifyOTPResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOTPResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOTPResponseModelToJson(this);
}

/// Verify OTP result model
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
