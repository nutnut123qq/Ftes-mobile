import 'lesson.dart';
import 'exercise.dart';

/// Part (Section) entity for course detail
class Part {
  final String id;
  final String name;
  final String description;
  final int order;
  final List<Lesson> lessons;
  final List<Exercise> exercises;

  const Part({
    required this.id,
    required this.name,
    required this.description,
    required this.order,
    required this.lessons,
    required this.exercises,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Part &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.order == order &&
        other.lessons == lessons &&
        other.exercises == exercises;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        order.hashCode ^
        lessons.hashCode ^
        exercises.hashCode;
  }

  @override
  String toString() {
    return 'Part(id: $id, name: $name, order: $order, lessons: ${lessons.length}, exercises: ${exercises.length})';
  }
}
