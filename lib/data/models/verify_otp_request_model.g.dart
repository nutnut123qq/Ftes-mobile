// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOTPRequestModel _$VerifyOTPRequestModelFromJson(
  Map<String, dynamic> json,
) => VerifyOTPRequestModel(
  email: json['email'] as String,
  otp: (json['otp'] as num).toInt(),
);

Map<String, dynamic> _$VerifyOTPRequestModelToJson(
  VerifyOTPRequestModel instance,
) => <String, dynamic>{'email': instance.email, 'otp': instance.otp};
