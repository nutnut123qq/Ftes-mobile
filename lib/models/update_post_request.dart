import 'package:json_annotation/json_annotation.dart';

part 'update_post_request.g.dart';

@JsonSerializable()
class UpdatePostRequest {
  final String title;
  final String content;
  final List<String>? tags;

  UpdatePostRequest({
    required this.title,
    required this.content,
    this.tags,
  });

  factory UpdatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePostRequestToJson(this);
}
