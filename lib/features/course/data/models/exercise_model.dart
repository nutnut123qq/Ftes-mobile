import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/exercise.dart';

part 'exercise_model.g.dart';

/// Exercise model for JSON serialization
@JsonSerializable(explicitToJson: true)
class ExerciseModel {
  final String id;
  final String title;
  final String description;
  final int? order;
  final int? partOrder;
  final String createdAt;
  final String updatedAt;

  const ExerciseModel({
    required this.id,
    required this.title,
    required this.description,
    this.order,
    this.partOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseModelToJson(this);

  Exercise toEntity() {
    return Exercise(
      id: id,
      title: title,
      description: description,
      order: order ?? 0,
      partOrder: partOrder ?? 0,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ExerciseModel.fromEntity(Exercise exercise) {
    return ExerciseModel(
      id: exercise.id,
      title: exercise.title,
      description: exercise.description,
      order: exercise.order == 0 ? null : exercise.order,
      partOrder: exercise.partOrder == 0 ? null : exercise.partOrder,
      createdAt: exercise.createdAt,
      updatedAt: exercise.updatedAt,
    );
  }
}
