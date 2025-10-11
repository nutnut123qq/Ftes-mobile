// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_post_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePostRequest _$UpdatePostRequestFromJson(Map<String, dynamic> json) =>
    UpdatePostRequest(
      title: json['title'] as String,
      content: json['content'] as String,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UpdatePostRequestToJson(UpdatePostRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'tags': instance.tags,
    };
