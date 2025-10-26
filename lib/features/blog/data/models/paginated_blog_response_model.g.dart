// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_blog_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedBlogResponseModel _$PaginatedBlogResponseModelFromJson(
  Map<String, dynamic> json,
) => PaginatedBlogResponseModel(
  data: (json['data'] as List<dynamic>)
      .map((e) => BlogModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPages: PaginatedBlogResponseModel._intFromJson(json['totalPages']),
  totalElements: PaginatedBlogResponseModel._intFromJson(json['totalElements']),
  currentPage: PaginatedBlogResponseModel._intFromJson(json['currentPage']),
);

Map<String, dynamic> _$PaginatedBlogResponseModelToJson(
  PaginatedBlogResponseModel instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'totalPages': instance.totalPages,
  'totalElements': instance.totalElements,
  'currentPage': instance.currentPage,
};
