import 'package:json_annotation/json_annotation.dart';

part 'post_response.g.dart';

@JsonSerializable()
class PostResponse {
  final int id;
  final int userId;
  final String title;
  final String content;
  final int likes;
  final int dislikes;
  final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // User info (optional, depends on backend)
  final String? userName;
  final String? userAvatar;
  
  // Tags (optional)
  final List<String>? tags;

  PostResponse({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.likes,
    required this.dislikes,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userAvatar,
    this.tags,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostResponseToJson(this);
}

@JsonSerializable()
class PostListResponse {
  final List<PostResponse> content;
  final int totalElements;
  final int totalPages;
  final int number;
  final int size;
  final bool first;
  final bool last;

  PostListResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.number,
    required this.size,
    required this.first,
    required this.last,
  });

  factory PostListResponse.fromJson(Map<String, dynamic> json) =>
      _$PostListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostListResponseToJson(this);
}
