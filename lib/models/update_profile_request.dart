import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request.g.dart';

enum Gender {
  @JsonValue('MALE')
  male,
  @JsonValue('FEMALE')
  female,
  @JsonValue('OTHER')
  other,
}

@JsonSerializable()
class UpdateProfileRequest {
  final String? name;
  final String? address;
  final String? phoneNumber;
  final String? avatar;
  @JsonKey(name: 'dob')
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String? description;
  final String? jobName;
  final String? facebook;
  final String? youtube;
  final String? twitter;

  const UpdateProfileRequest({
    this.name,
    this.address,
    this.phoneNumber,
    this.avatar,
    this.dateOfBirth,
    this.gender,
    this.description,
    this.jobName,
    this.facebook,
    this.youtube,
    this.twitter,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}
