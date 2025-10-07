import 'package:json_annotation/json_annotation.dart';

part 'blog_response.g.dart';

@JsonSerializable()
class BlogResponse {
  final String? id;
  final DateTime? createdAt;
  final String? title;
  final String? content;
  final String? image;
  final int? emojis;
  final bool? view;
  final String? userName;
  final String? fullname;
  final String? categoryName;
  final String? slugName;

  const BlogResponse({
    this.id,
    this.createdAt,
    this.title,
    this.content,
    this.image,
    this.emojis,
    this.view,
    this.userName,
    this.fullname,
    this.categoryName,
    this.slugName,
  });

  factory BlogResponse.fromJson(Map<String, dynamic> json) =>
      _$BlogResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BlogResponseToJson(this);
}

@JsonSerializable()
class PagingBlogResponse {
  final int? currentPage;
  final int? totalPage;
  final int? pageSize;
  final int? totalCount;
  final List<BlogResponse>? data;

  const PagingBlogResponse({
    this.currentPage,
    this.totalPage,
    this.pageSize,
    this.totalCount,
    this.data,
  });

  factory PagingBlogResponse.fromJson(Map<String, dynamic> json) =>
      _$PagingBlogResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PagingBlogResponseToJson(this);
}
