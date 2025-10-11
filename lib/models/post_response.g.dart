// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostResponse _$PostResponseFromJson(Map<String, dynamic> json) => PostResponse(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String,
  likes: (json['likes'] as num).toInt(),
  dislikes: (json['dislikes'] as num).toInt(),
  commentCount: (json['commentCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  userName: json['userName'] as String?,
  userAvatar: json['userAvatar'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$PostResponseToJson(PostResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'likes': instance.likes,
      'dislikes': instance.dislikes,
      'commentCount': instance.commentCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'tags': instance.tags,
    };

PostListResponse _$PostListResponseFromJson(Map<String, dynamic> json) =>
    PostListResponse(
      content: (json['content'] as List<dynamic>)
          .map((e) => PostResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      first: json['first'] as bool,
      last: json['last'] as bool,
    );

Map<String, dynamic> _$PostListResponseToJson(PostListResponse instance) =>
    <String, dynamic>{
      'content': instance.content,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'number': instance.number,
      'size': instance.size,
      'first': instance.first,
      'last': instance.last,
    };
