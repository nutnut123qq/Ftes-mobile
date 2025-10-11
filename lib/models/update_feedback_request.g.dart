// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_feedback_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFeedbackRequest _$UpdateFeedbackRequestFromJson(
  Map<String, dynamic> json,
) => UpdateFeedbackRequest(
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
);

Map<String, dynamic> _$UpdateFeedbackRequestToJson(
  UpdateFeedbackRequest instance,
) => <String, dynamic>{'rating': instance.rating, 'comment': instance.comment};
