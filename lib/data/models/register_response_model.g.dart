// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponseModel _$RegisterResponseModelFromJson(
  Map<String, dynamic> json,
) => RegisterResponseModel(
  success: json['success'] as bool,
  messageDTO: json['messageDTO'] == null
      ? null
      : MessageDTOModel.fromJson(json['messageDTO'] as Map<String, dynamic>),
  result: json['result'] == null
      ? null
      : UserModel.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegisterResponseModelToJson(
  RegisterResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'messageDTO': instance.messageDTO,
  'result': instance.result,
};
