import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/feedback.dart';

part 'feedback_model.g.dart';

/// Model dữ liệu feedback ở tầng data
@JsonSerializable()
class FeedbackModel extends FeedbackEntity {
  const FeedbackModel({
    required super.id,
    required super.userId,
    required super.courseId,
    required super.rating,
    required super.comment,
    required super.createdAt,
    required super.updatedAt,
    super.userName,
    super.userAvatar,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackModelToJson(this);

  FeedbackEntity toEntity() => FeedbackEntity(
    id: id,
    userId: userId,
    courseId: courseId,
    rating: rating,
    comment: comment,
    createdAt: createdAt,
    updatedAt: updatedAt,
    userName: userName,
    userAvatar: userAvatar,
  );

  factory FeedbackModel.fromEntity(FeedbackEntity entity) => FeedbackModel(
    id: entity.id,
    userId: entity.userId,
    courseId: entity.courseId,
    rating: entity.rating,
    comment: entity.comment,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    userName: entity.userName,
    userAvatar: entity.userAvatar,
  );
}
