// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseDetailsModel _$CourseDetailsModelFromJson(Map<String, dynamic> json) =>
    CourseDetailsModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => RoadmapSkillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseDetailsModelToJson(CourseDetailsModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

RoadmapDataModel _$RoadmapDataModelFromJson(Map<String, dynamic> json) =>
    RoadmapDataModel(
      courses: (json['courses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      realCourseCodes: (json['real_course_codes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      courseDetails: CourseDetailsModel.fromJson(
        json['course_details'] as Map<String, dynamic>,
      ),
      term: (json['term'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RoadmapDataModelToJson(RoadmapDataModel instance) =>
    <String, dynamic>{
      'courses': instance.courses,
      'real_course_codes': instance.realCourseCodes,
      'course_details': instance.courseDetails.toJson(),
      'term': instance.term,
    };

RoadmapResponseModel _$RoadmapResponseModelFromJson(
  Map<String, dynamic> json,
) => RoadmapResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: RoadmapDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RoadmapResponseModelToJson(
  RoadmapResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.toJson(),
};
