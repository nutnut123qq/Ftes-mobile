import 'package:json_annotation/json_annotation.dart';

part 'generate_roadmap_request_model.g.dart';

/// Request model for generating roadmap
@JsonSerializable(explicitToJson: true)
class GenerateRoadmapRequestModel {
  final String specialization;
  @JsonKey(name: 'current_skills')
  final List<String> currentSkills;
  final int term;

  const GenerateRoadmapRequestModel({
    required this.specialization,
    required this.currentSkills,
    required this.term,
  });

  factory GenerateRoadmapRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GenerateRoadmapRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateRoadmapRequestModelToJson(this);
}
