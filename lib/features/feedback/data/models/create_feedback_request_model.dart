import 'package:json_annotation/json_annotation.dart';

part 'create_feedback_request_model.g.dart';

@JsonSerializable()
class CreateFeedbackRequestModel {
  final int userId;
  final int courseId;
  final int rating;
  final String comment;

  const CreateFeedbackRequestModel({
    required this.userId,
    required this.courseId,
    required this.rating,
    required this.comment,
  });

  factory CreateFeedbackRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateFeedbackRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFeedbackRequestModelToJson(this);
}
