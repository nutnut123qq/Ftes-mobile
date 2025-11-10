import 'package:json_annotation/json_annotation.dart';

part 'update_feedback_request_model.g.dart';

@JsonSerializable()
class UpdateFeedbackRequestModel {
  final int rating;
  final String comment;

  const UpdateFeedbackRequestModel({
    required this.rating,
    required this.comment,
  });

  factory UpdateFeedbackRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateFeedbackRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFeedbackRequestModelToJson(this);
}
