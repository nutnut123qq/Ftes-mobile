import 'package:json_annotation/json_annotation.dart';

part 'create_post_request.g.dart';

@JsonSerializable()
class CreatePostRequest {
  final int userId;
  final String title;
  final String content;
  final List<String>? tags;

  CreatePostRequest({
    required this.userId,
    required this.title,
    required this.content,
    this.tags,
  });

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostRequestToJson(this);
}
