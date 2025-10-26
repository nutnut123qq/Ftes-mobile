// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileRequestModel _$ProfileRequestModelFromJson(Map<String, dynamic> json) =>
    ProfileRequestModel(
      name: json['name'] as String?,
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
    );

Map<String, dynamic> _$ProfileRequestModelToJson(
  ProfileRequestModel instance,
) => <String, dynamic>{
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
};
