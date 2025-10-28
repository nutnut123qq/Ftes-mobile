import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/roadmap.dart';
import 'roadmap_skill_model.dart';

part 'roadmap_response_model.g.dart';

/// CourseDetails model for API response
@JsonSerializable(explicitToJson: true)
class CourseDetailsModel {
  final bool success;
  final List<RoadmapSkillModel> data;

  const CourseDetailsModel({
    required this.success,
    required this.data,
  });

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$CourseDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseDetailsModelToJson(this);
}

/// RoadmapData model for API response
@JsonSerializable(explicitToJson: true)
class RoadmapDataModel {
  final List<String>? courses;
  @JsonKey(name: 'real_course_codes')
  final List<String>? realCourseCodes;
  @JsonKey(name: 'course_details')
  final CourseDetailsModel courseDetails;
  final int? term;

  const RoadmapDataModel({
    this.courses,
    this.realCourseCodes,
    required this.courseDetails,
    this.term,
  });

  factory RoadmapDataModel.fromJson(Map<String, dynamic> json) =>
      _$RoadmapDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoadmapDataModelToJson(this);
}

/// RoadmapResponse model for API response
@JsonSerializable(explicitToJson: true)
class RoadmapResponseModel {
  final bool success;
  final String message;
  final RoadmapDataModel data;

  const RoadmapResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RoadmapResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RoadmapResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoadmapResponseModelToJson(this);

  /// Convert to domain entity
  Roadmap toEntity({
    required List<String> currentSkills,
    required String specialization,
  }) {
    return Roadmap(
      currentSkills: currentSkills,
      skillsRoadMap: data.courseDetails.data.map((skill) => skill.toEntity()).toList(),
      term: data.term ?? 1,
      generationParams: GenerationParams(
        specialization: specialization,
        currentSkills: currentSkills,
        term: data.term ?? 1,
      ),
    );
  }
}
