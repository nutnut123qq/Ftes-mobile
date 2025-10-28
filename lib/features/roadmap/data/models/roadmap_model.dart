import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/roadmap.dart';
import 'roadmap_skill_model.dart';

part 'roadmap_model.g.dart';

/// GenerationParams model for JSON serialization
@JsonSerializable(explicitToJson: true)
class GenerationParamsModel {
  final String specialization;
  final List<String> currentSkills;
  final int term;

  const GenerationParamsModel({
    required this.specialization,
    required this.currentSkills,
    required this.term,
  });

  factory GenerationParamsModel.fromJson(Map<String, dynamic> json) =>
      _$GenerationParamsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenerationParamsModelToJson(this);

  GenerationParams toEntity() {
    return GenerationParams(
      specialization: specialization,
      currentSkills: currentSkills,
      term: term,
    );
  }
}

/// Roadmap model for JSON serialization
@JsonSerializable(explicitToJson: true)
class RoadmapModel {
  final List<String> currentSkills;
  final List<RoadmapSkillModel> skillsRoadMap;
  final int term;
  final GenerationParamsModel generationParams;

  const RoadmapModel({
    required this.currentSkills,
    required this.skillsRoadMap,
    required this.term,
    required this.generationParams,
  });

  factory RoadmapModel.fromJson(Map<String, dynamic> json) =>
      _$RoadmapModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoadmapModelToJson(this);

  Roadmap toEntity() {
    return Roadmap(
      currentSkills: currentSkills,
      skillsRoadMap: skillsRoadMap.map((skill) => skill.toEntity()).toList(),
      term: term,
      generationParams: generationParams.toEntity(),
    );
  }
}
