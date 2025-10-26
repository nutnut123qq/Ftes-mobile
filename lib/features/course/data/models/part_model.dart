import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/part.dart';
import 'lesson_model.dart';
import 'exercise_model.dart';

part 'part_model.g.dart';

/// Part model for JSON serialization
@JsonSerializable(explicitToJson: true)
class PartModel {
  final String id;
  final String name;
  final String description;
  final int? order;
  
  @JsonKey(name: 'lessons')
  final List<LessonModel>? lessons;

  @JsonKey(name: 'exercises')
  final List<ExerciseModel>? exercises;

  const PartModel({
    required this.id,
    required this.name,
    required this.description,
    this.order,
    this.lessons,
    this.exercises,
  });

  factory PartModel.fromJson(Map<String, dynamic> json) =>
      _$PartModelFromJson(json);

  Map<String, dynamic> toJson() => _$PartModelToJson(this);

  Part toEntity() {
    return Part(
      id: id,
      name: name,
      description: description,
      order: order ?? 0,
      lessons: lessons?.map((l) => l.toEntity()).toList() ?? [],
      exercises: exercises?.map((e) => e.toEntity()).toList() ?? [],
    );
  }

  factory PartModel.fromEntity(Part part) {
    return PartModel(
      id: part.id,
      name: part.name,
      description: part.description,
      order: part.order == 0 ? null : part.order,
      lessons: part.lessons.map((l) => LessonModel.fromEntity(l)).toList(),
      exercises: part.exercises.map((e) => ExerciseModel.fromEntity(e)).toList(),
    );
  }
}
