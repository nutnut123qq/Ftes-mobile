// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_roadmap_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateRoadmapRequestModel _$GenerateRoadmapRequestModelFromJson(
  Map<String, dynamic> json,
) => GenerateRoadmapRequestModel(
  specialization: json['specialization'] as String,
  currentSkills: (json['current_skills'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  term: (json['term'] as num).toInt(),
);

Map<String, dynamic> _$GenerateRoadmapRequestModelToJson(
  GenerateRoadmapRequestModel instance,
) => <String, dynamic>{
  'specialization': instance.specialization,
  'current_skills': instance.currentSkills,
  'term': instance.term,
};
