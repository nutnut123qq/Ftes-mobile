// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_comment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCommentRequest _$CreateCommentRequestFromJson(
  Map<String, dynamic> json,
) => CreateCommentRequest(
  userId: (json['userId'] as num).toInt(),
  postId: (json['postId'] as num).toInt(),
  content: json['content'] as String,
);

Map<String, dynamic> _$CreateCommentRequestToJson(
  CreateCommentRequest instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'postId': instance.postId,
  'content': instance.content,
};
