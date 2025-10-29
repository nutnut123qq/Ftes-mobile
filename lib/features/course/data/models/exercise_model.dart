import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/exercise.dart';

part 'exercise_model.g.dart';

// Helper functions to convert between String and bool
bool _boolFromString(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final v = value.toLowerCase().trim();
    return v == 'true' || v == '1' || v == 'yes';
  }
  return false;
}

String _boolToString(bool value) => value.toString();

/// Exercise model for JSON serialization
@JsonSerializable(explicitToJson: true)
class ExerciseModel {
  final String id;
  final String type;
  final String title;
  final String description;
  final String question;
  final String expectedOutput;
  final String criteria;
  @JsonKey(fromJson: _boolFromString, toJson: _boolToString)
  final bool checkLogic;
  
  @JsonKey(fromJson: _boolFromString, toJson: _boolToString)
  final bool checkPerform;
  
  @JsonKey(fromJson: _boolFromString, toJson: _boolToString)
  final bool checkEdgeCase;
  final String fileExtension;
  final int order;
  final int? partOrder;
  final String? createdAt;
  final String? updatedAt;

  const ExerciseModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.question,
    required this.expectedOutput,
    required this.criteria,
    required this.checkLogic,
    required this.checkPerform,
    required this.checkEdgeCase,
    required this.fileExtension,
    required this.order,
    this.partOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseModelToJson(this);

  Exercise toEntity() {
    return Exercise(
      id: id,
      type: type,
      title: title,
      description: description,
      question: question,
      expectedOutput: expectedOutput,
      criteria: criteria,
      checkLogic: checkLogic,
      checkPerform: checkPerform,
      checkEdgeCase: checkEdgeCase,
      fileExtension: fileExtension,
      order: order,
      partOrder: partOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ExerciseModel.fromEntity(Exercise exercise) {
    return ExerciseModel(
      id: exercise.id,
      type: exercise.type,
      title: exercise.title,
      description: exercise.description,
      question: exercise.question,
      expectedOutput: exercise.expectedOutput,
      criteria: exercise.criteria,
      checkLogic: exercise.checkLogic,
      checkPerform: exercise.checkPerform,
      checkEdgeCase: exercise.checkEdgeCase,
      fileExtension: exercise.fileExtension,
      order: exercise.order,
      partOrder: exercise.partOrder,
      createdAt: exercise.createdAt,
      updatedAt: exercise.updatedAt,
    );
  }
}
