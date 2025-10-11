import 'package:json_annotation/json_annotation.dart';

part 'feedback_response.g.dart';

@JsonSerializable()
class FeedbackResponse {
  final int id;
  final int userId;
  final int courseId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Optional user info
  final String? userName;
  final String? userAvatar;

  FeedbackResponse({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userAvatar,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedbackResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackResponseToJson(this);
}

@JsonSerializable()
class FeedbackListResponse {
  final List<FeedbackResponse> content;
  final int totalElements;
  final int totalPages;
  final int number; // current page number
  final int size;
  final bool first;
  final bool last;

  FeedbackListResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.number,
    required this.size,
    required this.first,
    required this.last,
  });

  factory FeedbackListResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedbackListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackListResponseToJson(this);
}
