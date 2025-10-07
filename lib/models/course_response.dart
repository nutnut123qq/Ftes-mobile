import 'package:json_annotation/json_annotation.dart';

part 'course_response.g.dart';

/// Course Response Model
@JsonSerializable()
class CourseResponse {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final double? price;
  final String? slugName;
  final String? categoryName;
  final String? level;
  final String? language;
  final int? duration; // in minutes
  final String? instructorId;
  final String? instructorName;
  final String? instructorAvatar;
  final int? totalStudents;
  final double? rating;
  final int? totalReviews;
  final bool? isFeatured;
  final bool? isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CourseResponse({
    this.id,
    this.title,
    this.description,
    this.image,
    this.price,
    this.slugName,
    this.categoryName,
    this.level,
    this.language,
    this.duration,
    this.instructorId,
    this.instructorName,
    this.instructorAvatar,
    this.totalStudents,
    this.rating,
    this.totalReviews,
    this.isFeatured,
    this.isPublished,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseResponseToJson(this);
}

/// Paging Course Response Model
@JsonSerializable()
class PagingCourseResponse {
  final int? currentPage;
  final int? totalPage;
  final int? pageSize;
  final int? totalCount;
  final List<CourseResponse>? data;

  PagingCourseResponse({
    this.currentPage,
    this.totalPage,
    this.pageSize,
    this.totalCount,
    this.data,
  });

  factory PagingCourseResponse.fromJson(Map<String, dynamic> json) =>
      _$PagingCourseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PagingCourseResponseToJson(this);
}

/// Part (Section) Response Model
@JsonSerializable()
class PartResponse {
  final String? id;
  final String? courseId;
  final String? title;
  final String? description;
  final int? orderIndex;
  final int? totalLessons;
  final int? totalDuration; // in minutes
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PartResponse({
    this.id,
    this.courseId,
    this.title,
    this.description,
    this.orderIndex,
    this.totalLessons,
    this.totalDuration,
    this.createdAt,
    this.updatedAt,
  });

  factory PartResponse.fromJson(Map<String, dynamic> json) =>
      _$PartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PartResponseToJson(this);
}

/// Lesson Response Model
@JsonSerializable()
class LessonResponse {
  final String? id;
  final String? partId;
  final String? courseId;
  final String? title;
  final String? description;
  final String? content;
  final String? videoUrl;
  final String? documentUrl;
  final int? duration; // in minutes
  final int? orderIndex;
  final bool? isFree;
  final bool? isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LessonResponse({
    this.id,
    this.partId,
    this.courseId,
    this.title,
    this.description,
    this.content,
    this.videoUrl,
    this.documentUrl,
    this.duration,
    this.orderIndex,
    this.isFree,
    this.isCompleted,
    this.createdAt,
    this.updatedAt,
  });

  factory LessonResponse.fromJson(Map<String, dynamic> json) =>
      _$LessonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LessonResponseToJson(this);
}

/// User Course Response Model
@JsonSerializable()
class UserCourseResponse {
  final String? id;
  final String? userId;
  final String? courseId;
  final String? courseName;
  final String? courseImage;
  final String? courseSlug;
  final double? progress; // 0-100
  final int? completedLessons;
  final int? totalLessons;
  final DateTime? enrolledAt;
  final DateTime? lastAccessedAt;
  final DateTime? completedAt;

  UserCourseResponse({
    this.id,
    this.userId,
    this.courseId,
    this.courseName,
    this.courseImage,
    this.courseSlug,
    this.progress,
    this.completedLessons,
    this.totalLessons,
    this.enrolledAt,
    this.lastAccessedAt,
    this.completedAt,
  });

  factory UserCourseResponse.fromJson(Map<String, dynamic> json) =>
      _$UserCourseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserCourseResponseToJson(this);
}
