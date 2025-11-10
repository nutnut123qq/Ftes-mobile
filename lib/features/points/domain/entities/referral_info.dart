import 'package:equatable/equatable.dart';
import 'invited_user.dart';

class ReferralInfo extends Equatable {
  final String referralCode;
  final int totalReferrals;
  final int totalEarnings;
  final List<InvitedUser> invitedUsers;

  const ReferralInfo({
    this.referralCode = '',
    this.totalReferrals = 0,
    this.totalEarnings = 0,
    this.invitedUsers = const [],
  });

  @override
  List<Object?> get props => [
    referralCode,
    totalReferrals,
    totalEarnings,
    invitedUsers,
  ];
}
