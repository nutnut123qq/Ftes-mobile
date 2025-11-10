import 'package:flutter/foundation.dart';
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
  final String? type; // VIDEO, DOCUMENT, EXERCISE
  @JsonKey(name: 'exercise')
  final Map<String, dynamic>? exercise;

  const LessonModel({
    required this.id,
    required this.title,
    this.description,
    this.video,
    this.order,
    this.partOrder,
    this.duration,
    this.isCompleted,
    this.type,
    this.exercise,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    // Debug log to check video field
    if (json['video'] != null) {
      debugPrint('🎬 LessonModel.fromJson - video field: ${json['video']}');
    }
    return _$LessonModelFromJson(json);
  }

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
      type: type,
      exerciseMeta: exercise,
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
      type: lesson.type,
      exercise: lesson.exerciseMeta,
    );
  }
}
