import 'package:json_annotation/json_annotation.dart';

part 'profile_response.g.dart';

enum Gender {
  @JsonValue('MALE')
  male,
  @JsonValue('FEMALE')
  female,
  @JsonValue('OTHER')
  other,
}

@JsonSerializable()
class ProfileResponse {
  final String? id;
  final String? userId;
  final String? name;
  final String? email;
  final String? username;
  final String? role;
  final String? phoneNumber;
  final String? address;
  final Gender? gender;
  @JsonKey(name: 'dateOfBirth')
  final DateTime? dateOfBirth;
  final String? avatar;
  @JsonKey(name: 'isDarkMode')
  final bool? isDarkMode;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  final String? description;
  final String? jobName;
  final String? facebook;
  final String? youtube;
  final String? twitter;
  final List<PostResponse>? posts;

  const ProfileResponse({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.username,
    this.role,
    this.phoneNumber,
    this.address,
    this.gender,
    this.dateOfBirth,
    this.avatar,
    this.isDarkMode,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.jobName,
    this.facebook,
    this.youtube,
    this.twitter,
    this.posts,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}

@JsonSerializable()
class PostResponse {
  final String? id;
  final String? title;
  final String? content;
  final String? authorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PostResponse({
    this.id,
    this.title,
    this.content,
    this.authorId,
    this.createdAt,
    this.updatedAt,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostResponseToJson(this);
}
