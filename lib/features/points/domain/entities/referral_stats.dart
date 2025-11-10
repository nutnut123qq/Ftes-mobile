import 'package:equatable/equatable.dart';

class ReferralStats extends Equatable {
  final int totalInvited;
  final int totalActive;
  final int totalInactive;
  final int totalEarnings;

  const ReferralStats({
    this.totalInvited = 0,
    this.totalActive = 0,
    this.totalInactive = 0,
    this.totalEarnings = 0,
  });

  @override
  List<Object?> get props => [
    totalInvited,
    totalActive,
    totalInactive,
    totalEarnings,
  ];
}
