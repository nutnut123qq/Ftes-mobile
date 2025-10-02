// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileRequest _$UpdateProfileRequestFromJson(Map<String, dynamic> json) =>
    UpdateProfileRequest(
      name: json['name'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      avatar: json['avatar'] as String?,
      dateOfBirth: json['dob'] == null
          ? null
          : DateTime.parse(json['dob'] as String),
      gender: json['gender'] == null ? null : _$GenderEnumMap.entries
          .singleWhere((e) => e.value == json['gender'], orElse: () => MapEntry(Gender.male, 'MALE'))
          .key,
      description: json['description'] as String?,
      jobName: json['jobName'] as String?,
      facebook: json['facebook'] as String?,
      youtube: json['youtube'] as String?,
      twitter: json['twitter'] as String?,
    );

Map<String, dynamic> _$UpdateProfileRequestToJson(UpdateProfileRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'avatar': instance.avatar,
      'dob': instance.dateOfBirth?.toIso8601String(),
      'gender': _$GenderEnumMap[instance.gender],
      'description': instance.description,
      'jobName': instance.jobName,
      'facebook': instance.facebook,
      'youtube': instance.youtube,
      'twitter': instance.twitter,
    };

const _$GenderEnumMap = {
  Gender.male: 'MALE',
  Gender.female: 'FEMALE',
  Gender.other: 'OTHER',
};
