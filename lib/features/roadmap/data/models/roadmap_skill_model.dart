import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/roadmap.dart';

part 'roadmap_skill_model.g.dart';

/// RoadmapSkill model for JSON serialization
@JsonSerializable(explicitToJson: true)
class RoadmapSkillModel {
  final String skill;
  @JsonKey(name: 'slug_name')
  final String? slugName;
  final String description;
  final int? term;

  const RoadmapSkillModel({
    required this.skill,
    this.slugName,
    required this.description,
    this.term,
  });

  factory RoadmapSkillModel.fromJson(Map<String, dynamic> json) =>
      _$RoadmapSkillModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoadmapSkillModelToJson(this);

  RoadmapSkill toEntity() {
    return RoadmapSkill(
      skill: skill,
      slugName: slugName ?? '',
      description: description,
      term: term ?? 1,
    );
  }
}
