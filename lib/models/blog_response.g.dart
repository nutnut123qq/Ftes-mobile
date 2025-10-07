// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogResponse _$BlogResponseFromJson(Map<String, dynamic> json) => BlogResponse(
  id: json['id'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  title: json['title'] as String?,
  content: json['content'] as String?,
  image: json['image'] as String?,
  emojis: (json['emojis'] as num?)?.toInt(),
  view: json['view'] as bool?,
  userName: json['userName'] as String?,
  fullname: json['fullname'] as String?,
  categoryName: json['categoryName'] as String?,
  slugName: json['slugName'] as String?,
);

Map<String, dynamic> _$BlogResponseToJson(BlogResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'title': instance.title,
      'content': instance.content,
      'image': instance.image,
      'emojis': instance.emojis,
      'view': instance.view,
      'userName': instance.userName,
      'fullname': instance.fullname,
      'categoryName': instance.categoryName,
      'slugName': instance.slugName,
    };

PagingBlogResponse _$PagingBlogResponseFromJson(Map<String, dynamic> json) =>
    PagingBlogResponse(
      currentPage: (json['currentPage'] as num?)?.toInt(),
      totalPage: (json['totalPage'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BlogResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PagingBlogResponseToJson(PagingBlogResponse instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPage': instance.totalPage,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'data': instance.data,
    };
