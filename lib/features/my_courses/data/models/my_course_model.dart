import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/my_course.dart';

part 'my_course_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MyCourseModel extends MyCourse {
  @JsonKey(name: 'courses')
  final List<CourseReferenceModel>? courseModels;

  MyCourseModel({
    super.id,
    super.title,
    super.description,
    super.imageHeader,
    super.slugName,
    super.instructor,
    super.purchaseDate,
    this.courseModels,
  }) : super(courses: courseModels?.map((m) => m.toEntity()).toList());

  factory MyCourseModel.fromJson(Map<String, dynamic> json) =>
      _$MyCourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyCourseModelToJson(this);

  MyCourse toEntity() {
    return MyCourse(
      id: id,
      title: title,
      description: description,
      imageHeader: imageHeader,
      slugName: slugName,
      instructor: instructor,
      purchaseDate: purchaseDate,
      courses: courses,
    );
  }

  factory MyCourseModel.fromEntity(MyCourse myCourse) {
    return MyCourseModel(
      id: myCourse.id,
      title: myCourse.title,
      description: myCourse.description,
      imageHeader: myCourse.imageHeader,
      slugName: myCourse.slugName,
      instructor: myCourse.instructor,
      purchaseDate: myCourse.purchaseDate,
      courseModels: myCourse.courses?.map((c) => CourseReferenceModel.fromEntity(c)).toList(),
    );
  }
}

@JsonSerializable()
class CourseReferenceModel extends CourseReference {
  const CourseReferenceModel({
    super.courseId,
  });

  factory CourseReferenceModel.fromJson(Map<String, dynamic> json) =>
      _$CourseReferenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseReferenceModelToJson(this);

  CourseReference toEntity() {
    return CourseReference(
      courseId: courseId,
    );
  }

  factory CourseReferenceModel.fromEntity(CourseReference courseReference) {
    return CourseReferenceModel(
      courseId: courseReference.courseId,
    );
  }
}
