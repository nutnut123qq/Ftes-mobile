import 'package:equatable/equatable.dart';

class InvitedUser extends Equatable {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final DateTime? invitedAt;
  final String status;
  final int earnedPoints;

  const InvitedUser({
    this.id = '',
    this.username = '',
    this.email = '',
    this.fullName = '',
    this.invitedAt,
    this.status = '',
    this.earnedPoints = 0,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    fullName,
    invitedAt,
    status,
    earnedPoints,
  ];
}
