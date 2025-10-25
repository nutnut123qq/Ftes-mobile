// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
  id: json['id'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  buttonText: json['buttonText'] as String?,
  imageUrl: json['imageUrl'] as String?,
  url: json['url'] as String?,
  backgroundGradient: json['backgroundGradient'] as String?,
  backgroundColor: json['backgroundColor'] as String?,
  active: json['active'] as bool?,
  createdAt: json['createdAt'] as String?,
  createdUser: json['createdUser'] as String?,
);

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'buttonText': instance.buttonText,
      'imageUrl': instance.imageUrl,
      'url': instance.url,
      'backgroundGradient': instance.backgroundGradient,
      'backgroundColor': instance.backgroundColor,
      'active': instance.active,
      'createdAt': instance.createdAt,
      'createdUser': instance.createdUser,
    };
