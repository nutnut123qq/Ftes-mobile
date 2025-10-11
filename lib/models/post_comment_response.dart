import 'package:json_annotation/json_annotation.dart';

part 'post_comment_response.g.dart';

@JsonSerializable()
class PostCommentResponse {
  final int id;
  final int userId;
  final int postId;
  final String content;
  final int likes;
  final int dislikes;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // User info (optional)
  final String? userName;
  final String? userAvatar;

  PostCommentResponse({
    required this.id,
    required this.userId,
    required this.postId,
    required this.content,
    required this.likes,
    required this.dislikes,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userAvatar,
  });

  factory PostCommentResponse.fromJson(Map<String, dynamic> json) =>
      _$PostCommentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostCommentResponseToJson(this);
}

@JsonSerializable()
class CommentListResponse {
  final List<PostCommentResponse> content;
  final int totalElements;
  final int totalPages;
  final int number;
  final int size;
  final bool first;
  final bool last;

  CommentListResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.number,
    required this.size,
    required this.first,
    required this.last,
  });

  factory CommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommentListResponseToJson(this);
}
