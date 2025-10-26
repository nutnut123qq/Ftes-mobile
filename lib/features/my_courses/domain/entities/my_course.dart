import 'package:equatable/equatable.dart';

/// MyCourse entity for domain layer
class MyCourse extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? imageHeader;
  final String? slugName;
  final String? instructor;
  final String? purchaseDate;
  final List<CourseReference>? courses;

  const MyCourse({
    this.id,
    this.title,
    this.description,
    this.imageHeader,
    this.slugName,
    this.instructor,
    this.purchaseDate,
    this.courses,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageHeader,
        slugName,
        instructor,
        purchaseDate,
        courses,
      ];
}

/// CourseReference entity for domain layer
class CourseReference extends Equatable {
  final String? courseId;

  const CourseReference({
    this.courseId,
  });

  @override
  List<Object?> get props => [courseId];
}
