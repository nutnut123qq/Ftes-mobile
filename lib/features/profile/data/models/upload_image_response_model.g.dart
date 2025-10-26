// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_image_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadImageResponseModel _$UploadImageResponseModelFromJson(
  Map<String, dynamic> json,
) => UploadImageResponseModel(
  success: json['success'] as bool,
  result: json['result'] == null
      ? null
      : UploadImageResultModel.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UploadImageResponseModelToJson(
  UploadImageResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'result': instance.result?.toJson(),
};

UploadImageResultModel _$UploadImageResultModelFromJson(
  Map<String, dynamic> json,
) => UploadImageResultModel(
  cdnUrl: json['cdnUrl'] as String,
  url: json['url'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$UploadImageResultModelToJson(
  UploadImageResultModel instance,
) => <String, dynamic>{
  'cdnUrl': instance.cdnUrl,
  'url': instance.url,
  'message': instance.message,
};
