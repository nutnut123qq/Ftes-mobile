// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackResponse _$FeedbackResponseFromJson(Map<String, dynamic> json) =>
    FeedbackResponse(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
    );

Map<String, dynamic> _$FeedbackResponseToJson(FeedbackResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'courseId': instance.courseId,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
    };

FeedbackListResponse _$FeedbackListResponseFromJson(
  Map<String, dynamic> json,
) => FeedbackListResponse(
  content: (json['content'] as List<dynamic>)
      .map((e) => FeedbackResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalElements: (json['totalElements'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  number: (json['number'] as num).toInt(),
  size: (json['size'] as num).toInt(),
  first: json['first'] as bool,
  last: json['last'] as bool,
);

Map<String, dynamic> _$FeedbackListResponseToJson(
  FeedbackListResponse instance,
) => <String, dynamic>{
  'content': instance.content,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'number': instance.number,
  'size': instance.size,
  'first': instance.first,
  'last': instance.last,
};
