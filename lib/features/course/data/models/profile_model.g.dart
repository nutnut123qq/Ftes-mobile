// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  id: json['id'] as String,
  username: json['username'] as String,
  name: json['name'] as String,
  email: json['email'] as String?,
  avatar: json['avatar'] as String?,
  description: json['description'] as String?,
  jobName: json['jobName'] as String?,
  facebook: json['facebook'] as String?,
  twitter: json['twitter'] as String?,
  youtube: json['youtube'] as String?,
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
      'description': instance.description,
      'jobName': instance.jobName,
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'youtube': instance.youtube,
    };
