import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/course_detail.dart';
import 'part_model.dart';
import 'exercise_model.dart';

part 'course_detail_model.g.dart';

/// Course Detail model for JSON serialization
@JsonSerializable(explicitToJson: true)
class CourseDetailModel {
  final String id;
  final String title;
  final String description;
  
  @JsonKey(name: 'avgStar')
  final double avgStar;
  
  @JsonKey(name: 'totalPrice')
  final double totalPrice;
  
  @JsonKey(name: 'salePrice')
  final double salePrice;
  
  @JsonKey(name: 'totalUser')
  final int totalUser;
  
  @JsonKey(name: 'imageHeader')
  final String imageHeader;
  
  final String slugName;
  final String courseCode;
  final int term;
  final String? contentCourse;
  final String level;
  
  @JsonKey(name: 'userId')
  final String userId;
  
  @JsonKey(name: 'userName')
  final String? userName;
  
  final String categoryId;
  final String? categoryName;
  
  @JsonKey(name: 'infoCourse')
  final Map<String, dynamic>? infoCourse;
  
  @JsonKey(name: 'parts')
  final List<PartModel>? parts;

  @JsonKey(name: 'exercises')
  final List<ExerciseModel>? exercises;

  const CourseDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.avgStar,
    required this.totalPrice,
    required this.salePrice,
    required this.totalUser,
    required this.imageHeader,
    required this.slugName,
    required this.courseCode,
    required this.term,
    this.contentCourse,
    required this.level,
    required this.userId,
    this.userName,
    required this.categoryId,
    this.categoryName,
    this.infoCourse,
    this.parts,
    this.exercises,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    // Normalize possible alternate keys from legacy API
    final normalized = Map<String, dynamic>.from(json);
    if (!normalized.containsKey('infoCourse') && normalized.containsKey('info_course')) {
      normalized['infoCourse'] = normalized['info_course'];
    }
    if (!normalized.containsKey('exercises')) {
      if (normalized.containsKey('exercise')) {
        normalized['exercises'] = normalized['exercise'];
      } else if (normalized.containsKey('exerciseList')) {
        normalized['exercises'] = normalized['exerciseList'];
      }
    }
    if (!normalized.containsKey('parts') && normalized.containsKey('sections')) {
      normalized['parts'] = normalized['sections'];
    }
    return _$CourseDetailModelFromJson(normalized);
  }

  Map<String, dynamic> toJson() => _$CourseDetailModelToJson(this);

  CourseDetail toEntity() {
    return CourseDetail(
      id: id,
      title: title,
      description: description,
      avgStar: avgStar,
      totalPrice: totalPrice,
      salePrice: salePrice,
      totalUser: totalUser,
      imageHeader: imageHeader,
      slugName: slugName,
      courseCode: courseCode,
      term: term,
      contentCourse: contentCourse ?? '',
      level: level,
      userId: userId,
      userName: userName ?? '',
      categoryId: categoryId,
      categoryName: categoryName ?? '',
      infoCourse: infoCourse ?? {},
      parts: parts?.map((p) => p.toEntity()).toList() ?? [],
      exercises: exercises?.map((e) => e.toEntity()).toList() ?? [],
    );
  }

  factory CourseDetailModel.fromEntity(CourseDetail courseDetail) {
    return CourseDetailModel(
      id: courseDetail.id,
      title: courseDetail.title,
      description: courseDetail.description,
      avgStar: courseDetail.avgStar,
      totalPrice: courseDetail.totalPrice,
      salePrice: courseDetail.salePrice,
      totalUser: courseDetail.totalUser,
      imageHeader: courseDetail.imageHeader,
      slugName: courseDetail.slugName,
      courseCode: courseDetail.courseCode,
      term: courseDetail.term,
      contentCourse: courseDetail.contentCourse.isEmpty ? null : courseDetail.contentCourse,
      level: courseDetail.level,
      userId: courseDetail.userId,
      userName: courseDetail.userName.isEmpty ? null : courseDetail.userName,
      categoryId: courseDetail.categoryId,
      categoryName: courseDetail.categoryName.isEmpty ? null : courseDetail.categoryName,
      infoCourse: courseDetail.infoCourse,
      parts: courseDetail.parts.map((p) => PartModel.fromEntity(p)).toList(),
      exercises: courseDetail.exercises.map((e) => ExerciseModel.fromEntity(e)).toList(),
    );
  }
}
