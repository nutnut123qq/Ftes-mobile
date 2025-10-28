import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/instructor_profile.dart';

part 'instructor_profile_model.g.dart';

/// Instructor Profile model for JSON serialization
@JsonSerializable()
class InstructorProfileModel {
  final String id;
  final String username;
  final String name;
  final String email;
  final String phoneNumber;
  final String avatar;
  final String description;
  final String jobName;
  final String gender;
  final String dataOfBirth;
  final String facebook;
  final String twitter;
  final String youtube;
  final String role;
  final String userId;
  final String contentCourse;
  final String createdAt;
  final String updatedAt;

  const InstructorProfileModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatar,
    required this.description,
    required this.jobName,
    required this.gender,
    required this.dataOfBirth,
    required this.facebook,
    required this.twitter,
    required this.youtube,
    required this.role,
    required this.userId,
    required this.contentCourse,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InstructorProfileModel.fromJson(Map<String, dynamic> json) =>
      _$InstructorProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorProfileModelToJson(this);

  /// Convert to domain entity
  InstructorProfile toEntity() {
    return InstructorProfile(
      id: id,
      username: username,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      avatar: avatar,
      description: description,
      jobName: jobName,
      gender: gender,
      dataOfBirth: dataOfBirth,
      facebook: facebook,
      twitter: twitter,
      youtube: youtube,
      role: role,
      userId: userId,
      contentCourse: contentCourse,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
