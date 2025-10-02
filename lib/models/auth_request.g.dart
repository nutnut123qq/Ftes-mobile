// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationRequest _$AuthenticationRequestFromJson(
  Map<String, dynamic> json,
) => AuthenticationRequest(
  credential: json['credential'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$AuthenticationRequestToJson(
  AuthenticationRequest instance,
) => <String, dynamic>{'credential': instance.credential, 'password': instance.password};

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    RefreshTokenRequest(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$RefreshTokenRequestToJson(
  RefreshTokenRequest instance,
) => <String, dynamic>{'refreshToken': instance.refreshToken};

IntrospectRequest _$IntrospectRequestFromJson(Map<String, dynamic> json) =>
    IntrospectRequest(token: json['token'] as String);

Map<String, dynamic> _$IntrospectRequestToJson(IntrospectRequest instance) =>
    <String, dynamic>{'token': instance.token};

GenericAuthCodeRequest _$GenericAuthCodeRequestFromJson(
  Map<String, dynamic> json,
) => GenericAuthCodeRequest(code: json['code'] as String);

Map<String, dynamic> _$GenericAuthCodeRequestToJson(
  GenericAuthCodeRequest instance,
) => <String, dynamic>{'code': instance.code};

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordRequest(email: json['email'] as String);

Map<String, dynamic> _$ForgotPasswordRequestToJson(
  ForgotPasswordRequest instance,
) => <String, dynamic>{'email': instance.email};
