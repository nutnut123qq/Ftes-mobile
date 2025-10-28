// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerationParamsModel _$GenerationParamsModelFromJson(
  Map<String, dynamic> json,
) => GenerationParamsModel(
  specialization: json['specialization'] as String,
  currentSkills: (json['currentSkills'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  term: (json['term'] as num).toInt(),
);

Map<String, dynamic> _$GenerationParamsModelToJson(
  GenerationParamsModel instance,
) => <String, dynamic>{
  'specialization': instance.specialization,
  'currentSkills': instance.currentSkills,
  'term': instance.term,
};

RoadmapModel _$RoadmapModelFromJson(Map<String, dynamic> json) => RoadmapModel(
  currentSkills: (json['currentSkills'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  skillsRoadMap: (json['skillsRoadMap'] as List<dynamic>)
      .map((e) => RoadmapSkillModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  term: (json['term'] as num).toInt(),
  generationParams: GenerationParamsModel.fromJson(
    json['generationParams'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$RoadmapModelToJson(RoadmapModel instance) =>
    <String, dynamic>{
      'currentSkills': instance.currentSkills,
      'skillsRoadMap': instance.skillsRoadMap.map((e) => e.toJson()).toList(),
      'term': instance.term,
      'generationParams': instance.generationParams.toJson(),
    };
