import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/profile.dart';

part 'profile_model.g.dart';

/// Profile model for JSON serialization
@JsonSerializable(explicitToJson: true)
class ProfileModel {
  final String id;
  final String username;
  final String name;
  final String? email;
  final String? avatar;
  final String? description;
  final String? jobName;
  final String? facebook;
  final String? twitter;
  final String? youtube;

  const ProfileModel({
    required this.id,
    required this.username,
    required this.name,
    this.email,
    this.avatar,
    this.description,
    this.jobName,
    this.facebook,
    this.twitter,
    this.youtube,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  Profile toEntity() {
    return Profile(
      id: id,
      username: username,
      name: name,
      email: email ?? '',
      avatar: avatar,
      description: description,
      jobName: jobName,
      facebook: facebook,
      twitter: twitter,
      youtube: youtube,
    );
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      username: profile.username,
      name: profile.name,
      email: profile.email.isEmpty ? null : profile.email,
      avatar: profile.avatar,
      description: profile.description,
      jobName: profile.jobName,
      facebook: profile.facebook,
      twitter: profile.twitter,
      youtube: profile.youtube,
    );
  }
}
