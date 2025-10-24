import 'package:equatable/equatable.dart';

/// User entity representing a user in the domain layer
class User extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String? fullName;
  final String? avatar;
  final String? role;
  final String? status;
  final bool? referral;
  final bool? enable2FA;
  final String? createdAt;
  final String? created;

  const User({
    required this.id,
    required this.email,
    this.username,
    this.fullName,
    this.avatar,
    this.role,
    this.status,
    this.referral,
    this.enable2FA,
    this.createdAt,
    this.created,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        fullName,
        avatar,
        role,
        status,
        referral,
        enable2FA,
        createdAt,
        created,
      ];
}
