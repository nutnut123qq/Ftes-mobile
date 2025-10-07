// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationResponse _$AuthenticationResponseFromJson(
  Map<String, dynamic> json,
) => AuthenticationResponse(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  tokenType: json['tokenType'] as String?,
  expiresIn: (json['expiresIn'] as num?)?.toInt(),
  authenticated: json['authenticated'] as bool?,
  deviceId: json['deviceId'] as String?,
  user: json['user'] == null
      ? null
      : UserInfo.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthenticationResponseToJson(
  AuthenticationResponse instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'tokenType': instance.tokenType,
  'expiresIn': instance.expiresIn,
  'authenticated': instance.authenticated,
  'deviceId': instance.deviceId,
  'user': instance.user,
};

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String?,
  fullName: json['fullName'] as String?,
  avatar: json['avatar'] as String?,
  role: json['role'] as String?,
  status: json['status'] as String?,
  referral: json['referral'] as bool?,
  enable2FA: json['enable2FA'] as bool?,
  createdAt: json['createdAt'] as String?,
  created: json['created'] as String?,
);

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'fullName': instance.fullName,
  'avatar': instance.avatar,
  'role': instance.role,
  'status': instance.status,
  'referral': instance.referral,
  'enable2FA': instance.enable2FA,
  'createdAt': instance.createdAt,
  'created': instance.created,
};

IntrospectResponse _$IntrospectResponseFromJson(Map<String, dynamic> json) =>
    IntrospectResponse(
      valid: json['valid'] as bool,
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$IntrospectResponseToJson(IntrospectResponse instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'userId': instance.userId,
      'email': instance.email,
      'role': instance.role,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

TwoFAResponse _$TwoFAResponseFromJson(Map<String, dynamic> json) =>
    TwoFAResponse(
      secretKey: json['secretKey'] as String,
      qrCodeUrl: json['qrCodeUrl'] as String,
    );

Map<String, dynamic> _$TwoFAResponseToJson(TwoFAResponse instance) =>
    <String, dynamic>{
      'secretKey': instance.secretKey,
      'qrCodeUrl': instance.qrCodeUrl,
    };

VerifyMailOTPResponse _$VerifyMailOTPResponseFromJson(
  Map<String, dynamic> json,
) => VerifyMailOTPResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$VerifyMailOTPResponseToJson(
  VerifyMailOTPResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'userId': instance.userId,
};

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  result: _$nullableGenericFromJson(json['result'], fromJsonT),
  messageDTO: json['messageDTO'] == null
      ? null
      : MessageDTO.fromJson(json['messageDTO'] as Map<String, dynamic>),
  success: json['success'] as bool,
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
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

MessageDTO _$MessageDTOFromJson(Map<String, dynamic> json) => MessageDTO(
  code: json['code'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$MessageDTOToJson(MessageDTO instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
