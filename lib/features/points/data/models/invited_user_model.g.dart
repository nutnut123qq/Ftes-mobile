// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invited_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvitedUserModel _$InvitedUserModelFromJson(Map<String, dynamic> json) =>
    InvitedUserModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      invitedAtJson: InvitedUserModel._dateTimeFromJson(json['invitedAtJson']),
      status: json['status'] as String?,
      earnedPoints: (json['earnedPoints'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InvitedUserModelToJson(InvitedUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'fullName': instance.fullName,
      'invitedAtJson': InvitedUserModel._dateTimeToJson(instance.invitedAtJson),
      'status': instance.status,
      'earnedPoints': instance.earnedPoints,
    };
