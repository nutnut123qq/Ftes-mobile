import 'package:json_annotation/json_annotation.dart';

part 'create_feedback_request.g.dart';

@JsonSerializable()
class CreateFeedbackRequest {
  final int userId;
  final int courseId;
  final int rating; // 1-5 stars
  final String comment;

  CreateFeedbackRequest({
    required this.userId,
    required this.courseId,
    required this.rating,
    required this.comment,
  });

  factory CreateFeedbackRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFeedbackRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFeedbackRequestToJson(this);
}
