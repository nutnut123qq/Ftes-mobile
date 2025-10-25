// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_for_password_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOTPForPasswordResponseModel _$VerifyOTPForPasswordResponseModelFromJson(
  Map<String, dynamic> json,
) => VerifyOTPForPasswordResponseModel(
  success: json['success'] as bool,
  messageDTO: MessageDTOModel.fromJson(
    json['messageDTO'] as Map<String, dynamic>,
  ),
  result: VerifyOTPResultModel.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VerifyOTPForPasswordResponseModelToJson(
  VerifyOTPForPasswordResponseModel instance,
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
