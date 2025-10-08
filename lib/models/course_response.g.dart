// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseResponse _$CourseResponseFromJson(Map<String, dynamic> json) =>
    CourseResponse(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['imageHeader'] as String?,
      price: (json['totalPrice'] as num?)?.toDouble(),
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      slugName: json['slugName'] as String?,
      categoryName: json['categoryName'] as String?,
      level: json['level'] as String?,
      language: json['language'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      instructorId: json['userId'] as String?,
      instructorName: json['instructorName'] as String?,
      instructorAvatar: json['instructorAvatar'] as String?,
      totalStudents: (json['totalUser'] as num?)?.toInt(),
      rating: (json['avgStar'] as num?)?.toDouble(),
      totalReviews: (json['totalReviews'] as num?)?.toInt(),
      isFeatured: json['isFeatured'] as bool?,
      isPublished: json['isPublished'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      courseCode: json['courseCode'] as String?,
      term: json['term'] as String?,
      contentCourse: json['contentCourse'] as String?,
      infoCourse: json['infoCourse'] as Map<String, dynamic>?,
      parts: (json['parts'] as List<dynamic>?)
          ?.map((e) => PartResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      exercises: json['exercises'] as List<dynamic>?,
    );

Map<String, dynamic> _$CourseResponseToJson(CourseResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageHeader': instance.image,
      'totalPrice': instance.price,
      'salePrice': instance.salePrice,
      'slugName': instance.slugName,
      'categoryName': instance.categoryName,
      'level': instance.level,
      'language': instance.language,
      'duration': instance.duration,
      'userId': instance.instructorId,
      'instructorName': instance.instructorName,
      'instructorAvatar': instance.instructorAvatar,
      'totalUser': instance.totalStudents,
      'avgStar': instance.rating,
      'totalReviews': instance.totalReviews,
      'isFeatured': instance.isFeatured,
      'isPublished': instance.isPublished,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'courseCode': instance.courseCode,
      'term': instance.term,
      'contentCourse': instance.contentCourse,
      'infoCourse': instance.infoCourse,
      'parts': instance.parts?.map((e) => e.toJson()).toList(),
      'exercises': instance.exercises,
    };

PagingCourseResponse _$PagingCourseResponseFromJson(
  Map<String, dynamic> json,
) => PagingCourseResponse(
  currentPage: (json['currentPage'] as num?)?.toInt(),
  totalPage: (json['totalPage'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  totalCount: (json['totalCount'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => CourseResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PagingCourseResponseToJson(
  PagingCourseResponse instance,
) => <String, dynamic>{
  'currentPage': instance.currentPage,
  'totalPage': instance.totalPage,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
  'data': instance.data,
};

PartResponse _$PartResponseFromJson(Map<String, dynamic> json) => PartResponse(
  id: json['id'] as String?,
  courseId: json['courseId'] as String?,
  title: json['name'] as String?,
  description: json['description'] as String?,
  orderIndex: (json['order'] as num?)?.toInt(),
  totalLessons: (json['totalLessons'] as num?)?.toInt(),
  totalDuration: (json['totalDuration'] as num?)?.toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  lessons: (json['lessons'] as List<dynamic>?)
      ?.map((e) => LessonResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  exercises: json['exercises'] as List<dynamic>?,
);

Map<String, dynamic> _$PartResponseToJson(PartResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'name': instance.title,
      'description': instance.description,
      'order': instance.orderIndex,
      'totalLessons': instance.totalLessons,
      'totalDuration': instance.totalDuration,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'lessons': instance.lessons?.map((e) => e.toJson()).toList(),
      'exercises': instance.exercises,
    };

LessonResponse _$LessonResponseFromJson(Map<String, dynamic> json) =>
    LessonResponse(
      id: json['id'] as String?,
      partId: json['partId'] as String?,
      courseId: json['courseId'] as String?,
      title: json['name'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      videoUrl: json['video'] as String?,
      documentUrl: json['documentUrl'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      orderIndex: (json['order'] as num?)?.toInt(),
      isFree: json['isFree'] as bool?,
      isCompleted: json['isCompleted'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$LessonResponseToJson(LessonResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partId': instance.partId,
      'courseId': instance.courseId,
      'name': instance.title,
      'description': instance.description,
      'content': instance.content,
      'video': instance.videoUrl,
      'documentUrl': instance.documentUrl,
      'duration': instance.duration,
      'order': instance.orderIndex,
      'isFree': instance.isFree,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'type': instance.type,
    };

UserCourseResponse _$UserCourseResponseFromJson(Map<String, dynamic> json) =>
    UserCourseResponse(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      courseId: json['courseId'] as String?,
      courseName: json['courseName'] as String?,
      courseImage: json['courseImage'] as String?,
      courseSlug: json['courseSlug'] as String?,
      progress: (json['progress'] as num?)?.toDouble(),
      completedLessons: (json['completedLessons'] as num?)?.toInt(),
      totalLessons: (json['totalLessons'] as num?)?.toInt(),
      enrolledAt: json['enrolledAt'] == null
          ? null
          : DateTime.parse(json['enrolledAt'] as String),
      lastAccessedAt: json['lastAccessedAt'] == null
          ? null
          : DateTime.parse(json['lastAccessedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$UserCourseResponseToJson(UserCourseResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'courseImage': instance.courseImage,
      'courseSlug': instance.courseSlug,
      'progress': instance.progress,
      'completedLessons': instance.completedLessons,
      'totalLessons': instance.totalLessons,
      'enrolledAt': instance.enrolledAt?.toIso8601String(),
      'lastAccessedAt': instance.lastAccessedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
