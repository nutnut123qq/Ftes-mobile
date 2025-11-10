import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/invited_user.dart';

part 'invited_user_model.g.dart';

@JsonSerializable()
class InvitedUserModel extends InvitedUser {
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? invitedAtJson;

  const InvitedUserModel({
    String? id,
    String? username,
    String? email,
    String? fullName,
    this.invitedAtJson,
    String? status,
    int? earnedPoints,
  }) : super(
         id: id ?? '',
         username: username ?? '',
         email: email ?? '',
         fullName: fullName ?? '',
         invitedAt: invitedAtJson,
         status: status ?? '',
         earnedPoints: earnedPoints ?? 0,
       );

  factory InvitedUserModel.fromJson(Map<String, dynamic> json) =>
      _$InvitedUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvitedUserModelToJson(this);

  InvitedUser toEntity() => InvitedUser(
    id: id,
    username: username,
    email: email,
    fullName: fullName,
    invitedAt: invitedAt,
    status: status,
    earnedPoints: earnedPoints,
  );

  static DateTime? _dateTimeFromJson(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();
}
