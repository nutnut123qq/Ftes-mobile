// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_feedback_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFeedbackRequest _$CreateFeedbackRequestFromJson(
  Map<String, dynamic> json,
) => CreateFeedbackRequest(
  userId: (json['userId'] as num).toInt(),
  courseId: (json['courseId'] as num).toInt(),
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
);

Map<String, dynamic> _$CreateFeedbackRequestToJson(
  CreateFeedbackRequest instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'courseId': instance.courseId,
  'rating': instance.rating,
  'comment': instance.comment,
};
