import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_request_model.g.dart';

/// Verify OTP request model
@JsonSerializable()
class VerifyOTPRequestModel {
  final String email;
  final int otp;

  const VerifyOTPRequestModel({
    required this.email,
    required this.otp,
  });

  factory VerifyOTPRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOTPRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOTPRequestModelToJson(this);
}
