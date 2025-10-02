// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistrationRequest _$UserRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => UserRegistrationRequest(
  email: json['email'] as String,
  password: json['password'] as String,
  username: json['username'] as String,
);

Map<String, dynamic> _$UserRegistrationRequestToJson(
  UserRegistrationRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'username': instance.username,
};

ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => ChangePasswordRequest(
  currentPassword: json['currentPassword'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ChangePasswordRequestToJson(
  ChangePasswordRequest instance,
) => <String, dynamic>{
  'currentPassword': instance.currentPassword,
  'newPassword': instance.newPassword,
};

UpdateGmailRequest _$UpdateGmailRequestFromJson(Map<String, dynamic> json) =>
    UpdateGmailRequest(
      newEmail: json['newEmail'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$UpdateGmailRequestToJson(UpdateGmailRequest instance) =>
    <String, dynamic>{'newEmail': instance.newEmail, 'code': instance.code};
