// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      role: json['role'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      gender: json['gender'] == null ? null : _$GenderEnumMap.entries
          .singleWhere((e) => e.value == json['gender'], orElse: () => MapEntry(Gender.male, 'MALE'))
          .key,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      avatar: json['avatar'] as String?,
      isDarkMode: json['isDarkMode'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      description: json['description'] as String?,
      jobName: json['jobName'] as String?,
      facebook: json['facebook'] as String?,
      youtube: json['youtube'] as String?,
      twitter: json['twitter'] as String?,
      posts: (json['posts'] as List<dynamic>?)
          ?.map((e) => PostResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'username': instance.username,
      'role': instance.role,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'gender': _$GenderEnumMap[instance.gender],
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'avatar': instance.avatar,
      'isDarkMode': instance.isDarkMode,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'description': instance.description,
      'jobName': instance.jobName,
      'facebook': instance.facebook,
      'youtube': instance.youtube,
      'twitter': instance.twitter,
      'posts': instance.posts,
    };

PostResponse _$PostResponseFromJson(Map<String, dynamic> json) => PostResponse(
      id: json['id'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      authorId: json['authorId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PostResponseToJson(PostResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'authorId': instance.authorId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$GenderEnumMap = {
  Gender.male: 'MALE',
  Gender.female: 'FEMALE',
  Gender.other: 'OTHER',
};
