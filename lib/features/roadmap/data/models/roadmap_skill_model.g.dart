// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_skill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadmapSkillModel _$RoadmapSkillModelFromJson(Map<String, dynamic> json) =>
    RoadmapSkillModel(
      skill: json['skill'] as String,
      slugName: json['slug_name'] as String?,
      description: json['description'] as String,
      term: (json['term'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RoadmapSkillModelToJson(RoadmapSkillModel instance) =>
    <String, dynamic>{
      'skill': instance.skill,
      'slug_name': instance.slugName,
      'description': instance.description,
      'term': instance.term,
    };
