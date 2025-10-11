// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommentResponse _$PostCommentResponseFromJson(Map<String, dynamic> json) =>
    PostCommentResponse(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      postId: (json['postId'] as num).toInt(),
      content: json['content'] as String,
      likes: (json['likes'] as num).toInt(),
      dislikes: (json['dislikes'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
    );

Map<String, dynamic> _$PostCommentResponseToJson(
  PostCommentResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'postId': instance.postId,
  'content': instance.content,
  'likes': instance.likes,
  'dislikes': instance.dislikes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'userName': instance.userName,
  'userAvatar': instance.userAvatar,
};

CommentListResponse _$CommentListResponseFromJson(Map<String, dynamic> json) =>
    CommentListResponse(
      content: (json['content'] as List<dynamic>)
          .map((e) => PostCommentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      first: json['first'] as bool,
      last: json['last'] as bool,
    );

Map<String, dynamic> _$CommentListResponseToJson(
  CommentListResponse instance,
) => <String, dynamic>{
  'content': instance.content,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'number': instance.number,
  'size': instance.size,
  'first': instance.first,
  'last': instance.last,
};
