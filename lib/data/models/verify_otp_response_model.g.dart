// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOTPResponseModel _$VerifyOTPResponseModelFromJson(
  Map<String, dynamic> json,
) => VerifyOTPResponseModel(
  success: json['success'] as bool,
  messageDTO: json['messageDTO'] == null
      ? null
      : MessageDTOModel.fromJson(json['messageDTO'] as Map<String, dynamic>),
  result: json['result'] == null
      ? null
      : VerifyOTPResultModel.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VerifyOTPResponseModelToJson(
  VerifyOTPResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'messageDTO': instance.messageDTO,
  'result': instance.result,
};

VerifyOTPResultModel _$VerifyOTPResultModelFromJson(
  Map<String, dynamic> json,
) => VerifyOTPResultModel(
  accessToken: json['accessToken'] as String,
  verified: json['verified'] as bool,
);

Map<String, dynamic> _$VerifyOTPResultModelToJson(
  VerifyOTPResultModel instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'verified': instance.verified,
};
