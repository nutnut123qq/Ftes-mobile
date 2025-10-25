// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_auth_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleAuthRequestModel _$GoogleAuthRequestModelFromJson(
  Map<String, dynamic> json,
) => GoogleAuthRequestModel(
  code: json['code'] as String,
  isAdmin: json['isAdmin'] as bool? ?? false,
);

Map<String, dynamic> _$GoogleAuthRequestModelToJson(
  GoogleAuthRequestModel instance,
) => <String, dynamic>{'code': instance.code, 'isAdmin': instance.isAdmin};
