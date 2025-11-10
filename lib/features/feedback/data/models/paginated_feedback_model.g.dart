// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_feedback_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedFeedbackModel _$PaginatedFeedbackModelFromJson(
  Map<String, dynamic> json,
) => PaginatedFeedbackModel(
  content: (json['content'] as List<dynamic>)
      .map((e) => FeedbackModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalElements: (json['totalElements'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  currentPage: (json['number'] as num).toInt(),
  pageSize: (json['size'] as num).toInt(),
  isFirst: json['first'] as bool,
  isLast: json['last'] as bool,
);

Map<String, dynamic> _$PaginatedFeedbackModelToJson(
  PaginatedFeedbackModel instance,
) => <String, dynamic>{
  'content': instance.content.map((e) => e.toJson()).toList(),
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'number': instance.currentPage,
  'size': instance.pageSize,
  'first': instance.isFirst,
  'last': instance.isLast,
};
