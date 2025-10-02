import 'package:json_annotation/json_annotation.dart';

part 'user_request.g.dart';

@JsonSerializable()
class UserRegistrationRequest {
  final String email;
  final String password;
  final String username;

  const UserRegistrationRequest({
    required this.email,
    required this.password,
    required this.username,
  });

  factory UserRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationRequestToJson(this);
}

@JsonSerializable()
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}

@JsonSerializable()
class UpdateGmailRequest {
  final String newEmail;
  final String code;

  const UpdateGmailRequest({
    required this.newEmail,
    required this.code,
  });

  factory UpdateGmailRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateGmailRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateGmailRequestToJson(this);
}
