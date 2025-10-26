// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogModel _$BlogModelFromJson(Map<String, dynamic> json) => BlogModel(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  image: json['image'] as String,
  slugName: json['slugName'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  categoryName: json['categoryName'] as String,
  emojis: BlogModel._intFromJson(json['emojis']),
  view: BlogModel._boolFromJson(json['view']),
  userName: BlogModel._stringFromJson(json['userName']),
  fullname: BlogModel._stringFromJson(json['fullname']),
  technology: json['technology'] as String?,
  comment: json['comment'] as String?,
  des: json['des'] as String?,
);

Map<String, dynamic> _$BlogModelToJson(BlogModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'image': instance.image,
  'slugName': instance.slugName,
  'createdAt': instance.createdAt.toIso8601String(),
  'categoryName': instance.categoryName,
  'emojis': instance.emojis,
  'view': instance.view,
  'userName': instance.userName,
  'fullname': instance.fullname,
  'technology': instance.technology,
  'comment': instance.comment,
  'des': instance.des,
};
