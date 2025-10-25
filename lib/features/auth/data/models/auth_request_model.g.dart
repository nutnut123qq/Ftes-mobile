// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationRequestModel _$AuthenticationRequestModelFromJson(
  Map<String, dynamic> json,
) => AuthenticationRequestModel(
  credential: json['credential'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$AuthenticationRequestModelToJson(
  AuthenticationRequestModel instance,
) => <String, dynamic>{
  'credential': instance.credential,
  'password': instance.password,
};

RefreshTokenRequestModel _$RefreshTokenRequestModelFromJson(
  Map<String, dynamic> json,
) => RefreshTokenRequestModel(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$RefreshTokenRequestModelToJson(
  RefreshTokenRequestModel instance,
) => <String, dynamic>{'refreshToken': instance.refreshToken};

IntrospectRequestModel _$IntrospectRequestModelFromJson(
  Map<String, dynamic> json,
) => IntrospectRequestModel(token: json['token'] as String);

Map<String, dynamic> _$IntrospectRequestModelToJson(
  IntrospectRequestModel instance,
) => <String, dynamic>{'token': instance.token};

GenericAuthCodeRequestModel _$GenericAuthCodeRequestModelFromJson(
  Map<String, dynamic> json,
) => GenericAuthCodeRequestModel(code: json['code'] as String);

Map<String, dynamic> _$GenericAuthCodeRequestModelToJson(
  GenericAuthCodeRequestModel instance,
) => <String, dynamic>{'code': instance.code};

ForgotPasswordRequestModel _$ForgotPasswordRequestModelFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordRequestModel(email: json['email'] as String);

Map<String, dynamic> _$ForgotPasswordRequestModelToJson(
  ForgotPasswordRequestModel instance,
) => <String, dynamic>{'email': instance.email};
