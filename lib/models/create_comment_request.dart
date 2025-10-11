import 'package:json_annotation/json_annotation.dart';

part 'create_comment_request.g.dart';

@JsonSerializable()
class CreateCommentRequest {
  final int userId;
  final int postId;
  final String content;

  CreateCommentRequest({
    required this.userId,
    required this.postId,
    required this.content,
  });

  factory CreateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCommentRequestToJson(this);
}
