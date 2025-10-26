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
  final String? phoneNumber;
  final String? avatar;
  final String? description;
  final String? jobName;
  final String? gender;
  final String? dataOfBirth;
  final String? facebook;
  final String? twitter;
  final String? youtube;
  final String? role;
  final String? userId;
  final String? contentCourse;
  
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  const ProfileModel({
    required this.id,
    required this.username,
    required this.name,
    this.email,
    this.phoneNumber,
    this.avatar,
    this.description,
    this.jobName,
    this.gender,
    this.dataOfBirth,
    this.facebook,
    this.twitter,
    this.youtube,
    this.role,
    this.userId,
    this.contentCourse,
    this.createdAt,
    this.updatedAt,
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
      phoneNumber: phoneNumber ?? '',
      avatar: avatar ?? '',
      description: description ?? '',
      jobName: jobName ?? '',
      gender: gender ?? '',
      dataOfBirth: dataOfBirth ?? '',
      facebook: facebook ?? '',
      twitter: twitter ?? '',
      youtube: youtube ?? '',
      role: role ?? '',
      userId: userId ?? '',
      contentCourse: contentCourse ?? '',
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
