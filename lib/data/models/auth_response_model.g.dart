// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationResponseModel _$AuthenticationResponseModelFromJson(
  Map<String, dynamic> json,
) => AuthenticationResponseModel(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  authenticated: json['authenticated'] as bool?,
  deviceId: json['deviceId'] as String?,
);

Map<String, dynamic> _$AuthenticationResponseModelToJson(
  AuthenticationResponseModel instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'authenticated': instance.authenticated,
  'deviceId': instance.deviceId,
};

IntrospectResponseModel _$IntrospectResponseModelFromJson(
  Map<String, dynamic> json,
) => IntrospectResponseModel(
  valid: json['valid'] as bool,
  userId: json['userId'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$IntrospectResponseModelToJson(
  IntrospectResponseModel instance,
) => <String, dynamic>{
  'valid': instance.valid,
  'userId': instance.userId,
  'email': instance.email,
  'role': instance.role,
  'expiresAt': instance.expiresAt?.toIso8601String(),
};

TwoFAResponseModel _$TwoFAResponseModelFromJson(Map<String, dynamic> json) =>
    TwoFAResponseModel(
      secretKey: json['secretKey'] as String,
      qrCodeUrl: json['qrCodeUrl'] as String,
    );

Map<String, dynamic> _$TwoFAResponseModelToJson(TwoFAResponseModel instance) =>
    <String, dynamic>{
      'secretKey': instance.secretKey,
      'qrCodeUrl': instance.qrCodeUrl,
    };

VerifyMailOTPResponseModel _$VerifyMailOTPResponseModelFromJson(
  Map<String, dynamic> json,
) => VerifyMailOTPResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String?,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$VerifyMailOTPResponseModelToJson(
  VerifyMailOTPResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'userId': instance.userId,
};

ApiResponseModel<T> _$ApiResponseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponseModel<T>(
  result: _$nullableGenericFromJson(json['result'], fromJsonT),
  messageDTO: json['messageDTO'] == null
      ? null
      : MessageDTOModel.fromJson(json['messageDTO'] as Map<String, dynamic>),
  success: json['success'] as bool,
);

Map<String, dynamic> _$ApiResponseModelToJson<T>(
  ApiResponseModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'result': _$nullableGenericToJson(instance.result, toJsonT),
  'messageDTO': instance.messageDTO,
  'success': instance.success,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

MessageDTOModel _$MessageDTOModelFromJson(Map<String, dynamic> json) =>
    MessageDTOModel(
      code: json['code'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MessageDTOModelToJson(MessageDTOModel instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
