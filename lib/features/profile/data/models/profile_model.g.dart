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
  phoneNumber: json['phoneNumber'] as String?,
  avatar: json['avatar'] as String?,
  description: json['description'] as String?,
  jobName: json['jobName'] as String?,
  gender: json['gender'] as String?,
  dataOfBirth: json['dataOfBirth'] as String?,
  facebook: json['facebook'] as String?,
  twitter: json['twitter'] as String?,
  youtube: json['youtube'] as String?,
  role: json['role'] as String?,
  userId: json['userId'] as String?,
  contentCourse: json['contentCourse'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'avatar': instance.avatar,
      'description': instance.description,
      'jobName': instance.jobName,
      'gender': instance.gender,
      'dataOfBirth': instance.dataOfBirth,
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'youtube': instance.youtube,
      'role': instance.role,
      'userId': instance.userId,
      'contentCourse': instance.contentCourse,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
