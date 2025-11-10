import 'package:equatable/equatable.dart';

class SetReferralCommand extends Equatable {
  final String referralCode;

  const SetReferralCommand({required this.referralCode});

  @override
  List<Object?> get props => [referralCode];
}
