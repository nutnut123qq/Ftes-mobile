import 'package:json_annotation/json_annotation.dart';

part 'exercise_response.g.dart';

@JsonSerializable()
class ExerciseResponse {
  final int id;
  final String title;
  final String description;
  final String? question;
  final String? correctAnswer;
  final int lessonId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExerciseResponse({
    required this.id,
    required this.title,
    required this.description,
    this.question,
    this.correctAnswer,
    required this.lessonId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExerciseResponse.fromJson(Map<String, dynamic> json) =>
      _$ExerciseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseResponseToJson(this);
}
