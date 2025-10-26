import 'package:json_annotation/json_annotation.dart';

part 'profile_request_model.g.dart';

/// Profile request model for creating/updating profile
@JsonSerializable(explicitToJson: true)
class ProfileRequestModel {
  final String? name;
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

  const ProfileRequestModel({
    this.name,
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
  });

  factory ProfileRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileRequestModelToJson(this);
}
