// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_feedback_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFeedbackRequestModel _$UpdateFeedbackRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateFeedbackRequestModel(
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
);

Map<String, dynamic> _$UpdateFeedbackRequestModelToJson(
  UpdateFeedbackRequestModel instance,
) => <String, dynamic>{'rating': instance.rating, 'comment': instance.comment};
