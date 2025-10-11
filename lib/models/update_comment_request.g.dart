// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_comment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCommentRequest _$UpdateCommentRequestFromJson(
  Map<String, dynamic> json,
) => UpdateCommentRequest(
  commentId: (json['commentId'] as num).toInt(),
  content: json['content'] as String,
);

Map<String, dynamic> _$UpdateCommentRequestToJson(
  UpdateCommentRequest instance,
) => <String, dynamic>{
  'commentId': instance.commentId,
  'content': instance.content,
};
