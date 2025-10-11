import 'package:json_annotation/json_annotation.dart';

part 'update_feedback_request.g.dart';

@JsonSerializable()
class UpdateFeedbackRequest {
  final int rating; // 1-5 stars
  final String comment;

  UpdateFeedbackRequest({
    required this.rating,
    required this.comment,
  });

  factory UpdateFeedbackRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateFeedbackRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFeedbackRequestToJson(this);
}
