import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/lesson.dart';

part 'lesson_model.g.dart';

/// Lesson model for JSON serialization
@JsonSerializable(explicitToJson: true)
class LessonModel {
  final String id;
  
  @JsonKey(name: 'name')
  final String title;
  
  final String? description;
  final String? video;
  final int? order;
  final int? partOrder;
  final int? duration;
  final bool? isCompleted;

  const LessonModel({
    required this.id,
    required this.title,
    this.description,
    this.video,
    this.order,
    this.partOrder,
    this.duration,
    this.isCompleted,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);

  Map<String, dynamic> toJson() => _$LessonModelToJson(this);

  Lesson toEntity() {
    return Lesson(
      id: id,
      title: title,
      description: description ?? '',
      video: video ?? '',
      order: order ?? 0,
      partOrder: partOrder ?? 0,
      duration: duration ?? 0,
      isCompleted: isCompleted ?? false,
    );
  }

  factory LessonModel.fromEntity(Lesson lesson) {
    return LessonModel(
      id: lesson.id,
      title: lesson.title,
      description: lesson.description.isEmpty ? null : lesson.description,
      video: lesson.video.isEmpty ? null : lesson.video,
      order: lesson.order == 0 ? null : lesson.order,
      partOrder: lesson.partOrder == 0 ? null : lesson.partOrder,
      duration: lesson.duration == 0 ? null : lesson.duration,
      isCompleted: lesson.isCompleted ? true : null,
    );
  }
}
